function [x, y] = calc_peak(form, crest)
% CALC_PEAK Calculates the x,y peak in transformed leaf from signal para
%
% Calculats the x and y coordinate of the peak for a given signal with the
% parameters form and crest. The coordinates are the rotated and scaled
% representation of the leaf diagram of the peak storage.
%
% Input:
%   form    form factor
%   crest   crest factor
%
% Output:
%   x       x coordinate of peak
%   y       y coordinate of peak
%
% (F,C) |-implicit-> (a,b) |-> (E_peak,rel, P_peak_rel) |--> (x, y)

impl_fcn = @(a, b, C, F) [(b + a^2*(1 - b))^-(1/2) - C; ...
                          sqrt(b + a^2*(1 - b))/(b + a*(1 - b)) - F];
impl_fcn_subs = @(x) impl_fcn(x(1), x(2), crest, form);

x0 = [0.5, 0.5];
ab_vec = fsolve(impl_fcn_subs, x0, optimset('display', 'off'));

a = ab_vec(1);
b = ab_vec(2);

x = 1 - a/2*(1 + 1/(a*(1-b) + b));
y = a*(1/(a*(1-b)+b) - 1);

end
