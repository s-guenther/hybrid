function [tout, yout] = solve_fhandle_sdode(build, decay, opt)
% SOLVE_FHANDLE_SDODE specialized SDODE solver for function handles
%
% [TOUT, YOUT] = SOLVE_FHANDLE_SDODE(BUILD, DECAY, OPT)
%
% See also SOLVE_SDODE.

odesol = opt.continuous_solver;
ode = @(t, y) sdode(t, y, build.fcn, decay.fcn);

[tout, yout] = odesol(ode, [0 build.period], 0, opt.odeset);

end


% LOCAL FUNCTIONS
 
function dydt = sdode(t, y, build_fcn, decay_fcn, build_cond, decay_cond)
% SDODE integrates build or decay fcn depending on build cond 
%
% ODE where build_fcn is integrated if build_cond holds true and decay_fcn
% is integrated if decay_cond holds true.
% Default behaviour: integrate build fcn if it is positive, else reduce
% integral with decay fcn 
%
% Input:
%   t           ode input arg time
%   y           ode input arg state
%   build_fcn   fcn handle, will be integrated if build_cond is true,
%               function of t
%   decay_fcn   fcn handle, will be integrated if decay_cond is true,
%               function of t
%   build_cond  optional, default: see below; 
%               fcn handle, logical expression controlling build fcn,
%               function of t, y, build_val, decay_val
%   decay_cond  optional, default: see below; 
%               fcn handle, logical expression controlling decay fcn,
%               function of t, y, build_val, decay_val
% Output:
%   dydt        ode output arg derivative state
%
% default build_cond: true if build >= 0, 
% default decay_cond: true if build_cond == 0 & y > 0 & decay < 0
% 
% It is intended that only a maximum of one condition holds true. It is
% possible to formulate conditions where both can be true. Then, the build
% and decay will be superpositioned. The user is responsible for
% formulating consistent build and decay conditions
%
% Code is vectorized.
%
% If function is called w/o parameters, the build and decay function will
% be returned as a cell array of strings. These can be evaluated with
% build_cond = eval(out{1})     and     decay_cond = eval(out{2})

if nargin == 0
    dydt = {'@(t, y, build_val, decay_val) build_val >= 0;';
            '@(t, y, build_val, decay_val) build_val <= 0 & y > 0 & decay_val <= 0;'};
    return
end

if nargin < 5
    build_cond = @(t, y, build_val, decay_val) build_val > 0;
end
if nargin < 6
    decay_cond = @(t, y, build_val, decay_val) build_val <= 0 & ...
                                               y > 0 & ...
                                               decay_val <= 0;
end

build_val = build_fcn(t);
decay_val = decay_fcn(t);
build_bool = build_cond(t, y, build_val, decay_val);
decay_bool = decay_cond(t, y, build_val, decay_val);

dydt = build_val.*build_bool + decay_val.*decay_bool;

end
