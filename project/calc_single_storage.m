function [e, p] = calc_single_storage(signal)
% CALC_SINGLE_STORAGE energy, power for a single storage for given signal
%
% Input:
%   signal  struct, see issignalstruct
%
% Output:
%   e       needed energy of storage
%   p       needed power of storage

p = signal.amplitude;
[~, y] = ode45(@(t,y) signal.fcn(t), [0 signal.period], 0);
e = max(y) - min(y);

end
