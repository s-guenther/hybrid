function hfig = plot_operation(simdata, varargin)
% PLOT_OPERATION plots the simulation results of the hybrid
%
% HFIG = PLOT_OPERATION(SIMDATA, <OPT>) Plots the simulation
% results, i.e. base and peak power and energy as a function of time,
% stored in SIMDATA, using the options OPT. OPT is an option structure
% provided through HYBRIDSET. HFIG is the figure number the result is
% plotted in.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

[~, opt] = parse_plot_hybrid_input(varargin{:});

if ~opt.plot_sim
    hfig = figure(103);
else
    hfig = figure(opt.plot_sim);
end

sigpower = @(t) simdata.powers.base(t) + simdata.powers.peak(t);

clf
hold on

if strcmpi(simdata.type, 'fhandle')
    tt = linspace(0, simdata.period, 1e4);
    sub1 = subplot(20, 1, 1:12);
    hold on, grid on,
    title(['Simulation of Operation, Control Strategy = ''', ...
            simdata.strategy, ''''])
    plot(tt, simdata.powers.base(tt), 'Color', [0, 0.7, 0], 'Linewidth', 1)
    plot(tt, simdata.powers.peak(tt), 'Color', [0.7, 0, 0], 'Linewidth', 1)
    plot(tt, sigpower(tt), 'Color', [0, 0, 1])
    sub1.XTickLabel = [];
    ylabel('Power')
    axis('tight')
    sub2 = subplot(20, 1, 14:20);
    hold on, grid on,
    plot(tt, simdata.energies.base(tt)/simdata.dims.base.energy, ...
         'Color', [0, 0.7, 0])
    plot(tt, simdata.energies.peak(tt)/simdata.dims.peak.energy, ...
         'Color', [0.7, 0, 0])
    plot(tt, simdata.bw_int.fcn(tt)/simdata.dims.peak.energy, ...
         'Color', [0.7, 0, 0], 'Linewidth', 1, 'Linestyle', '--')
    plot(tt, simdata.state(tt)/10+0.45, 'Linewidth', 1, 'Color', [0, 0, 1])
    xlabel('Time')
    ylabel('SOC')
    axis('tight')
    linkaxes([sub1, sub2], 'x');
elseif any(strcmpi(simdata.type, {'step', 'linear'}))
end

hold off

end
