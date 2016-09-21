function result = study_tri()
% STUDY_TRI defines a variable triangular fcn and calls study_signal_group
%
% The midpoint of the leg of a triangular function is moved along the
% perpendicular line. At limit a = 0 it is a square wave, at a = 1 it is a
% (amplitude limited) dirac impulse, at a = 0.5 a normal triangular fcn.
%
% Input:    None
% Output:   result from study_signal_group

% Piecewise definition of distorted triangular fcn for subsequent
% linear interpolation
fcn_x_vec = @(a) [0, a, 1, 2-a, 2, 2+a, 3, 4-a, 4]*2*pi/4;
fcn_y_vec = @(a) [0, 1-a, 1, 1-a, 0, -(1-a), -1, -(1-a), 0];

generic_triangular.amplitude = 1;
generic_triangular.period = 2*pi;
generic_triangular.fcn = @(t,a) interp1(fcn_x_vec(a), ...
                                        fcn_y_vec(a), ...
                                        mod(t, 2*pi), ...
                                        'linear');

result = study_signal_group(generic_triangular, 'Triangular', 1);

end
