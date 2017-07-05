function hfig = plot_hybrid(hybdata, varargin)
% PLOT_HYBRID plots the hybridisation diagram
%
% HFIG = PLOT_HYBRID(HYBDATA, <SIGNAL>, <OPT>) Plots the hybridisation
% diagram which is defined by the data HYBDATA, using the options OPT. If a
% signal struct SIGNAL is specified, it is plotted additionally as an
% inset. OPT is an option structure provided through HYBRIDSET. HFIG is
% the figure number the result is plotted in.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

% TODO make pretty and complete

[signal, opt] = parse_plot_hybrid_input(varargin{:});

if ~opt.plot_hyb
    hfig = figure(101);
else
    hfig = figure(opt.plot_hyb);
end

cut = linspace(0, 1, 1e2);
inter = hybdata.hybrid;
nointer = hybdata.nointer;

hold on
plot(inter.baseenergy(cut), inter.basepower(cut))
plot(nointer.baseenergy(cut), nointer.basepower(cut), '--')

title('Hybridisation Diagram')
xlabel('Base Energy E')
xlabel('Base Power P')

if ~ischar(signal) && strcmpi(signal, 'none')
    axes('Position', [.6 .2 .25 .2], 'Visible', 'off');
    plot(signal, opt);
end

hold off

end
