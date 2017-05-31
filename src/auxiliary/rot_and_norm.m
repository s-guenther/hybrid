function [x_new, y_new] = rot_and_norm(x_vec, y_vec)
% ROT_AND_NORM rotates data by 45 deg and norm to 1
%
% x_data and y_data is normed to 1, then, x and y are rotated by 45 degree and
% y is then normed by a factor of sqrt(2) and x by 1/sqrt(2)
%
% Input:
%   x_vec   x data, row vector
%   y_vec   y data, row vector
%
% Output:
%   x_new   rotated x data, row vec
%   y_new   rotated y data, row vec

x_vec = x_vec/max(x_vec);
y_vec = y_vec/max(y_vec);

rot = @(a) [cos(a), sin(a); -sin(a), cos(a)];
rot45 = rot(pi/4);

xynew = rot45*[x_vec'; y_vec'];
x_new = xynew(1,:)';
y_new = xynew(2,:)';

x_new = x_new/sqrt(2);
y_new = y_new*sqrt(2);

end
