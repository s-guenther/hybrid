function hfig = plot_eco(ecodata, varargin)
% PLOT_ECO plots cost and dimensions functions of storage pairs
%
%   HFIG = PLOT_ECO(ECODATA, <OPT>) where ECODATA ist obtained
%   from ECO() and OPT is an optional options struct obtained from
%   HYBRIDSET().
%
% See also ECO, HYBRIDSET, PLOT_HYBRID.

[dtype, opt] = parse_plot_eco(varargin{:});

% parse options
if ~opt.plot_sig
    hfig = figure(102);
else
    hfig = figure(opt.plot_eco);
end

% prepare figure
clf
ax1 = subplot(1, 30, 1:9);
xlabel('Total Costs'), grid on, hold on
ylabel('Power Cut \chi')
ax2 = subplot(1, 30, 11:19);
xlabel('Total Energy Capacity E'), grid on, hold on
ax3 = subplot(1, 30, 21:29);
xlabel('Total Power Capacity P'), grid on, hold on
ax2.YTickLabel = [];
ax3.YTickLabel = [];

% delegate plot calls to special functions
limits = get_min_limits(ecodata, dtype);

plot_eco_cost(ecodata, limits, ax1);
plot_eco_energy(ecodata, limits, ax2);
plot_eco_power(ecodata, limits, ax3);

end
