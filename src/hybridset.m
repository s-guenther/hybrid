function options = hybridset(varargin)
% HYBRIDSET Create or alter hybrid OPTIONS structure
%
% OPTIONS = HYBRIDSET('NAME1', VALUE1, 'NAME2', VALUE2, ...) creates a
% hybrid toolbox options structure OPTIONS in which the named properies
% have the specified values. Any unspecified properties have default
% values.
%
% HYBRIDSET PROPERTIES
%
% cut - Vector of cut values at which the hybridisation curve will be
%   evaluated. Values must be ascending and in interval [0..1]. 
%   Defaults to [0, 0.15, 0.3, 0.5, 0.75, 1].
%
% verbose - Verbosity level of toolbox. Sets the amount of information the
%   user will be provided with during the calculation. Can be 0, 1 or 2.
%   Default is 0, which means no info messages appear and the calculation
%   runs silently. Higher values result in more info messages.
%
% discrete_solver - Solver which is used if the signal is of discrete type
%   'step' or 'linear'. Can be 'exact' or 'time_preserving'. Default is
%   'exact', which inserts extra timesteps into original vector value pair
%   if neccessary (If a storage runs full/empty in between a timestep).
%   Option 'time_preserving' does this not.
% continuous_solver - ode solver which is used for continuous signal
%   'fhandle'. Must be a function handle to an existing Matlab ODE solver.
%   Default is @ode45.
% odeset - ode options structure generated by ODESET which is used by the
%   continuous solver. Default is odeset('RelTol', 1e-6, 'MaxStep', 1e-1).
% optimset - ode options structure generated by OPTIMSET which is used to
%   calculate some signal parameters. Default is optimset() (without
%   parameters).
%
% amv_rel_tol - Average mean value relative tolerance. Default is 1e-4. The
%   input signal has to have an AMV of zero. amv_rel_tol defines the allowed
%   relative deviation from this requirement.
% int_neg_rel_tol - Negative integral relative tolerance. Default is 1e-4.
%   The integral of the input signal is not allowed to become negative
%   within the whole period. This defines the allowed temporary violation
%   of this requirement.
% int_zero_rel_tol - Zero integral relative tolerance. Default is 1e-4. The
%   integral of the signal must be zero at the end of the period to ensure
%   real periodicity. This is the allowed violation of this requirement.
% dismissed_power_rel_tol - Dismissed power relative tolerance. Default is
%   1e-4. If the control for a specific case is simulated to view or verify a
%   dimensioning result in operation, the input power must always match the
%   power of the storages. Due to numeric errors, this may fail at some
%   points in time. This value defines the integral error which is allowed
%   to occur to still accept the result as valid.
% 
% interhyb - Interpolation method for the hybridisation curve. Default is
%   'linear'. Can be 'linear', 'pchip' or 'spline'. Be aware that 'pchip'
%   and 'spline' may produce peculiar shapes if hybridisation curve is
%   evaluated at adverse sampling cut points.
% interbwint - Interpolation method for the backward integral if signal
%   type is 'fhandle'. The backward integral is obtained through numerical
%   integration, to subsequently gain a function handle again, this result
%   is interpolated. Default is 'pchip'. Can be 'linear', 'pchip' or
%   'spline'.
%
% tanh - Hyperbolic tangent gradient. This options allows a smoothing of
%   discontinuities within an input signal of type 'fhandle'. Note that
%   this discontinuities emerge inevitably within the power splitting
%   procedure independent of the input function. This can slow down ode
%   integration significantly and a tanh approximation at discontinuities
%   may help to resolve this issue. Use this option only if the original
%   signal does not show discontinuities, else try the conv option. Default
%   is 0, which means disabled. Higher values lead to steeper rises, which
%   is closer to the real signal but will again lead to higher integration
%   times.
% conv - Convolution core. This allows a smoothing of discontinuities
%   within the signal of type 'fhandle'. See option tanh for more
%   information to this issue. Use this option for input signals with
%   discontinuities. Default is 0, which means disabled. The numeric value
%   describes the size of the smoothing core. Smaller values are closer to
%   the original signal, higher values lead to higher smoothing. See also
%   conv_sampling in context with this option
% conv_sampling - Convolution sampling points. Default is 1e5. To perform a
%   numeric convolution, the original input continuous signal must be
%   sampled at discrete points. This number is the total number of sampling
%   points within a period. Subsequently, the discrete result is
%   interpolated again with 'pchip'. This option takes only effect if
%   option conv is not 0
%
% plot_sig - Plot Signal after generation. Must be a positive integer.
%   Defines the figure in which the result will be plotted after
%   calculation. If set to 0, no plot will be generated automatically.
%   Default is 100.
% plot_hyb - Plot hybridisation diagram after calculation. Must be a
%   positive integer. Defines the figure in which the result will be
%   plotted after calculation. If set to 0, no plot will be generated
%   automatically. Default is 101.
% plot_eco - Plot hybridisation diagram with economic investigation after
%   calculation. Must be a positive integer. Defines the figure in which
%   the result will be plotted after calculation. If set to 0, no plot will
%   be generated automatically. Default is 102.
% plot_sim - Plot simulation result of operation after calculation. Must be
%   a positive integer. Defines the figure in which the result will be
%   plotted after calculation. If set to 0, no plot will be generated
%   automatically. Default is 103.
% plot_stor - Plot storage data after generation. Must be a positive
%   integer. Defines the figure in which the result will be plotted after
%   calculation. If set to 0, no plot will be generated automatically.
%   Default is 0.
%
% See also GEN_SIGNAL, HYBRID, SIM_OPERATION, GEN_STORAGES, ECO.

