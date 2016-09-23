function result_cell = study_diamonds()
% STUDY_DIAMONDS batches multiple l_shape studies
%
% Executes various study_l_shape with various cut offs
%
% Input:    None
% Output:   result_cell     see study_signal_group

res_h = {};
res_v = {};
cuts = [0.01, 0.10, 0.25, 0.80, 0.95];
for cut = cuts
    res_h = [res_h; study_l_shape_horz(cut, ['Horz. Cut ' num2str(cut)])];
    res_v = [res_v; study_l_shape_vert(cut, ['Vert. Cut ' num2str(cut)])];
end

result_cell = [res_h; res_v];

end
