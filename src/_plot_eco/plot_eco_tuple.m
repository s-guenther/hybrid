function ax = plot_eco_tuple(ecodata, limits, ax, opt)
% PLOT_ECO_TUPLE plots tuple line into hybridisation diagram
%
%   AX = PLOT_ECO_TUPLE(ECODATA, <LIMITS>, <AX>) plots the tuples of
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

thick = 4*get(0, 'defaultLineLineWidth');

for ii = 1:numel(ecodata)
    if isempty(limits{ii}) % no place where pair is cheapest
        continue
    end
    curlimits = limits{ii};
    for ilimit = 1:size(curlimits, 1)
        startcut = curlimits(ilimit, 1);
        endcut = curlimits(ilimit, 2);
        %npoints = max(3, (endcut - startcut)*50);
        npoints = 1e2;
        cut = linspace(startcut, endcut, npoints);
        ecod = ecodata(ii);
        plot(ax, ...
             ecod.tuple.energy(cut), ecod.tuple.power(cut), ...
             'Color', [0.6, 0.6, 0.6], ...
             'LineWidth', thick, ...
             'Linestyle', '-')
    end
end

end
