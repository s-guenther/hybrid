function [peak, base, bw_int] = hybrid_pair(signal, cut, varargin)
% HYBRID_PAIR calculates peak/base storage pair for signal for specific cut
%
% Performs SDODE forward and backward integration and determines the
% minimal dimensions of the two storages needed to fulfil the requirements
% of the signal.
% 
% [PEAK, BASE] = HYBRID_PAIR(SIGNAL, CUT, <OPT>) performs the calculation
% for SIGNAL at a power cut CUT ([0..1]) , it uses the options OPT provided
% by HYBRIDSET. SIGNAL must be generated through GEN_SIGNAL.
%
% Relevant parameters in OPT are 'odeset', 'discrete_solver',
% 'continuous_solver'.
%
% [PEAK, BASE] = HYBRID_PAIR(SIGNAL, CUT, <STRATEGY>, <OPT>) uses the
% strategy STRATEGY for calculation. Can be 'inter' or 'nointer', default
% is 'inter'. The first case 'inter' allows an inter-storage power flow
% between the peak and base storage, leading to smaller peak storage energy
% capacity, the second case 'nointer' prohibits a power flow between the
% storages.
%
% PEAK and BASE are structures with the fields 
%   .energy     and 
%   .power
%
% [PEAK, BASE, <BW_INT>] = HYBRID_PAIR(SIGNAL, CUT). If the third output
% argument is specified, the function returns the backward integral BW_INT
% obtained through the backward integration through SDODE. This information
% is needed for a simulation of the control/operation with SIM_OPERATION.
%
% Examples
%
%   [peak, base] = hybrid_pair(gen_signal(@sin, 2*pi), 0.4)
%   [peak, base] = hybrid_pair(gen_signal(@sin, 2*pi), 0.4, hybridset())
%   [peak, base, bw] = hybrid_pair(gen_signal(@sin, 2*pi), 0.4, 'nointer')
%
% See also HYBRID, GEN_SIGNAL, HYBRIDSET, SIM_OPERATION.

% TODO implement shortcut for cut = 1 and cut = 0

[strategy, opt] = parse_hybrid_pair_input(varargin{:});

base.power = signal.amplitude*cut;
peak.power = signal.amplitude*(1 - cut);

% Evaluate SDODE for positive signal parts
verbose(opt.verbose, 2, ...
        ['Solving SDODE for positive signal part for cut = ', ...
         num2str(cut), ' and strategy = ', strategy '.'])
[build, decay] = gen_build_decay(signal, cut, strategy, opt);
sdfcn_pos = solve_sdode(build, decay, opt);

% Evaluate SDODE for negative signal parts
verbose(opt.verbose, 2, ...
        ['Solving SDODE for positive signal part for cut = ', ...
         num2str(cut), ' and strategy = ', strategy, '.'])
flip_sig = flip_signal(signal);
[flip_build, flip_decay] = gen_build_decay(flip_sig, cut, strategy, opt);
sdfcn_neg = solve_sdode(flip_build, flip_decay, opt);

% determine max from sdode to determine storage sizes
peak.energy = max([sdfcn_pos.amplitude; sdfcn_neg.amplitude]);
base.energy = signal.maxint - peak.energy;

% return backward integral if specified
if nargout > 2
    bw_int = flip_signal(sdfcn_neg);
end

end
