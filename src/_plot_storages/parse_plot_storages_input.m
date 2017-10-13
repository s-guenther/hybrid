function [spec_power, lim_energy, ax, hfig] = ...
                        parse_plot_storages_input(storages, varargin)
% PARSE_PLOT_STORAGES_INPUT
%
%   Parses varargin input of plot_storages
 
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
        elseif isnumeric(varargin{1}) && isscalar(varargin{1})
            opt = hybridset();
            spec_power = varargin{1};
            lim_energy = 1;
        elseif isnumeric(varargin{1}) && isvector(varargin{1})
            opt = hybridset();
            spec_power = varargin{1}(2)/varargin{1}(1);
            lim_energy = varargin{1}(1);
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 2nd input')
        end
    end

    if nargin >= 3
        if isnumeric(varargin{1}) && isscalar(varargin{1})
            spec_power = varargin{1};
            lim_energy = 1;
        elseif isnumeric(varargin{1}) && isvector(varargin{1})
            spec_power = varargin{1}(2)/varargin{1}(1);
            lim_energy = varargin{1}(1);
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
