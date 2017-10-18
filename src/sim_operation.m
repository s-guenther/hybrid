function sim_results = sim_operation(signal, cut, varargin)
% SIM_OPERATION applies control strategy for signal for specific cut
%
%   Simulation of a hybrid storage pair for a signal at a specific cut.
%
%   The dimensioning of the storages is performed via SDODE. This function
%   acts as a verification or visualization of the operational control for
%   a specific dimensioning at a specific cut. It calculates the powers of
%   base and peak over time accompanied by energy contents and a few
%   control states over time.
%
%   SIM_RESULTS = SIM_OPERATION(SIGNAL, CUT, <STRATEGY>, <OPT>) where
%   SIGNAL is a struct generated by GEN_SIGNAL. CUT defines the power cut
%   in [0..1], STRATEGY can be 'inter' (default) or 'nointer' and chooses
%   the control strategy -- 'inter' allows an inter-storage power flow,
%   'nointer' prohibits an inter-storage power flow. OPT is an options
%   structure generated by HYBRIDSET.
%
%   SIM_RESULTS is a structure with the following fields:
%       .type       same as signal type
%       .dims       dimensions/capacities of base and peak storage
%           .base   with fields .power and .energy
%           .peak   with fields .power and .energy
%       .powers     power as function of time of base and peak storage
%           .base   fhandle or time series vector, depending on type
%           .peak   fhandle or time series vector, depending on type
%       .energies   energies as function of time of base and peak storage
%           .base   fhandle or time series vector, depending on type
%           .peak   fhandle or time series vector, depending on type
%       .state      fhandle or time series vector, depending on type,
%                   control state
%       .time       time series vector, field only available if type is
%                   'step' or 'linear', corresponds to .powers and
%                   .energies time series
%       .cut        double, applied power cut
%       .strategy   string, applied control strategy, 'inter' or 'nointer'
%       .bwint      backward integral obtained during dimensioning process
%       .period     double, period of signal
%
%   Depending on type of the signal structure, the results are saved as a
%   function handle (in case of 'fhandle') or as a time series (in case of
%   'step' and 'linear')
%
%   Important fields in OPT are 'continuous_solver', 'discrete_solver',
%   'tanh_sim', 'plot_sim'.
%
%   Examples:
%     signal = gen_signal(@(t) sin(t) + 2*sin(3*t), 2*pi)
%     sim_results = sim_operation(signal, 0.4)
%
%     opt = hybridset('plot_sim', 42, 'tanh_sim', 1e2)
%     sim_results = sim_operation(signal, 0.5, 'nointer', opt)
%
%   WARNING: Depending on the complexity of the input signal and the odeset
%   options, this calculation may take a considerate amount of time.
%
%   DEFERRED: simulation for signal types 'step' and 'linear'. They will be
%   converted into a signal of type 'fhandle' in advance. An adaption of
%   the 'continuous_solver' and 'odeset' parameters may be neccessary to
%   run the simulation without errors.
%
% See also GEN_SIGNAL, HYBRIDSET, HYBRID.

% TODO integrate optional dims argument, which can handle simulations with
% dimensions that are not at a hybridisation line

% TODO calculation for step and linear

if cut < 0 || cut > 1
    error('HYBRID:sim_operation:cut_not_in_range', ...
          'Parameter ''cut'' must be between 0 and 1')
end

[strategy, opt] = parse_hybrid_pair_input(varargin{:});

 
% Convert 'linear' and 'step' into 'fhandle'
if strcmpi(signal.type, 'linear')
    signal = linear_to_fhandle(signal, opt);
elseif strcmpi(signal.type, 'step')
    signal = step_to_fhandle(signal, opt);
end

verbose(opt.verbose, 1, 'Start simulation by dimensioning storages.')

[base, peak, bw_int] = hybrid_pair(signal, cut, strategy, opt);

[control, state] = control_factory(cut, strategy, base, peak, opt);

verbose(opt.verbose, 1, 'Solve control ode.')

switch signal.type
    case 'fhandle'
        sim_results = sim_operation_fhandle(signal, control, ...
                                            state, bw_int, opt);
    case 'step'
        sim_results = sim_operation_step(signal, control, ...
                                         state, bw_int, opt);
    case 'linear'
        sim_results = sim_operation_linear(signal, control, ...
                                           state, bw_int, opt);
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end


% Complement results
sim_results.dims.base = base;
sim_results.dims.peak = peak;
sim_results.type = signal.type;
sim_results.period = signal.period;
sim_results.cut = cut;
sim_results.strategy = strategy;
sim_results.bw_int = bw_int;

if opt.plot_sim
    plot_operation(sim_results, opt);
end

end