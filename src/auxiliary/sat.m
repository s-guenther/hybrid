function out = sat(in, satval)
% SAT Saturation function, limits the return values of the input vals
%
% Input:
%   in          The value which is object to limitation
%   satval      saturation value, if this value is scalar, the saturation
%               function is symmetric with satneg = -satplus,
%               alternatively, sat can be a 2x1 vector, separetely
%               specifying positive and negative saturation value
%
% Output:
%   out         saturated value
%
% See also RES_SAT.

if length(satval) == 1
    satval(2) = -satval(1);
end

out = min(max(in, satval(2)), satval(1));

end
