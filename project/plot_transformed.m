function hfig = plot_transformed(signal, sim_results, name, figno)
% PLOT_TRANSFORMED Plots results saved in parameter and hybrid table
%
% Plots the transformed (x,y) data of a Testcase, a testcase consists of: An
% input function signal, the leaf ragone diagram saved in hybrid_table, the
% signal parameters saved in parameter, and a testcasename name
%
% Input:
%   signal              signal struct
%   sim_results         struct from main.m
%       .parameter          [form crest rms arv]
%       .hybrid_table       [cut_off, e_base, e_peak, p_base, p_peak; ...]
%       .single             struct: .energy, .power
%       .transformed        rotated and normed (x,y) value pairs
%       .peak               (x,y) peak of transformed data (interpolated)
%       .theo_peak          theoretically obtained peak (x,y)
%   name                string, arbitrary testcase name
%   figno               optional, figure number the results will be plotted,
%                       default: randi(1e8,1)
% Output:
%   hfig                handle of plotted figure

if nargin < 4
    figno = randi(1e8, 1);
end

% plot graph
hfig = figure(figno);
clf, hold on, grid on
plot(sim_results.transformed(:,3), sim_results.transformed(:,5), 'rx-')
plot(sim_results.peak(1), sim_results.peak(2), 'ro', 'Linewidth', 2)
plot(sim_results.theo_peak(1), sim_results.theo_peak(2), ...
     'rs', 'Linewidth', 2, 'MarkerSize', 10)

% make pretty + additional information
title(name)
xlabel('x')
ylabel('y')

vals = sim_results.transformed(:, [5, 3]);
valnames = 'x    |    y';

prettify_plot(signal, sim_results, vals, valnames)

end
