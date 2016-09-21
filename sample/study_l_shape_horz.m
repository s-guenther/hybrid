function result = study_l_shape_horz(l_cut)
% STUDY_L_SHAPE_HORZ defs L w/ variable horz line, calls study_signal_group
%
% From a square function (positive amplitude) another square is cut out, the
% larger the parameter a, the larger the cut out. Visualisation of the
% positive half period of the signal:
%
% a = 0    OOOO    a = 0.25    O       a = 0.5    O       a = 0.75   O
%          OOOO                OOOO               O                  O
%          OOOO                OOOO               OOOO               O
%          OOOO                OOOO               OOOO               OOOO
%
% Input:
%   l_cut   optional, default: 0.25
%           defines the thickness of the vertical leg of the L
%
% Output:
%   result  cell array/vector, from study_signal_group

if nargin < 1
    l_cut = 0.25;
end

% Definition of L-shaped fcn, 1 period, must be overloaded
% with mod(x,2*pi)
l_shape_fcn = @(t, a, b) 1     *(t <= b*pi) + ...
                         (1-a) *(t > b*pi & t <= pi) + ...
                         -1    *(t > pi & t <= (1+b)*pi) + ...
                         (-1+a)*(t > (1+b)*pi);

generic_l_shape_h.amplitude = 1;
generic_l_shape_h.period = 2*pi;
generic_l_shape_h.fcn = @(t, a) l_shape_fcn(mod(t, 2*pi), a, l_cut);

result = study_signal_group(generic_l_shape_h, 'L_Shape, horz. cut', 1);

end
