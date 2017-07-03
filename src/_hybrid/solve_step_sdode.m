function [tout, yout] = solve_step_sdode(build, decay, opt)
% SOLVE_STEP_SDODE specialized SDODE solver for discrete fcns
%
% [TOUT, YOUT] = SOLVE_STEP_SDODE(BUILD, DECAY, OPT)
%
% See also SOLVE_SDODE.

% Allocate result vectors
tout = zeros(size(build.val));
yout = zeros(size(build.val));
 
% Initial conditions, integration steps, and ode initialization
tlast = 0;
ylast = 0;
timestep = diff([0; build.val]);
discrete_ode = @(ii, yy) sdode(ii, yy, build.val, decay.val);

% second control variable as there may be steps in between original steps
% in result vector (if peak storage runs empty in between a timestep
jj = 1;
% Loop through integration
for ii = 1:length(build.val)
    % allocate new space if needed
    if jj > length(tout)
        tout = [tout; zeros(size(tout))]; %#ok
        yout = [yout; zeros(size(yout))]; %#ok
    end

    % naive one-step integration
    tnew = tlast + timestep(ii);
    ynew = ylast + discrete_ode(ii, ylast)*timestep(ii);

    % Write to output if result is fine
    if ynew >= 0
        tout(jj) = tnew;
        yout(jj) = ynew;
    % Else repair result if integral gets negative
    else
        [tinter, yinter] = repair_step(tlast, tnew, ylast, ynew);
        tout(jj:jj+1) = tinter;
        yout(jj:jj+1) = yinter;
        ynew = 0;
        jj = jj + 1;
    end
    jj = jj + 1;
    tlast = tnew;
    ylast = ynew;

end

% remove unneccessary allocation
tout = tout(jj:end);
yout = yout(jj:end);

if strcmpi(opt.discrete_solver, 'time_preserving')
    warning('HYBRID:discrete_solver', ...
            'Solver varaint ''exact'', not implemented at the moment')
end

end


% LOCAL FUNCTIONS
 
function dydt = sdode(ii, yy, build_vec, decay_vec, build_cond, decay_cond)
% SDODE integrates build or decay fcn, discrete implementation
%
% ODE where build_fcn is integrated if build_cond holds true and decay_fcn
% is integrated if decay_cond holds true.
% Default behaviour: integrate build fcn if it is positive, else reduce
% integral with decay fcn 
%
% Input:
%   ii          discrete step
%   y           last value of integral
%   build_vec   value vector of build function, will be integrated if
%               build_cond is true, function of step ii, implicitely of
%               time
%   decay_vec   value vector of decay function, will be integrated if
%               decay_cond is true, function of step ii, implicitely of
%               time
%   decay_vec   fcn handle, will be integrated if decay_cond is true,
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
    dydt = {'@(ii, yy, build_val, decay_val) build_val >= 0;';
            ['@(ii, yy, build_val, decay_val) ', ...
             'build_val <= 0 & yy > 0 & decay_val <= 0;']};
    return
end

if nargin < 5
    build_cond = @(ii, yy, build_val, decay_val) build_val > 0;
end
if nargin < 6
    decay_cond = @(ii, yy, build_val, decay_val) ...
                 build_val <= 0 & yy > 0 & decay_val <= 0;
end

build_val = build_vec(ii);
decay_val = decay_vec(ii);
build_bool = build_cond(ii, yy, build_val, decay_val);
decay_bool = decay_cond(ii, yy, build_val, decay_val);

dydt = build_val.*build_bool + decay_val.*decay_bool;

end


function [tinter, yinter] = repair_step(t1, t2, y1, y2)
% If integration step drops below zero, it is corrected to zero and the
% point in time where this happens is determined.

tinter = [y1/(y1 - y2); 1]*(t2 - t1) + t1;
yinter = [0; 0];

end
