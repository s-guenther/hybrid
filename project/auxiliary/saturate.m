function sat_val = saturate(input_val, sat_plus, sat_minus)
% SATURATE limits the return values of the input vals
%
% Input:
%   input_val   The value which is object to limitation
%   sat_plus    positive saturation value
%               optional, default = 0.5*max(abs(input_val))
%   sat_minus   optional, default = -sat_plus,
%               negative saturation value (write negative)

if nargin < 2
    sat_plus = 0.5*max(abs(input_val));
end
if nargin < 3
    sat_minus = -sat_plus;
end

sat_val = min(max(input_val, sat_minus), sat_plus);

end
