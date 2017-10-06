function hfig = plot_operation(simdata, varargin)
% PLOT_OPERATION plots the simulation results of the hybrid
%
%   HFIG = PLOT_OPERATION(SIMDATA, <OPT>) Plots the simulation results,
%   i.e. base and peak power and energy as a function of time, stored in
%   SIMDATA, using the options OPT. OPT is an option structure provided
%   through HYBRIDSET. HFIG is the figure number the result is plotted in.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

% TODO add plotting functionality for 'step' and 'linear' as soon as
% available

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
    sub1 = subplot(20, 1, 1:11);
    hold on, grid on,
    title(['Simulation of Operation, Control Strategy = ''', ...
            simdata.strategy, ''''])
    plot([0 simdata.period], [0 0], 'k')
    l1 = plot(tt, sigpower(tt), '--', 'Color', [0, 0, 1]);
    l2 = plot(tt, simdata.powers.base(tt), 'Color', [0, 0.7, 0], 'Linewidth', 1);
    l3 = plot(tt, simdata.powers.peak(tt), 'Color', [0.7, 0, 0], 'Linewidth', 1);
    sub1.XTickLabel = [];
    legend([l1, l2, l3], {'Input', 'Base', 'Peak'})
    ylabel('Power')
    amp = simdata.dims.base.power + simdata.dims.peak.power;
    singleenergy = simdata.dims.base.energy + simdata.dims.peak.energy;
    axis([0, simdata.period, -1.02*amp, 1.02*amp])

    text(sub1, 0.03*simdata.period, -0.5*amp, ...
         {['P_b = ' num2str(simdata.dims.base.power)]; ...
          ['P_p = ' num2str(simdata.dims.peak.power)]; ...
          ['P_s = ' num2str(amp)]; ...
          ['\chi = ' num2str(simdata.cut)]});

    sub2 = subplot(20, 1, 14:20);
    hold on, grid on,
    l4 = plot(tt, simdata.energies.base(tt)/simdata.dims.base.energy, ...
         'Color', [0, 0.7, 0]);
    l5 = plot(tt, simdata.bw_int.fcn(tt)/simdata.dims.peak.energy, ...
         'Color', [0.7, 0.5, 0.5], 'Linewidth', 1, 'Linestyle', '--');
    l6 = plot(tt, simdata.energies.peak(tt)/simdata.dims.peak.energy, ...
         'Color', [0.7, 0, 0]);
    legend([l4, l6, l5], {'Base', 'Peak', 'BW Int'})
    xlabel('Time')
    ylabel('SOC')
    axis([0, simdata.period, 0.0, 1.02])

    text(sub2, 0.03*simdata.period, 0.7, ...
         {['E_b = ' num2str(simdata.dims.base.energy) ...
           ' ,   \omega_b = ' num2str(simdata.dims.base.power/simdata.dims.base.energy)]; ...
          ['E_p = ' num2str(simdata.dims.peak.energy) ...
           ' ,   \omega_p = ' num2str(simdata.dims.peak.power/simdata.dims.peak.energy)];
          ['E_s = ' num2str(singleenergy) ...
           ' ,   \omega_s = ' num2str(amp/singleenergy)]});

    sub3 = subplot(20, 1, 12:13);
    hold on, grid on,
    plot(tt, simdata.state(tt), 'Linewidth', 1, 'Color', [0, 0, 0])
    ylabel('State')
    ylim([-0.05, 1.05])
    sub3.YTick = [0 0.5 1];
    sub3.YTickLabel = {'DISCH', 'SYNC', 'CHARGE'};
    sub3.XTickLabel = [];

    linkaxes([sub1, sub2, sub3], 'x');
elseif any(strcmpi(simdata.type, {'step', 'linear'}))
end

hold off

end
