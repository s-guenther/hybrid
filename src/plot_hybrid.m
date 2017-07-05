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

clf
hold on
plot(inter.baseenergy(cut), inter.basepower(cut), 'k')
plot(nointer.baseenergy(cut), nointer.basepower(cut), 'k--')
plot([0 inter.baseenergy(1)], [0 inter.basepower(1)], 'k:')

title('Hybridisation Diagram')
xlabel('Base Energy E')
ylabel('Base Power P')
axis tight

if isvalidsignal(signal)
    axsig = axes('Position', [0.22, 0.58, .25, .25]);
    plot_signal(signal, opt, axsig);
end

hold off

end
