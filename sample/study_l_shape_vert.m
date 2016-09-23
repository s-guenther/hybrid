function result = study_l_shape_vert(l_cut, name)
% STUDY_L_SHAPE_VERT defs L w/ variable vert line, calls study_signal_group
%
% From a square function (positive amplitude) another square is cut out, the
% larger the parameter a, the larger the cut out. Visualisation of the
% positive half period of the signal:
%
% a = 0    OOOO    a = 0.25    OOO     a = 0.5    OO      a = 0.75   O
%          OOOO                OOO                OO                 O
%          OOOO                OOO                OO                 O
%          OOOO                OOOO               OOOO               OOOO
%
% Input:
%   l_cut   optional, default: 0.25
%           defines the thickness of the vertical leg of the L
%   name    optional, default: 'L_Shape, vert. cut'
%           group name of testcase
%
% Output:
%   result  cell array/vector, from study_signal_group

if nargin < 1
    l_cut = 0.25;
end
if nargin < 2
    name = 'L_Shape, horz. cut';
end

% Definition of L-shaped fcn, 1 period, must be overloaded
% with mod(x,2*pi)
l_shape_fcn = @(t, a, b) 1 *(t <= (1-b)*pi) + ...
                         a *(t > (1-b)*pi & t <= pi) + ...
                         -1*(t > pi & t <= (2-b)*pi) + ...
                         -a*(t > (2-b)*pi);

generic_l_shape_v.amplitude = 1;
generic_l_shape_v.period = 2*pi;
generic_l_shape_v.fcn = @(t, b) l_shape_fcn(mod(t, 2*pi), l_cut, b);

result = study_signal_group(generic_l_shape_v, name, 1);

end
