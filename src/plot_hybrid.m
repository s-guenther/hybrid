function hfig = plot_hybrid(hybdata, varargin)
% PLOT_HYBRID plots the hybridisation diagram
%
%   HFIG = PLOT_HYBRID(HYBDATA, <SIGNAL>, <OPT>) Plots the hybridisation
%   diagram which is defined by the data HYBDATA, using the options OPT. If
%   a signal struct SIGNAL is specified, it is plotted additionally as an
%   inset. OPT is an option structure provided through HYBRIDSET. HFIG is
%   the figure number the result is plotted in.
%
%   HFIG = PLOT_HYBRID(HYBDATA, STORAGES, <SIGNAL>, <OPT>) additionally
%   plots the storages STORAGES into the hybridisation diagram.
%
%   HFIG = PLOT_HYBRID(HYBDATA, ECODATA, <SIGNAL>, <OPT>) additionally
%   plots the cost function of ECODATA right to the hybridisation diagram.
%   It reconstructs the STORAGES from ECODATA and plots them into the
%   hybridisation diagram. Plots corresponding tuples derived from ECODATA
%   into the hybridisation diagram.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

[storages, ecodata, signal, opt] = parse_plot_hybrid_input(varargin{:});

if ~opt.plot_hyb
    hfig = figure(101);
else
    hfig = figure(opt.plot_hyb);
end

clf

% Generate two axes if ecodata is present, else just one
if isvalideco(ecodata)
    ax = subplot(1, 30, 1:19);
    hold on, grid on
    axeco = subplot(1, 30, 24:30);
    hold on, grid on
else
    ax = gca;
    hold on, grid on
end

% generate rotated peak coordinate system
ax.Color = 'none';
axp = axes(hfig, 'Position', ax.Position);
uistack(ax, 'top')
% Reverse backward axes
axp.XDir = 'reverse';
axp.YDir = 'reverse';
axp.XAxisLocation = 'top';
axp.YAxisLocation = 'right';

cut = linspace(0, 1, 1e3);
inter = hybdata.hybrid;
nointer = hybdata.nointer;

% Plot hybridisation curve
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

% if storage structure is present, plot storages into hybridisation curve
if isvalidstorage(storages)
    energypower = [inter.baseenergy(1) inter.basepower(1)];
    plot_storages(storages, energypower, opt, ax);
end

% if ecodata is present, plot ecodata
if isvalideco(ecodata)
    limits = get_min_limits(ecodata, 'cost', opt);
    plot_eco_cost(ecodata, limits, axeco, opt);
    plot_eco_tuple(ecodata, limits, ax, opt);
    xlabel(axeco, 'Costs')
    ylabel(axeco, 'Power Cut \chi')
end


% if signal is present, generate signal axis and plot signal into it
if isvalidsignal(signal, opt)
    if isvalideco(ecodata)
        axsig = axes('Position', [0.22, 0.58, .16, .25]);
    else
        axsig = axes('Position', [0.22, 0.58, .25, .25]);
    end
    plot_signal(signal, opt, axsig);
end


end
