function hfig = plot_testcase(signal, sim_results, name, figno)
% PLOT_TESTCASE Plots results saved in parameter and hybrid table
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
%       .single     struct: .energy, .power
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

% make pretty + additional information
title(name)
xlabel('Energy')
ylabel('Power')

vals = sim_results.hybrid_table(:, [5, 3]);
valnames = 'Power Cut off   |   Energy Peak';
annotation('textbox', [0.2, 0.5, 0.1, 0.1], ...
           'String', valnames, ...
           'FitBoxToText', 'on')
annotation('textbox', [0.2, 0.45, 0.1, 0.1], ...
           'String', num2str(flipud(vals)), ...
           'FitBoxToText', 'on')

varnames = ['Form    '; 'Crest   '; 'RMS     '; 'ARV     '; 'AMV     '];
varvalsstr = num2str(sim_results.parameter');
annotation('textbox', [0.2, 0.7, 0.1, 0.1], ...
           'String', varnames, ...
           'FitBoxToText', 'on')
annotation('textbox', [0.26, 0.7, 0.1, 0.1], ...
           'String', varvalsstr, ...
           'FitBoxToText', 'on')

annotation('textbox', [0.2, 0.75, 0.1, 0.1], ...
           'String', func2str(signal.fcn), ...
           'FitBoxToText', 'on')

axis tight

% subplot of input fcn
ax_t_signal = axes('Position', [.6 .2 .25 .2], 'Visible', 'off')
t = linspace(0, 2*pi, 2e2);
plot(t, signal.fcn(t), t, zeros(size(t)), 'k')
xlabel('Time')
ylabel('Amplitude')

hold off, axis tight

end
