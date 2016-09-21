function result = distorted_sin()
% DISTORTED_SIN nonlinear amplification of sin, calls study_signal_group
%
% A sin function is amplified (with an amplification of on) by a nonlinear
% amplification characteristic. Distortion depends on parameter a
% amp = x^(ln(a)/ln(0.5))
% a = 1     every value is 1
% a = 0.5   normal sin, linear
% a = 0     every value is 0
%
% Input:    None
% Output:   result from study_signal_group

% Def amplification fcn
amp = @(x,a) abs(x).^((log(a)/log(0.5))^4).*(x > 0 & a <= 0.5) - ...
             abs(x).^((log(a)/log(0.5))^4).*(x < 0 & a <= 0.5) + ...
             abs(x).^((log(a)/log(0.5)))  .*(x > 0 & a > 0.5) - ...
             abs(x).^((log(a)/log(0.5)))  .*(x < 0 & a > 0.5);

generic_l_shape_v.amplitude = 1;
generic_l_shape_v.period = 2*pi;
generic_l_shape_v.fcn = @(t, a) amp(sin(t),a);

result = study_signal_group(generic_l_shape_v, 'Distorted Sinus', 1);

end
