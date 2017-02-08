function calc_economic(signal, reload, no_reload, ...
                       technologies, prices, names)
% CALC_ECONOMIC calculates overdim and costs for specific technologies
%
% Investigates the hybridisation line with specific technologies and
% determines the resulting overdimensioning depending on power cut
%
% Input:
%   signal          signal struct, see issignalstruct()
%   reload          [n, [E P]] tuples for hybridisation line w/ reload
%   no_reload       same as reload, but w/o reload strategy
%   technologies    [m, 1] specific powers for m technologies
%   prices          optional, [m, 1] price for each technology, 
%                   default: normalized lengths (with specific power)
%   names           optional, {m, 1} cell array of strings with names of
%                   technologies, default: {'1', '2', ...}

if nargin < 5
    prices = technologies/min(technologies);
end
if nargin < 6
    names = cellfun(@num2str, num2cell(technologies), ...
                    'UniformOutput', false);
end

assert(length(prices) == length(technologies), ...
       'number of technologies and prices differ')
assert(length(names) == length(technologies), ...
       'number of technologies and names differ')


energy_single = reload(end, 1);
power_single = reload(end, 2);
spec_power_single = power_single/energy_single;

%% Initialize storage array of structs
storages(1:length(technologies)) = struct('name', 'name', ...
                                          'type', 'type', ...
                                          'spec_power', 0, ...
                                          'spec_cost_energy', 0, ...
                                          'spec_cost_power', 0, ...
                                          'e_p_in_base', @(x)x, ...
                                          'e_p_in_peak', @(x)x, ...
                                          'e_p_in_own', @(x)x, ...
                                          'e_p_in_other', @(x)x, ...
                                          'cut_ep_in_base', @(x)x, ...
                                          'cut_ep_in_peak', @(x)x, ...
                                          'cut_ep_in_own', @(x)x, ...
                                          'cut_ep_in_other', @(x)x, ...
                                          'e_cost_in_own', @(x)x, ...
                                          'p_cost_in_own', @(x)x, ...
                                          'base2peak', @(x)x, ...
                                          'peak2base', @(x)x);

%% Populate
for ii = 1:length(storages)
    storages(ii).base2peak = @(e, p) deal(energy_single - e, ...
                                          power_single - p);
    storages(ii).peak2base = @(e, p) storages(ii).base2peak(e, p);

    storages(ii).name = names(ii);
    storages(ii).spec_power = technologies(ii);
    storages(ii).spec_cost_energy = prices(ii);
    storages(ii).spec_cost_power = prices(ii)/storages(ii).spec_power;

    storages(ii).e_p_in_own = @(ee) storages(ii).spec_power*ee;
    storages(ii).e_p_in_other = @(ee) power_single - ...
                                storages(ii).e_p_in_own(energy_single - ee);

    if storages(ii).spec_power <= spec_power_single
        storages(ii).type = 'base';
        storages(ii).e_p_in_base = @(ee) storages(ii).e_p_in_own(ee);
        storages(ii).e_p_in_peak = @(ee) storages(ii).e_p_in_other(ee);
    else
        storages(ii).type = 'peak';
        storages(ii).e_p_in_peak = @(ee) storages(ii).e_p_in_own(ee);
        storages(ii).e_p_in_base = @(ee) storages(ii).e_p_in_other(ee);
    end

    storages(ii).cut_ep_in_base = @(cut) deal(solve(@(x) ...
                                              storages.e_p_in_base(x) - ...
                                              cut*spec_power_single), ...
                                              cut*spec_power_single);
    storages(ii).cut_ep_in_peak = @(cut) deal(solve(@(x) ...
                                              storages.e_p_in_peak(x) - ...
                                              (1-cut)*spec_power_single), ...
                                              (1-cut)*spec_power_single);
    if strcmp(storages(ii).type, 'base')
        storages(ii).cut_ep_in_own = @(cut) storages(ii).cut_ep_in_base(cut);
        storages(ii).cut_ep_in_other = @(cut) storages(ii).cut_ep_in_peak(cut);
    elseif strcmp(storages(ii).type, 'peak')
        storages(ii).cut_ep_in_own = @(cut) storages(ii).cut_ep_in_peak(cut);
        storages(ii).cut_ep_in_other = @(cut) storages(ii).cut_ep_in_base(cut);
    else
        error('Unknown storage type, somehow it was not assigned')
    end

end

% Construct Function handles for curves and single storage
f_noreload = @(ee) interp1(no_reload(:,1), no_reload(:,2), ee);
f_reload = @(ee) interp1(reload(:,1), reload(:,2), ee);
f_single = @(ee) interp1([0 energy_single], [0 power_single], ...
                          ee, 'linear', 'extrap');

%% Plot hybridisation curve

figure(), hold on, grid on, axis([0, energy_single, 0, power_single]),
evec = linspace(0, energy_single);

% single and hybridisation curve
plot(evec, f_single(evec), ':', 'Color', [0, 0, 0])
plot(evec, f_noreload(evec), '--', 'Color', [0, 0, 0])
plot(evec, f_reload(evec),  'Color', [0, 0, 0])

for ii = 1:length(storages)
    plot(evec, storages(ii).e_p_in_base(evec))
end
 

%% calc overdimensioning with respect to chi --> ep,eb, pp, pb


end
