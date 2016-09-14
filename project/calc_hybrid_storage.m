function [base, peak] = calc_hybrid_storage(signal, p_cut_ratio)
% CALC_HYBRID_STORAGE calcs energy, power for base and peak storage
%
% For a given power ratio, where the peak storage begins to work, the energy
% and power for this peak storage and the base storage is calculated
%
% Input:
%   signal          signal struct, see issignalstruct
%   p_cut_ratio     power ratio, where peak begins to work, between 0..1
%
% Output:
%   base.energy     energy of base storage
%   base.power      power of base storage
%   peak.energy     energy of peak storage
%   peak.power      power of peak storage

% create new signal structs for base and peak storage
signal_base = signal;
signal_base.amplitude = signal.amplitude*p_cut_ratio;
signal_base.fcn = @(t) base_signal(signal.fcn(t), signal_base.amplitude);

signal_peak = signal;
signal_peak.amplitude = signal.amplitude*(1 - p_cut_ratio);
signal_peak.fcn = @(t) peak_signal(signal.fcn(t), signal_base.amplitude);

% Calculate storage for separated fcns
[base.energy, base.power] = calc_single_storage(signal_base, 1e-2);
[peak.energy, peak.power] = calc_single_storage(signal_peak, 1e-2);

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
