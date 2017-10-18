function [xout, yout] = add_zero_crossings(xin, yin)
% ADD_ZERO_CROSSINGS inserts zero crossing points into vectors
%
% If between two values of input vectors XIN and YIN the linear
% interpolation crosses zero, this zero point is inserted within these
% vectors.
%
% [XOUT, YOUT] = ADD_ZERO_CROSSINGS(XIN, YIN)

% TODO test it

% Find points after which zero crossing happens
y1 = yin(1:end-1);
y2 = yin(2:end);
x1 = xin(1:end-1);
x2 = xin(2:end);

crossings = (sign(y1) ~= sign(y2)) & (sign(y1) & sign(y2));

% Return if none found
if ~any(crossings)
    xout = xin;
    yout = yin;
    return
end

x1c= x1(crossings);
x2c= x2(crossings);
y1c= y1(crossings);
y2c= y2(crossings);

xinsert = x1c + (abs(y1c)./(abs(y1c) + abs(y2c)).*(x2c - x1c));
yinsert = zeros(size(xinsert));

% append crossings at end
xall = [xin(:); xinsert(:)];
yall = [yin(:); yinsert(:)];

% sort
[xout, ind] = sort(xall);
yout = yall(ind);

end
