function result = study_tetris()
% STUDY_TRI defines variable tetris l shaped fcn, calls study_signal_group
%
% From a square function (positive amplitude) another square is cut out, the
% larger the parameter a, the larger the cut out. Visualisation of the
% positive half period of the signal:
%
% a = 0    OOOO    a = 0.25    OOO     a = 0.5    OO      a = 0.75   O
%          OOOO                OOOO               OO                 O
%          OOOO                OOOO               OOOO               O
%          OOOO                OOOO               OOOO               OOOO
%
% Input:    None
% Output:   result from study_signal_group

% Definition of tetris shaped fcn, 1 period, must be overloaded
% with mod(x,2*pi)
tetris_fcn = @(t, a) 1     *(t <= (1-a)*pi) + ...
                     (1-a) *(t > (1-a)*pi & t <= pi) + ...
                     -1    *(t > pi & t <= (2*pi - a*pi)) + ...
                     (-1+a)*(t > (2*pi - a*pi));

generic_tetris.amplitude = 1;
generic_tetris.period = 2*pi;
generic_tetris.fcn = @(t, a) tetris_fcn(mod(t, 2*pi), a);

result = study_signal_group(generic_tetris, 'Tetris Shape', 1);

end
