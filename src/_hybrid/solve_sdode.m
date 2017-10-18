function sdfcn = solve_sdode(build, decay, opt)
% SOLVE_SDODE calculates sdode for build and decay signals
%
% Takes build and decay functions as inputs, builds the switched decay ode
% and solves it.
%
% SDFCN = SOLVE_SDODE(BUILD, DECAY, <OPT>) where BUILD and DECAY are
% obtained by GEN_BUILD_DECAY and the problem is solved using the options
% OPT (obtained from HYBRIDSET). Default OPT is OPT = HYBRIDSET().
%
% Output:
%   SDFCN.time  n x 1 time vector
%   SDFCN.val   n x 1 value vectur
%
% See also HYBRID_PAIR, GEN_BUILD_DECAY.

if nargin < 3
    opt = hybridset();
end

% choose solver depending on type
switch lower(build.type)
    case 'fhandle'
        [tout, yout] = solve_fhandle_sdode(build, decay, opt);
    case {'linear', 'step'}
        [tout, yout] = solve_discrete_sdode(build, decay, opt);
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

% check validity
int_zero_rel_err = abs(yout(end)/build.maxint);
if isnan(int_zero_rel_err) % Prevent zero division error
    int_zero_rel_err = 0;
end
assert(int_zero_rel_err < opt.int_zero_rel_tol, ...
       ['Unable to meet decay end condition in SDODE.', ...
        'Relative error is ', num2str(int_zero_rel_err), ...
        ', allowed error is ', num2str(opt.int_zero_rel_tol), ...
        '. Try tuning ''odeset'' parameters or change the allowed ', ...
        'tolerance ''int_zero_rel_tol''.']);

% write output
sdfcn.type = build.type;
sdfcn.amplitude = max(yout);
sdfcn.period = build.period;
switch lower(sdfcn.type)
    case 'fhandle'
        sdfcn.fcn = @(tt) interp1(tout, yout, tt, opt.interbwint);
    case {'linear', 'step'}
        [tout, yout] = solve_discrete_sdode(build, decay, opt);
        sdfcn.time = tout;
        sdfcn.val = yout;
end


end
