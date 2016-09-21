function result = study_pwm()
% STUDY_PWM defs PWM signal w/ variable duty cycle, calls study_signal_group
%
% Creates a PWM Signal w/ a duty cycle of (1 - a). Visualisation of the
% positive half period of the signal:
%
% a = 0    OOOO    a = 0.25    OOO     a = 0.5    OO      a = 0.75   O   
%          OOOO                OOO                OO                 O   
%          OOOO                OOO                OO                 O   
%          OOOO                OOO_               OO__               O___
%
% Input:    None
% Output:   cell array/vector, from study_signal_group

% Definition PWM fcn, 1 period, must be overloaded with mod(x,2*pi)
l_shape_fcn = @(t, a) 1 *(t <= (1-a)*pi) + ...
                      0 *(t > (1-a)*pi & t <= pi) + ...
                      -1*(t > pi & t <= (2-a)*pi) + ...
                      0 *(t > (2-a)*pi);

generic_l_shape_v.amplitude = 1;
generic_l_shape_v.period = 2*pi;
generic_l_shape_v.fcn = @(t, a) l_shape_fcn(mod(t, 2*pi), a);

result = study_signal_group(generic_l_shape_v, 'PWM', 1);

end
