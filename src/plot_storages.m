function hfig = plot_storages(storages, varargin)
% PLOT_STORAGES plots a storage struct array
% 
%   HFIG = PLOT_STORAGES(STORAGES, <OPT>) Plots the storages provided as a
%   STORAGE struct through GEN_STORAGES using the options OPT. OPT is an
%   option structure provided through HYBRIDSET. HFIG is the handle to the
%   figure the result is plotted in.
%   HFIG = PLOT_STORAGES(STORAGES, SIGNAL, <OPT>) where SIGNAL is the
%   signal struct obtained by GEN_SIGNAL. It acts as reference for the
%   single storage solution.
%   HFIG = PLOT_STORAGES(STORAGES, SPEC_POWER, <OPT>) where SPEC POWER is
%   the reference specific power of a single storage solution.
%   
%   If SIGNAL or SPEC_POWER is ommited, the mean value the specific powers
%   of the storages will be used
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
peakcolors = flipud(peakcolors(1:end-1,:));

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


%% LOCAL FUNCTIONS

function [spec_power, lim_energy, ax, hfig] = ...
                        parse_plot_storages_input(storages, varargin)
% Parses varargin input
 
    if nargin == 1
        opt = hybridset();
        spec_power = mean([storages.spec_power]);
        lim_energy = 1;
    end

    if nargin == 2
        if ishybridset(varargin{1})
            opt = varargin{1};
            spec_power = mean([storages.spec_power]);
            lim_energy = 1;
        elseif isnumeric(varargin{1})
            opt = hybridset();
            spec_power = varargin{1};
            lim_energy = 1;
        elseif isvalidsignal(varargin{1});
            opt = hybridset();
            spec_power = varargin{1}.power/varargin{1}.maxint;
            lim_energy = varargin{1}.maxint;
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 2nd input')
        end
    end

    if nargin >= 3
        if isnumeric(varargin{1})
            spec_power = varargin{1};
            lim_energy = 1;
        elseif isvalidsignal(varargin{1});
            spec_power = varargin{1}.power/varargin{1}.maxint;
            lim_energy = varargin{1}.maxint;
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 2nd input')
        end

        if ishybridset(varargin{2})
            opt = varargin{3};
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 3rd input')
        end
    end

    if nargin < 4
        ax = 'none';
    else
        ax = varargin{3};
    end

    if strcmpi(ax, 'none')
        if ~opt.plot_stor
            hfig = figure(104);
        else
            hfig = figure(opt.plot_stor);
        end
        clf;
        ax = gca;
    else
        hfig = gcf;
    end

end%fcn
