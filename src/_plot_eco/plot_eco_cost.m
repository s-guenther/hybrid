function ax = plot_eco_cost(ecodata, limits, ax, opt)
% PLOT_ECO_COST plots cost function of ecodata
%
%   AX = PLOT_ECO_COST(ECODATA, <LIMITS>, <AX>) plots the cost functions of
%   ECODATA, using the limits LIMITS to the axes AX. If LIMITS is not
%   provided, they are determined automatically by using the minimum costs
%   for each section. If AX is not provided, the current axes (gca) is
%   used.
%
%   ECODATA and LIMITS must be of the same size.
%
% See also PLOT_ECO, ECO.

if nargin < 4
    opt = hybridset();
end
if nargin < 3
    ax = gca;
end
if nargin < 2
    limits = get_min_limits(ecodata, 'cost', opt);
end

ax = plot_specific_eco_data(ecodata, 'cost', limits, ax, opt);

end
