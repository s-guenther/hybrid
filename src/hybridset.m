function options = hybridset(varargin)
% HYBRIDSET Create or alter hybrid OPTIONS structure
%
% TODO add description

% TODO add alter options similar to odeset and optimset

prsr = inputParser();

% Discrete Solver
default = 'exact';
validate = @(sol) any(validatestring(sol, {'exact', 'time_preserving'}));
prsr.addParameter('discrete_solver', default, validate);

% Continuous Solver
default = @ode45;
validate = @(sol) isa(sol, 'function_handle') && ...
                  any(validatestring(func2str(sol)), ...
                      {'ode23', 'ode45', 'ode15s', 'ode113', ...
                       'ode23s', 'ode23t', 'ode23tb'});
prsr.addParameter('continuous_solver', default, validate) 

% Odeset
default = odeset('RelTol', 1e-5, 'MaxStep', 1e-1);
validate = @isstruct;
prsr.addParameter('odeset', default, validate);

% Optimset
prsr.addParameter('optimset', optimset(), @isstruct);

% Cut
cut_fcn = @(x) x - 0.12*sin(2*pi*x);
cut = cut_fcn(linspace(0, 1, 8));
default = cut(:);
validate = @(cut) isvector(cut) && all(cut <=1) && all(cut >= 0);
prsr.addParameter('cut', default, validate);

% Tanh gradient for analytical approximation (speed up ode solver) DEFERRED
prsr.addParameter('tanh', 0, @isnumeric)

% Average mean value relative tolerance
prsr.addParameter('amv_rel_tol', 1e-5, @isnumeric);
 
% Integral Negativity relative tolerance
prsr.addParameter('int_neg_rel_tol', 1e-5, @isnumeric);

% Integral end condition relativ tolerance
prsr.addParameter('int_zero_rel_tol', 1e-5, @isnumeric);

% Dismissed power rel tol
prsr.addParameter('dismissed_power_rel_tol', 1e-5, @isnumeric);
 
% Verbosity level of calculations
default = 0;
validate = @(in) isinteger(in) && (in == 0 || in == 1 || in == 2);
prsr.addParameter('verbose', default, validate);
 
% Plot Output
prsr.addParameter('plot_sig', 100, @isinteger);
prsr.addParameter('plot_hyb', 101, @isinteger);
prsr.addParameter('plot_eco', 102, @isinteger);
prsr.addParameter('plot_sim', 103, @isinteger);
prsr.addParameter('plot_stor', 0, @isinteger);
 
% check_asserts ?
% samplepoints ?
% log ?

prsr.parse(varargin{:})

options = prsr.Results;

end
