function plot_economic(ecodata, fig)
%function plot_economic(base, peak, hybrid, noreload, reload, ssingle)

if nargin < 2
    fig = randi([1, 1e5], 1);
end

% Linewidth definitions
thin = get(0, 'defaultLineLineWidth');
%thick = 2*thin;
thinner = 0.5*thin;

% unpack vars
base = ecodata.base;
peak = ecodata.peak;
hybrids = ecodata.hybrids;
noreload = ecodata.noreload;
reload = ecodata.reload;
ssingle = ecodata.single;
     
% Some scaling variables
power_single = base(1).trans_p(0);
energy_single = base(1).trans_e(0);
costall = [];
cuteval = linspace(0, 1, 1e3)';
for ii = numel(hybrids)
   costhybrid = hybrids{ii}.cost(cuteval);
   costall = [costall; costhybrid(:,3)]; %#ok
end
cost_min = 1; %min(costall(:));

% color definitions for storages
basecolors = winter(length(base));
peakcolors = autumn(length(peak) + 1);
 

%% Plot hybridisation curve

% generate subplots with handles
figure(fig);
clf
s1 = subplot(1, 100, [1 40]);
hold on, grid off, axis([0, energy_single, 0, power_single])
s2 = subplot(1, 100, [43 80]);
hold on, grid off, axis([-1.5, 1.5, 0, 1])
s3 = subplot(1, 100, [83 100]);
hold on, grid off, %axis([0, 1.5, 0, 1])

%% single and hybridisation curve fill area with patch
evec = linspace(0, energy_single);
patch(s1, evec, reload.e_p_in_base(evec), [0.87, 0.87, 0.87], ...
      'FaceAlpha', 0.5, 'EdgeColor', 'none')
patch(s1, evec, noreload.e_p_in_base(evec), [0.83, 0.83, 0.83], ...
      'FaceAlpha', 0.5, 'EdgeColor', 'none')

plot(s1, evec, ssingle(evec), ':', 'Color', [0.4, 0.4, 0.4], ...
     'linewidth', thin)
plot(s1, evec, reload.e_p_in_base(evec), ':', 'Color', [0.4, 0.4, 0.4], ...
     'linewidth', thin)
plot(s1, evec, noreload.e_p_in_base(evec), ':', 'Color', [0.4, 0.4, 0.4], ...
     'linewidth', thin)

% Specific power lines of storages
% plot base storages
for ii = 1:length(base)
    plot(s1, evec, base(ii).e_p_in_base(evec), 'Color', basecolors(ii,:), ...
         'linewidth', thin)
end
% plot peak storages
for ii = 1:length(peak)
    plot(s1, evec, peak(ii).e_p_in_base(evec), 'Color', peakcolors(ii,:), ...
         'linewidth', thin)
end

[cheap, cheap2nd] = get_cheapest(hybrids);

