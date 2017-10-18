function ax = plot_specific_eco_data(ecodata, dtype, limits, ax, opt)
% PLOT_SPECIFIC_ECO_DATA plots specified function of ecodata
%
%   AX = PLOT_SPECIFIC_ECO_DATA(ECODATA, DTYPE, <LIMITS>, <AX>, <OPT>)
%   plots the DTYPE functions of ECODATA, using the limits LIMITS to the
%   axes AX. If LIMITS is not provided, they are determined automatically
%   by using the minimum DTYPE for each section. If AX is not provided, the
%   current axes (gca) is used. OPT is the option struct from HYBRIDSET().
%
%   DTYPE can be 'cost', 'energy' or 'power'.
%
%   ECODATA and LIMITS must be of the same size.
%
% See also PLOT_ECO, ECO.

if nargin < 5
    opt = hybridset();
end
if nargin < 4
    ax = gca;
end
if nargin < 3
    limits = get_min_limits(ecodata, dtype, opt);
end

% Generate percentage axis
ax.Color = 'none';
axrel = axes('Position', ax.Position);
uistack(ax, 'top')
% Reverse backward axes
axrel.XAxisLocation = 'top';
axrel.YTick = [];
xlabel(axrel, 'Base/Peak Rel')

% color and linedefinitions for storages
basecolors = winter(size(ecodata, 1));
peakcolors = autumn(size(ecodata, 2) + 1);
thick = 4*get(0, 'defaultLineLineWidth');

% Initialization; for determination of axes limits
minvals = [];
edgevals = []; 
edgecuts = [];
% Plot patches and main line
for ii = 1:numel(ecodata)
    if isempty(limits{ii}) % no place where pair is cheapest
        continue
    end
    curlimits = limits{ii};
    for ilimit = 1:size(curlimits, 1)
        startcut = curlimits(ilimit, 1);
        endcut = curlimits(ilimit, 2);
        cut = linspace(startcut, endcut, 1e2);
        base = ecodata(ii).base.(dtype)(cut);
        peak = ecodata(ii).peak.(dtype)(cut);
        both = ecodata(ii).both.(dtype)(cut);
        base = base./both;
        peak = peak./both;
        [basecol, peakcol] = ind2sub(size(ecodata), ii);
        patch(axrel, ...
              [0, base, 0], [cut(1), cut, cut(end)], ...
              basecolors(basecol, :), ...
              'FaceAlpha', 0.5)
        patch(axrel, ...
              [base, flip(peak + base)], [cut, flip(cut)], ...
              peakcolors(peakcol, :), ...
              'FaceAlpha', 0.5)
        plot(ax, both, cut, 'Color', 'k', 'LineWidth', thick);
        text(axrel, 0.4, mean(cut([1, end])), ...
             strjoin(ecodata(ii).names, ' + '));
        edgevals = [edgevals, both([1, end])]; %#ok
        edgecuts = [edgecuts, cut([1, end])]; %#ok
        minvals = [minvals, min(both)]; %#ok
    end
end

xmin = min(minvals);
[~, ind] = sort(edgecuts);
edgevals = edgevals(ind);
xmax = max(edgevals(2:end-1));
% repair xmax if only one pair is plotted
if isempty(xmax)
    xmax = min(edgevals);
    if abs(xmax - xmin) < 1e-6
        xmax = 1.5*xmin;
    end
end
ax.XLim = [xmin-0.1*(xmax-xmin), xmax+2*(xmax-xmin)];
ax.YLim = [0, 1];
axrel.XLim = [0, 1];
axrel.YLim = [0, 1];

end
