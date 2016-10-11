function hfig = plot_leaf(signal, sim_results, name, figno)
% PLOT_LEAF Plots results saved in parameter and hybrid table
%
% Plots a Testcase, a testcase consists of: An input function signal, the
% leaf ragone diagram saved in hybrid_table, the signal parameters saved in
% parameter, and a testcasename name
%
% Input:
%   signal          signal struct
%   sim_results     struct from main.m
%       .parameter       [form crest rms arv]
%       .hybrid_table    [cut_off, e_base, e_peak, p_base, p_peak; ...]
%       .single          struct: .energy, .power
%       .transformed     [cut_off, x_base, x_peak, y_base, y_peak; ...]
%       .peak            [x,y] of transformed 
%   name            string, arbitrary testcase name
%   figno           optional, figure number the results will be plotted,
%                   default: randi(1e8,1)
% Output:
%   hfig            handle of plotted figure

if nargin < 4
    figno = randi(1e8, 1);
end

% plot graph
hfig = figure(figno);
clf, hold on, grid on

plot(sim_results.hybrid_table(:,2), sim_results.hybrid_table(:,4), 'gx-')
plot(sim_results.hybrid_table(:,3), sim_results.hybrid_table(:,5), 'rx-')

plot(sim_results.reload_table(:,2), sim_results.reload_table(:,4), 'go--')
plot(sim_results.reload_table(:,3), sim_results.reload_table(:,5), 'ro--')

xcrossline = [sim_results.hybrid_table(1,2), sim_results.hybrid_table(end,2)];
ycrossline = [sim_results.hybrid_table(1,4), sim_results.hybrid_table(end,4)];
plot(xcrossline, ycrossline, 'k:')

% make pretty + additional information
title(name)
xlabel('Energy')
ylabel('Power')

vals = sim_results.hybrid_table(:, [5, 3]);
valnames = 'Power Cut off | Energy Peak';

prettify_plot(signal, sim_results, vals, valnames)


end
