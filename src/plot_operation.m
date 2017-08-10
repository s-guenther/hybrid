function hfig = plot_operation(simdata, varargin)
% PLOT_OPERATION plots the simulation results of the hybrid
%
% HFIG = PLOT_OPERATION(SIMDATA, <SIGNAL>, <OPT>) Plots the simulation
% results, i.e. base and peak power and energy as a function of time,
% stored in SIMDATA, using the options OPT. If a signal struct SIGNAL is
% specified, it is plotted additionally. OPT is an option structure
% provided through HYBRIDSET. HFIG is the figure number the result is
% plotted in.
%
% See also HYBRID, GEN_SIGNAL, PLOT_SIGNAL, PLOT_ECO, HYBRIDSET.

[signal, opt] = parse_plot_hybrid_input(varargin{:});

if ~opt.plot_sim
    hfig = figure(103);
else
    hfig = figure(opt.plot_sim);
end

clf
hold on
plot(simdata.time, simdata.powers)
if isvalidsignal(signal)
    axsig = axes('Position', [0.22, 0.58, .25, .25]);
    plot_signal(signal, opt, axsig);
end
hold off

end
