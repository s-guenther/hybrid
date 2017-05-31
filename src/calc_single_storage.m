function [e, p] = calc_single_storage(signal, MaxStep)
% CALC_SINGLE_STORAGE energy, power for a single storage for given signal
%
% Input:
%   signal  struct, see issignalstruct
%
% Output:
%   e       needed energy of storage
%   p       needed power of storage

if nargin < 2
    MaxStep = 1e-1;
end

p = signal.amplitude;
[~, y] = ode45(@(t,y) signal.fcn(t), [0 signal.period], 0, ...
               odeset('MaxStep', MaxStep));
e = max(y) - min(y);

end
