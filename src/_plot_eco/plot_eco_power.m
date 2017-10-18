function ax = plot_eco_power(ecodata, limits, ax)
% PLOT_ECO_POWER plots power function of ecodata
%
%   AX = PLOT_ECO_POWER(ECODATA, <LIMITS>, <AX>) plots the power functions of
%   ECODATA, using the limits LIMITS to the axes AX. If LIMITS is not
%   provided, they are determined automatically by using the minimum powers
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
    limits = get_min_limits(ecodata, 'power', opt);
end

ax = plot_specific_eco_data(ecodata, 'power', limits, ax, opt);

end
