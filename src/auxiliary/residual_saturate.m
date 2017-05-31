function res_sat_val = residual_saturate(input_val, sat_plus, sat_minus)
% RESIDUAL_SATURATE returns the residual of a saturation function
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

res_sat_val = input_val - saturate(input_val, sat_plus, sat_minus);

end
