function [xmax, ymax] = find_peak(x_vec, y_vec)
% FIND_PEAK finds maximum of a fcn given as vector, uses spline interpol.
%
% Finds the maximum of a "numeric" function given as x/y pairs. These Pairs
% are spline interpolated, sampled with a a high frequency and handed to a
% max fcn.
%
% Input:
%   x_vec   x_data, row vec
%   y_vec   y_data, row vec
% Output:
%   xmax   position of peak
%   ymax   peak value

interpfcn = @(x) interp1(x_vec, y_vec, x, 'spline');
xx = linspace(min(x_vec), max(x_vec), 1e5);
yy = interpfcn(xx);
ymax = max(yy);
xmax = xx(find(yy == ymax));

end
