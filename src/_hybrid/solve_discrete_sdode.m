function [tout, yout] = solve_discrete_sdode(build, decay, opt)
% SOLVE_DISCRETE_SDODE specialized SDODE solver for discrete fcns
%
% [TOUT, YOUT] = SOLVE_DISCRETE_SDODE(BUILD, DECAY, OPT)
%
% See also SOLVE_SDODE.

% Allocate space for result vectors
tout = zeros(2*length(build.val), 1);
yout = zeros(2*length(build.val), 1);
 
% Set solvers and other functions or vectors depending on fcn type 'step'
% or 'linear'
if strcmpi(build.type, 'step')
    % virtually add 0 at start to make vector size compatible to 'linear'
    times = [0; build.val];
    sdode = @(ii, yy) discrete_sdode(ii, yy, [0; build.val], [0; decay.val]);
    int_one_step = @int_step_fcn;
    repair_int = @repair_step_int;
elseif strcmpi(build.type, 'linear')
    times = build.val;
    sdode = @(ii, yy) discrete_sdode(ii, yy, build.val, decay.val);
    int_one_step = @int_linear_fcn;
    repair_int = @repair_linear_int;
end


% second control variable jj introduced as there may be steps in between
% original steps in result vector (if peak storage runs empty in between a
% timestep) start at 2 because initial condition is implicitly set to zero
jj = 2;
% Loop through integration
for ii = 2:length(times)
    % allocate new space if needed
    if jj > length(tout)
        tout = [tout; zeros(size(tout))]; %#ok
        yout = [yout; zeros(size(yout))]; %#ok
    end

    % naive one-step integration
    tout(jj) = times(ii);
    yout(jj) = int_one_step(sdode, ii, tout(jj) - tout(jj-1), yout(jj-1));

    % Repair result if integral gets negative
    if yout(jj) < 0
        [tinter, yinter] = repair_int(tout(jj-1), tout(jj), ...
                                      yout(jj-1), yout(jj), ...
                                      sdode(jj-1), sdode(jj));
        tout(jj:jj+1) = tinter;
        yout(jj:jj+1) = yinter;
        jj = jj + 1;
    end
    jj = jj + 1;
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
 
function dydt = discrete_sdode(ii, yy, build_vec, decay_vec, ...
                               build_cond, decay_cond)
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

function yout = int_step_fcn(sdode, ii, tstep, ylast)
% naive integration of one time step, assuming an input function with
% constant steps

yout = ylast + sdode(ii, ylast)*tstep;

end


function yout = int_linear_fcn(sdode, ii, tstep, ylast)
% naive integration of one time step, assuming an input function with
% linear pieces between two points

dy_start = sdode(ii-1, ylast);
dy_end = sdode(ii, ylast);
yout = ylast + trapz([0 tstep], [dy_start dy_end]);

end


function [tinter, yinter] = repair_step_int(t1, t2, y1, y2, dy1, dy2) %#ok
% If integration step drops below zero, it is corrected to zero and the
% point in time where this happens is determined.

tinter = [y1/(y1 - y2); 1]*(t2 - t1) + t1;
yinter = [0; 0];

end


function [tinter, yinter] = repair_linear_int(t1, t2, y1, y2, dy1, dy2) %#ok
% If integration step drops below zero, it is corrected to zero and the
% point in time where this happens is determined.

% integral is a quadratically falling equation of the form
%   y = a*t^2 + b*t + c
%   y = 0.5*m*t^2 + p1*t + y1
%   with    m = (p2-p1)/(t2 - t1), 
%           (p1 & p2) <= 0,
%           t1 < t2

% coefficients of quadratic equation
a = 0.5*(dy2 - dy1)/(t2 - t1);
b = dy1;
c = y1;

% solve quadratic equation for t
r = roots(a, b, c);
% take root which is within t1 and t2
tmid = r.*(r > t1 & r < t2);

% write output
tinter = [tmid; t2];
yinter = [0; 0];

end
