function p_base = op_strat_reload_dim(p_in, t, p_base_max, e_peak, period)
% OP_STRAT_RELOAD_DIM time dependend operational strat for dimensioning
%
% Is a simple operational strategy with an a priori knowledge of period and
% signal symmetry. With this, the storage system can be simulated without the
% knowledge about the dimensions. Determining them, is task of this operational
% strategy.
%
% Input:
%   p_in        power input (to both storages/storage system)
%   t           simulation time
%   p_base_max  maximum possible power of the base storage
%   period      period of input signal
%
% Output:
%   p_base      base power output
%   
% The first half period the system is in 'charge mode', the second half in
% 'discharge mode'
T = period;
p_base = (-p_in      .*(e_peak <= 0 & abs(p_in) <= p_base_max) + ...
         -p_base_max.*(e_peak <= 0 & abs(p_in) > p_base_max) + ...
         -p_base_max.*(e_peak > 0))*(t <= T/2) + ...
         ...
         (-p_in      .*(e_peak >= pi/16 & abs(p_in) <= p_base_max) + ...
         p_base_max.*(e_peak >= pi/16 & abs(p_in) > p_base_max) + ...
         p_base_max.*(e_peak < pi/16))*(t > T/2);

end