for ii = 1:size(cheap, 1)
    % extract info for boundaries, energies, powers, cost
    startcut = cheap(ii, 1);
    endcut = cheap(ii, 2);
    baseNO = cheap(ii, 3);
    peakNO = cheap(ii, 4);
    cutarea = linspace(startcut, endcut)';
    energies = hybrids{baseNO,peakNO}.energies(cutarea);
    eb = energies(:,1)/energy_single;
    ea = energies(:,3)/energy_single;
    powers = hybrids{baseNO,peakNO}.powers(cutarea);
    pb = powers(:,1)/power_single;
    pa = powers(:,3)/power_single;
    costs = hybrids{baseNO,peakNO}.cost(cutarea);
    cb = costs(:,1)/cost_min;
    ca = costs(:,3)/cost_min;
     
    % plot colored areas
    patch(s2, [0; eb; 0], [startcut; cutarea; endcut], ...
          basecolors(baseNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)
    patch(s2, [eb; flip(ea)], [cutarea; flip(cutarea)], ...
          peakcolors(peakNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)
    patch(s2, -[0; pb; 0], [startcut; cutarea; endcut], ...
          basecolors(baseNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)
    patch(s2, -[pb; flip(pa)], [cutarea; flip(cutarea)], ...
          peakcolors(peakNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)
    patch(s3, [0; cb; 0], [startcut; cutarea; endcut], ...
          basecolors(baseNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)
    patch(s3, [cb; flip(ca)], [cutarea; flip(cutarea)], ...
          peakcolors(peakNO, :), ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.5)

    % plot complete max line, and peak base lines
    plot(s2, eb, cutarea, 'Color', 'k', 'linewidth', thinner)
    plot(s2, ea, cutarea, 'Color', 'k', 'linewidth', thin)
    plot(s2, -pb, cutarea, 'Color', 'k', 'linewidth', thinner)
    plot(s2, -pa, cutarea, 'Color', 'k', 'linewidth', thin)

    plot(s3, cb, cutarea, 'Color', 'k', 'linewidth', thinner)
    plot(s3, ca, cutarea, 'Color', 'k', 'linewidth', thin)

    % borders of areas
    plot(s2, [-pa(1) ea(1)], [cutarea(1) cutarea(1)], ...
         'Color', 'k', 'linewidth', thinner)
    plot(s2, [-pa(end) ea(end)], [cutarea(end) cutarea(end)], ...
         'Color', 'k', 'linewidth', thinner)
    plot(s3, [0 ca(end)], [cutarea(end) cutarea(end)], ...
         'Color', 'k', 'linewidth', thinner)
end

% 2nd Cheapest
for ii = 1:size(cheap2nd, 1)
    % extract info for boundaries, energies, powers, cost
    startcut = cheap2nd(ii, 1);
    endcut = cheap2nd(ii, 2);
    baseNO = cheap2nd(ii, 3);
    peakNO = cheap2nd(ii, 4);
    cutarea = linspace(startcut, endcut)';
    energies = hybrids{baseNO,peakNO}.energies(cutarea);
    eb = energies(:,1)/energy_single;
    ea = energies(:,3)/energy_single;
    powers = hybrids{baseNO,peakNO}.powers(cutarea);
    pb = powers(:,1)/power_single;
    pa = powers(:,3)/power_single;
    costs = hybrids{baseNO,peakNO}.cost(cutarea);
    cb = costs(:,1)/cost_min;
    ca = costs(:,3)/cost_min;

    % plot complete max line, and peak base lines
    plot(s2, eb, cutarea, '--', 'Color', 'k', 'linewidth', thinner)
    plot(s2, ea, cutarea, '--', 'Color', 'k', 'linewidth', thin)
    plot(s2, -pb, cutarea, '--', 'Color', 'k', 'linewidth', thinner)
    plot(s2, -pa, cutarea, '--', 'Color', 'k', 'linewidth', thin)

    plot(s3, cb, cutarea, '--', 'Color', 'k', 'linewidth', thinner)
    plot(s3, ca, cutarea, '--', 'Color', 'k', 'linewidth', thin)
end

% black center line in 2nd graph and overdim = 1 lines
plot(s3, [1, 1], [0, 1], 'k:', 'linewidth', thinner)
plot(s2, [1, 1], [0, 1], 'k:', 'linewidth', thinner)
plot(s2, [-1, -1], [0, 1], 'k:', 'linewidth', thinner)
plot(s2, [0, 0], [0, 1], 'k', 'linewidth', thin)
% get axis setting for scnd plot

end%fcn main


%% Local Functions

function [cheapest, cheapest2nd] = get_cheapest(hybrids)
    % Determines the cheapest base/peak storage combination in power cut 
    % bound. E.g. 0.3, 2, 1 means from power cut 0 to 0.3 base storage number 2
    % combined with peak storage number 1 is the cheapest one
    % Same principle for 2nd cheapest

    cut = linspace(0, 1, 1e5+1)';
    costs = zeros(length(cut), numel(hybrids));

    for ii = 1:numel(hybrids)
        singlecosts = hybrids{ii}.cost(cut);
        costs(:,ii) = singlecosts(:,3);
    end
    
    [~, pair] = min(costs, [], 2);
    costs2nd = costs;
    for ii = 1:length(pair)
        costs2nd(ii, pair(ii)) = Inf;
    end
    [~, pair2nd] = min(costs2nd, [], 2);

    [bounds, base, peak] = find_bounds(cut, pair, size(hybrids));
    cheapest = [bounds, base, peak];
    [bounds, base, peak] = find_bounds(cut, pair2nd, size(hybrids));
    cheapest2nd = [bounds, base, peak];
end

function [bounds, base, peak] = find_bounds(cut, pair, dimhybrid)
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
            [thisbase, thispeak] = ind2sub(dimhybrid, currentpair);
            base = [base; thisbase]; %#ok
            peak = [peak; thispeak]; %#ok
            currentpair = thispair;
            startcut = cut(ii);
        end
    end
    if startcut < 1-5e-2
        bounds = [bounds; startcut, 1];
        [thisbase, thispeak] = ind2sub(dimhybrid, currentpair);
        base = [base; thisbase];
        peak = [peak; thispeak]; 
    end
end
