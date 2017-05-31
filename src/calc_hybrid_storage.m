function [base, peak] = calc_hybrid_storage(signal, p_cut_ratio, ...
                                            inter, max_step)
% CALC_HYBRID_STORAGE calcs energy, power for base and peak storage
%
% For a given power ratio, where the peak storage begins to work, the energy
% and power for this peak storage and the base storage is calculated
%
% Input:
%   signal          signal struct, see issignalstruct
%   p_cut_ratio     power ratio, where peak begins to work, between 0..1
%   inter           optional, default 0, calculates hybrid storage with an
%                   intermediate point strategy within the leaf, as a fraction
%                   of p_cut_ratio
%                   0.. original boundary of leaf
%                   1.. single storage e/p iso time line
%   max_step        optional, default 1e-2, max integration step size
%
% Output:
%   base.energy     energy of base storage
%   base.power      power of base storage
%   peak.energy     energy of peak storage
%   peak.power      power of peak storage

if nargin < 3
    inter = 0;
end
if nargin < 4
    max_step = 1e-2;
end


% Calculate
reduce_coeff = 1 - (1 - p_cut_ratio)*inter;

% create new signal structs for base and peak storage
signal_base = signal;
signal_base.amplitude = signal.amplitude*p_cut_ratio;
signal_base.fcn = @(t) base_signal(reduce_coeff*signal.fcn(t), ...
                                   signal_base.amplitude);

signal_peak = signal;
signal_peak.amplitude = signal.amplitude*(1 - p_cut_ratio);
signal_peak.fcn = @(t) (1 - reduce_coeff)*signal.fcn(t) + ...
                       peak_signal(reduce_coeff*signal.fcn(t), ...
                                   signal_base.amplitude);

% Calculate storage for separated fcns
[base.energy, base.power] = calc_single_storage(signal_base, max_step);
[peak.energy, peak.power] = calc_single_storage(signal_peak, max_step);

end%fcn


%% LOCAL FUNCTIONS

function [base_val] = base_signal(signal_val, max_amplitude)
% Cuts off values higher or lower than +- max_amplitude (saturation)
    base_val = max(min(signal_val, max_amplitude), ...
                   -max_amplitude);
end

function [peak_val] = peak_signal(signal_val, max_amplitude)
% Returns residual of cut off values higher/lower than min/max (saturation)
    peak_val = signal_val - max(min(signal_val, max_amplitude), ...
                                -max_amplitude);
end
