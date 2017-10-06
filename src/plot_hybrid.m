function hfig = plot_hybrid(hybdata, varargin)
% PLOT_HYBRID plots the hybridisation diagram
%
%   HFIG = PLOT_HYBRID(HYBDATA, <SIGNAL>, <OPT>) Plots the hybridisation
%   diagram which is defined by the data HYBDATA, using the options OPT. If
%   a signal struct SIGNAL is specified, it is plotted additionally as an
%   inset. OPT is an option structure provided through HYBRIDSET. HFIG is
%   the figure number the result is plotted in.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

[signal, opt] = parse_plot_hybrid_input(varargin{:});

if ~opt.plot_hyb
    hfig = figure(101);
else
    hfig = figure(opt.plot_hyb);
end

clf
hold on

ax = gca;
axp = axes(hfig, 'Position', ax.Position, 'Color', 'None');
% Reverse backward axes
axp.XDir = 'reverse';
axp.YDir = 'reverse';
axp.XAxisLocation = 'top';
axp.YAxisLocation = 'right';

cut = linspace(0, 1, 1e2);
inter = hybdata.hybrid;
nointer = hybdata.nointer;

axis([ax, axp], [0, inter.baseenergy(1), 0, inter.basepower(1)])

patch(ax, inter.baseenergy(cut), inter.basepower(cut), ...
      [0.75 0.75 0.75], 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(ax, nointer.baseenergy(cut), nointer.basepower(cut), ...
      [0.75 0.75 0.75], 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(ax, [0 inter.baseenergy(1)], [0 inter.basepower(1)], 'k:')
plot(ax, inter.baseenergy(cut), inter.basepower(cut), 'k')
plot(ax, nointer.baseenergy(cut), nointer.basepower(cut), 'k--')

title('Hybridisation Diagram')
xlabel(ax, 'Base Energy E_b')
ylabel(ax, 'Base Power P_b')
xlabel(axp, 'Peak Energy E_p')
ylabel(axp, 'Peak Power P_p')

text(ax, 0.1*inter.baseenergy(1), 0.4*inter.basepower(1), ...
     {['H = ' num2str(hybdata.hybrid_potential)]; ...
      ['R = ' num2str(hybdata.reload_potential)]; ...
      ['P_s/E_s = ' num2str(inter.basepower(1)/inter.baseenergy(1))]});

grid(ax, 'on')

if isvalidsignal(signal)
    axsig = axes('Position', [0.22, 0.58, .25, .25]);
    plot_signal(signal, opt, axsig);
end


hold off

end
