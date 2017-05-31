function soc = ideal_predictor(bw_decay, tanh_grad)
% IDEAL_PREDICTOR returns required soc as fcn of time for specific signal
%
% IDEAL_PREDICTOR uses a forward decay integral and a backward decay
% integral to determine required soc as function of time by comparing both
% of them.
%
% Input:
%   bw_decay    backward integral (already reversed), fcn handle
%   tanh_grad   optional, default 100, rate at which soc switches to
%               prevent numerical oscillation
%
% Output:
%   soc         state of charge, fcn handle

if nargin < 2
    tanh_grad = 10000;
end

% multiply with logical expression to prevent a decay function falling
% below 0
bw_dec = @(t)bw_decay(t).*(bw_decay(t) >= 0);
% soc = @(e_p, t) tanh(tanh_grad*(bw_dec(t) - e_p - 4/tanh_grad))*0.5 + 0.5;
soc = @(e_p, t) (bw_dec(t) - e_p.*(e_p >= 0)) >= 1e-5;

end