% TODO add alter options similar to odeset and optimset

prsr = inputParser();

% Discrete Solver
default = 'exact';
validate = @(sol) any(validatestring(sol, {'exact', 'time_preserving'}));
prsr.addParameter('discrete_solver', default, validate);

% Continuous Solver
default = @ode45;
validate = @(sol) isa(sol, 'function_handle') && ...
                  any(validatestring(func2str(sol), ...
                      {'ode23', 'ode45', 'ode15s', 'ode113', ...
                       'ode23s', 'ode23t', 'ode23tb'}));
prsr.addParameter('continuous_solver', default, validate) 

% Odeset
default = odeset('RelTol', 1e-6, 'MaxStep', 1e-1);
validate = @isstruct;
prsr.addParameter('odeset', default, validate);

% Optimset
prsr.addParameter('optimset', optimset(), @isstruct)

% Interpolation of Hybridisation Curve
default = 'linear';
validate = @(interp) any(validatestring(interp, ...
                         {'linear', 'pchip', 'spline'}));
prsr.addParameter('interhyb', default, validate)

% Interpolation Function for continuous results (backward integral)
default = 'pchip';
validate = @(interp) any(validatestring(interp, ...
                         {'linear', 'pchip', 'spline'}));
prsr.addParameter('interbwint', default, validate)

% Cut
cut = [0, 0.15, 0.3, 0.5, 0.75, 1];
default = cut(:);
validate = @(cut) isvector(cut) && all(cut <=1) && all(cut >= 0);
prsr.addParameter('cut', default, validate);

% Tanh gradient for analytical approximation (speed up ode solver) DEFERRED
prsr.addParameter('tanh', 0, @isnumeric);

% Convolution core size
prsr.addParameter('conv', 0, @isnumeric);

% Convolution sampling points
prsr.addParameter('conv_sampling', 1e5, @(x) x == int32(x));

% Average mean value relative tolerance
prsr.addParameter('amv_rel_tol', 1e-4, @isnumeric);
 
% Integral Negativity relative tolerance
prsr.addParameter('int_neg_rel_tol', 1e-4, @isnumeric);

% Integral end condition relativ tolerance
prsr.addParameter('int_zero_rel_tol', 1e-4, @isnumeric);

% Dismissed power rel tol
prsr.addParameter('dismissed_power_rel_tol', 1e-4, @isnumeric);
 
% Verbosity level of calculations
default = 0;
validate = @(in) in == int32(in) && (in == 0 || in == 1 || in == 2);
prsr.addParameter('verbose', default, validate);
 
% Plot Output
prsr.addParameter('plot_sig', 100, @(x) x == int32(x));
prsr.addParameter('plot_hyb', 101, @(x) x == int32(x));
prsr.addParameter('plot_eco', 102, @(x) x == int32(x));
prsr.addParameter('plot_sim', 103, @(x) x == int32(x));
prsr.addParameter('plot_stor', 0, @(x) x == int32(x));
 
% check_asserts ?
% samplepoints ?
% log ?

prsr.parse(varargin{:})

options = prsr.Results;

end
