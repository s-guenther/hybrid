function fcn = smooth_steps(x,y, transition)
% SMOOTH_STEPS converts x, y vector pair to a fcn  w/ smooth transitions
%
% Takes x, y vector values as input describing a step function with
% discontinuous derivative and smooths the discontinuities by approximating
% it via a polynomial of 3rd order (using pchip function).
%
% Input:
%   x           x values of the x, y pairs
%   y           y values of the x, y pairs
%   transition  optional, default 1e-2, section in which the discontinuity
%               will be smoothed (before and after)
%
% Output:
%   fcn         function handle
%
% Input as row vector.

if nargin < 3
    transition = 1e-2;
end

xbefore = [x x(end)+1] - transition;
xafter = [x x(end)+1] + transition;

ybefore = [y(1) y];
yafter = [y y(end)];

xmatrix = [xbefore; xafter];
ymatrix = [ybefore; yafter];

xvec = xmatrix(:);
yvec = ymatrix(:);

fcn = @(xx) interp1(xvec, yvec, xx, 'pchip');

end
