function p_base = op_strat_reload_dim(p_in, e_peak, p_base_max, p_peak_max)
% OP_STRAT_RELOAD_DIM time dependend operational strat for dimensioning
%
% Is a simple operational strategy with an a priori knowledge of period and
% signal symmetry. With this, the storage system can be simulated without the
% knowledge about the dimensions. Determining them is task of this operational
% strategy. Does not consider change of sign within charge, respectively
% discharge, status.
%
% Input:
%   p_in        power input (to both storages/storage system)
%   e_peak      current energy of peak storage
%   p_base_max  maximum possible power of the base storage
%   p_peak_max  maximum possible power of the peak storage
%
% Output:
%   p_base      base power output
%   
% The first half period the system is in 'charge mode', the second half in
% 'discharge mode'. Only the first half of the period is needed. For
% dimensioning. Strategy will fail afterwards.

% FIXME Generalize for shorth change of sign

% p_base = -p_in      .*(e_peak <= 0 & abs(p_in) <= p_base_max) + ...
%          -p_base_max.*(e_peak <= 0 & abs(p_in) > p_base_max) + ...
%          -min(p_base_max, p_in + p_peak_max).*(e_peak > 0);

p_peak_request = p_peak_max*(e_peak > 0);

p_base_virtual = p_in + p_peak_request;

p_base = -sign(p_base_virtual).*min(abs(p_base_virtual), p_base_max);

end
