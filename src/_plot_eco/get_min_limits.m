function limits = get_min_limits(ecodata, dtype, opt)
% GET_MIN_LIMITS determines power cut ranges for cheapest storage pair
%
%   Determines the cheapest base/peak storage combination in power cut
%   bound. For each storage pair, a tuple of [lower bound, upper bound] is
%   determined. Output will be written to a cell array of vectors.
%
%   LIMITS = GET_MIN_LIMITS(ECODATA, DTYPE) with ECODATA being the result
%   of ECO() and DTYPE being either 'cost', 'energy', 'power'. LIMITS is of
%   the same size as ECODATA.
%
% See also PLOT_ECO, PLOT_SPECIFIC_ECO_DATA.

if nargin < 3
    opt = hybridset();
end

% TODO magic numbers that 1e-6 might be unstable
cut = linspace(1e-6, 1 - 1e-6, opt.cut_sample)';
costs = zeros(length(cut), numel(ecodata));

% evaluate costs at points of cut
for ii = 1:numel(ecodata)
    costs(:, ii) = ecodata(ii).both.(dtype)(cut);
end

% get cheapest storage pair for each point (index)
[~, pair] = min(costs, [], 2);

% get bounds
[bounds, base, peak] = find_bounds(cut, pair, size(ecodata));

% write bounds to output
limits = repmat({[]}, size(ecodata));
for ii = 1:size(bounds,1)
    limits{base(ii), peak(ii)} = [limits{base(ii), peak(ii)}; ...
                                  bounds(ii, :)];
end

end%mainfcn

%% LOCAL FCNS

function [bounds, base, peak] = find_bounds(cut, pair, dimeco)
    bounds = [];
    base = [];
    peak = [];
    startcut = cut(1);
    currentpair = pair(1);
    for ii = 2:length(cut)
        thispair = pair(ii);
        if thispair == currentpair
            continue
        else
            endcut = cut(ii-1);
            bounds = [bounds; startcut, endcut]; %#ok
            [thisbase, thispeak] = ind2sub(dimeco, currentpair);
            base = [base; thisbase]; %#ok
            peak = [peak; thispeak]; %#ok
            currentpair = thispair;
            startcut = cut(ii);
        end
    end
    if startcut < 1-5e-2 % TODO eliminate magic number
        bounds = [bounds; startcut, 1];
        [thisbase, thispeak] = ind2sub(dimeco, currentpair);
        base = [base; thisbase];
        peak = [peak; thispeak]; 
    end
end
