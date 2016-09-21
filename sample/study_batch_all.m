function [result_cell, result_struct] = study_batch_all()
% STUDY_BATCH_ALL calls all study cases at once
%
% Calls study_<case>, where case is _distorted_sin, _l_shape_horz,
% _l_shape_vert, _pwm, _tetris, _triangular
%
% Input:    None
%
% Output:
%   result_cell     all results gathered, see study_signal_group
%   result_struct   all results sorted by signal form
%       .distorted_sin  see study_signal_group
%       .l_shape_horz   ...
%       . ...


% Simulate
res_sin = study_distorted_sin();
res_l_shape_h = study_l_shape_horz();
res_l_shape_v = study_l_shape_vert();
res_pwm = study_pwm();
res_tetris = study_tetris();
res_tri = study_triangular();


% Gather results
result_cell = [res_sin; ...
               res_l_shape_h; ...
               res_l_shape_v; ...
               res_pwm; ...
               res_tetris; ...
               res_tri];

result_struct.distorted_sin = res_sin;
result_struct.l_shape_horz = res_l_shape_h;
result_struct.l_shape_vert = res_l_shape_v;
result_struct.pwm = res_pwm;
result_struct.tetris = res_tetris;
result_struct.triangular = res_tri;


end
