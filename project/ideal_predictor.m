function soc = ideal_predictor(fw_decay, bw_decay)
% IDEAL_PREDICTOR returns required soc as fcn of time for specific signal
%
% IDEAL_PREDICTOR uses a forward decay integral and a backward decay
% integral to determine required soc as function of time by comparing both
% of them.
%
% Input:
%   fw_decay    forward integral, fcn handle
%   bw_decay    backward integral (already reversed), fcn handle
%
% Output:
%   soc         state of charge, fcn handle

% multiply with logical expression to prevent a decay function falling
% below 0
soc = @(t) (fw_decay(t).*(fw_decay(t) >= 0) - bw_decay(t).*(bw_decay(t) >= 0)) < 0;

end
