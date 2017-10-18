function ax = plot_eco_energy(ecodata, limits, ax)
% PLOT_ECO_ENERGY plots energy function of ecodata
%
%   AX = PLOT_ECO_ENERGY(ECODATA, <LIMITS>, <AX>) plots the energy functions of
%   ECODATA, using the limits LIMITS to the axes AX. If LIMITS is not
%   provided, they are determined automatically by using the minimum
%   energies for each section. If AX is not provided, the current axes
%   (gca) is used.
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
    limits = get_min_limits(ecodata, 'energy', opt);
end

ax = plot_specific_eco_data(ecodata, 'energy', limits, ax, opt);

end
