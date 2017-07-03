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
assert(abs(yout(end)/max(yout)) < opt.int_zero_rel_tol, ...
       ['Unable to meet decay end condition in SDODE - '
        'impossible storage config']);

sdfcn.time = tout;
sdfcn.val = yout;

end
