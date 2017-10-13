function hfig = plot_storages(storages, varargin)
% PLOT_STORAGES plots a storage struct array
% 
%   HFIG = PLOT_STORAGES(STORAGES, <OPT>) Plots the storages provided as a
%   STORAGE struct through GEN_STORAGES using the options OPT. OPT is an
%   option structure provided through HYBRIDSET. HFIG is the handle to the
%   figure the result is plotted in.
%   HFIG = PLOT_STORAGES(STORAGES, [energy power], <OPT>) where [energy
%   power] is used as a reference of a single storage solution.
%   HFIG = PLOT_STORAGES(STORAGES, SPEC_POWER, <OPT>) where SPEC POWER is
%   the reference specific power of a single storage solution.
%   
%   If SPEC_POWER is ommited, the mean value the specific powers of the
%   storages will be used
%
% See also GEN_STORAGES, HYBRIDSET, ECO.

[spec_power, lim_energy, ax, hfig] = ...
    parse_plot_storages_input(storages, varargin{:});
lim_power = lim_energy*spec_power;

% separate base and peak storages
ind = find([storages.spec_power] > spec_power, 1, 'first');
peak = storages(ind:end);
base = storages(1:ind-1);

% color definitions for storages
basecolors = winter(length(base));
peakcolors = autumn(length(peak) + 1);

hold on

% Plot base
for ii = 1:length(base)
    plot(ax, [0, lim_energy], [0, lim_energy*base(ii).spec_power], ...
         'Color', basecolors(ii,:))
    
end

% Plot peak
for ii = 1:length(peak)
    plot(ax, ...
         [lim_energy, 0], ...
         [lim_power, lim_power-lim_energy*peak(ii).spec_power], ...
         'Color', peakcolors(ii,:))
end

% Plot single spec power line
plot(ax, [0, lim_energy], [0, lim_power], 'k')

axis([0, lim_energy, 0, lim_power])
hold off

end%mainfcn
