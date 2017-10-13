function [valid, errmsg] = isvalidsignal(signal, opt)
% ISVALIDSIGNAL checks if signal fulfils the requirements of theory
%
% The signal subject to analysis must fulfil a few requirements to produce
% meaningful results and to prevent unexpected program behaviour. These are
%   -  must have average mean value of zero
%   -  integral must be zero at beginning and end
%   -  integral must not drop below zero within whole period
%
% [VALID, ERRMSG] = ISVALIDSIGNAL(SIGNAL, <OPT>) where SIGNAL is a struct
% obtained from GEN_SIGNAL. VALID is boolean, ERRMSG is an error message in
% case VALID is FALSE. Options are provided via OPT from HYBRIDSET.
%
% See also GEN_SIGNAL.

if nargin < 2
    opt = hybridset();
end

verbose(opt.verbose, 1, ...
        'Validating Signal.')

% is signal a struct?
if ~isstruct(signal)
    valid = 0;
    errmsg = 'Signal is no struct';
    return
end

% Does have all fields in struct?
commonfields = isfield(signal, ...
                       {'period', 'amplitude', 'maxint', 'rms', 'arv', ...
                        'form', 'crest', 'type'});

switch lower(signal.type)
    case 'fhandle'
        specialfields = isfield(signal, 'fcn');
    case {'step', 'linear'}
        specialfields = isfield(signal, {'time', 'val'});
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

if ~all([commonfields, specialfields])
    valid = 0;
    errmsg = 'Signal struct is incomplete';
    return
end


% AMV zero?
% int above zero?
 
switch lower(signal.type)
    case 'fhandle'
        % TODO use 'integral' instead of 'ode'?
        odesol = opt.continuous_solver;    
        [~, yout] = odesol(@(tt, yy) signal.fcn(tt), ...
                           [0 signal.period], ...
                           0, ...
                           opt.odeset);
    case 'step'
        stepints = diff([0; signal.time]).*signal.val;
        yout = cumsum(stepints);
    case 'linear'
        yout = cumtrapz(signal.time, signal.val);
end
amv = yout(end);
amv_rel_err = abs(amv)/max(yout);
minint = min(yout);
int_neg_rel_err = minint/max(yout);

if amv_rel_err > opt.amv_rel_tol
    valid = 0;
    errmsg = ['Average mean value is not zero. (Exceeded tolerance ', ...
              'by a\nfactor of ', ...
              num2str(amv_rel_err/opt.amv_rel_tol), ...
              '. Allowed tolerance is ', ...
              num2str(opt.amv_rel_tol), '.'];
    return
end
if int_neg_rel_err < -opt.int_neg_rel_tol
    valid = 0;
    errmsg = ['Integral drops below zero. (Exceeded tolerance ', ...
              'by a\nfactor of ', ...
              num2str(abs(int_neg_rel_err)/opt.int_neg_rel_tol), ...
              '. Allowed tolerance is ', ...
              num2str(opt.int_neg_rel_tol), '.'];
    return
end

valid = 1;
errmsg = '';

% TODO Implement: ask for attept to resolve minint error

end
