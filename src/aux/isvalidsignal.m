function [valid, errmsg] = isvalidsignal(signal, opt)
% ISVALIDSIGNAL checks if signal fulfils the requirements of theory
%
% The signal subject to analysis must fulfil a few requirements to produce
% meaningful results and to prevent unexpected program behaviour. These are
%   -  must have average mean value of zero
%   -  integral must be zero at beginning and end
%   -  integral must not drop below zero within whole period
%
% [VALID, ERRMSG] = ISVALIDSIGNAL(SIGNAL, <OPT>) where SIGNAL is a struct obtained
% from GEN_SIGNAL. VALID is boolean, ERRMSG is an error message in case
% VALID is FALSE. Options are provided via OPT from HYBRIDSET.
%
% See also GEN_SIGNAL.

% Does have all fields in struct?
commonfields = isfield(signal, ...
                       {'period', 'amplitude', 'maxint', 'rms', 'arv', ...
                        'form', 'crest', 'type'});
if ~all(commonfields)
    valid = 0;
    errmsg = 'Signal struct is incomplete';
end

switch signal.type
    case
    case
    otherwise
end

% ARV zero?

% int above zero?

% int zero at end?

end
