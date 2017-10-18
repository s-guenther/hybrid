function [xout, yout] = add_cut_crossings(xin, yin, cutval)
% ADD_CUT_CROSSINGS inserts crossing points at cutval into input vectors
%
% If between two values of input vectors XIN and YIN the linear
% interpolation crosses the value CUTVAL or -CUTVAL, this point is inserted
% within these vectors.
%
% [XOUT, YOUT] = ADD_ZERO_CROSSINGS(XIN, YIN)
%
% See also ADD_ZERO_CROSSINGS.

% TODO test it

[xin, yin] = add_zero_crossings(xin, yin - cutval);
yin = yin + cutval;
[xout, yout] = add_zero_crossings(xin, yin + cutval);
yout = yout - cutval;

end
