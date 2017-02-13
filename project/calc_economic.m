function [base, peak, hybrids, noreload, reload, ssingle] = ...
            calc_economic(reload, no_reload, technologies, prices, names)
% CALC_ECONOMIC calculates overdim and costs for specific technologies
%
% Investigates the hybridisation line with specific technologies and
% determines the resulting overdimensioning depending on power cut
%
% Input:
%   reload          [n, [E P]] tuples for hybridisation line w/ reload
%   no_reload       same as reload, but w/o reload strategy
%   technologies    [m, 1] specific powers for m technologies
%   prices          optional, [m, 1] price for each technology, 
%                   default: normalized lengths (with specific power)
%   names           optional, {m, 1} cell array of strings with names of
%                   technologies, default: {'1', '2', ...}

if nargin < 4
    prices = sqrt(1 + technologies.^2);
end
if nargin < 5
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
 emptystruct = struct('name', 'name', ...
                      'type', 'type', ...
                      'spec_power', 0, ...
                      'spec_cost_energy', 0, ...
                      'spec_cost_power', 0, ...
                      'e_p_in_base', @(x)x, ...
                      'e_p_in_peak', @(x)x, ...
                      'e_p_in_own', @(x)x, ...
                      'e_p_in_other', @(x)x, ...
                      'cut_e_in_base', @(x)x, ...
                      'cut_p_in_base', @(x)x, ...
                      'cut_e_in_peak', @(x)x, ...
                      'cut_p_in_peak', @(x)x, ...
                      'cut_e_in_own', @(x)x, ...
                      'cut_p_in_own', @(x)x, ...
                      'cut_e_in_other', @(x)x, ...
                      'cut_p_in_other', @(x)x, ...
                      'e_cost_in_own', @(x)x, ...
                      'p_cost_in_own', @(x)x, ...
                      'trans_e', @(x)x, ...
                      'trans_p', @(x)x);
storages(1:length(technologies)) = emptystruct;

%% Populate
for ii = 1:length(storages)
    storages(ii).trans_e = @(e) energy_single - e;
    storages(ii).trans_p = @(p) power_single - p; 

    storages(ii).name = names(ii);
    storages(ii).spec_power = technologies(ii);
    storages(ii).spec_cost_energy = prices(ii);
    storages(ii).spec_cost_power = prices(ii)/storages(ii).spec_power;

    storages(ii).e_cost_in_own = @(ee) storages(ii).spec_cost_energy*ee;
    storages(ii).p_cost_in_own = @(pp) storages(ii).spec_cost_power*pp;

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

    storages(ii).cut_e_in_base = ...
        @(cut) fsolve(@(x) storages(ii).e_p_in_base(x) - cut*power_single, ...
                      ones(size(cut)), optimset('Display', 'off'));
    storages(ii).cut_p_in_base = @(cut) cut*power_single;

    storages(ii).cut_e_in_peak = ...
        @(cut) fsolve(@(x) storages(ii).e_p_in_peak(x) - (1-cut)*power_single, ...
                      ones(size(cut)), optimset('Display', 'off'));
    storages(ii).cut_p_in_peak = @(cut) (1-cut)*power_single;

    if strcmp(storages(ii).type, 'base')
        storages(ii).cut_e_in_own = @(cut) storages(ii).cut_e_in_base(cut);
        storages(ii).cut_p_in_own = @(cut) storages(ii).cut_p_in_base(cut);
        storages(ii).cut_e_in_other = @(cut) storages(ii).cut_e_in_peak(cut);
        storages(ii).cut_p_in_other = @(cut) storages(ii).cut_p_in_peak(cut);
    elseif strcmp(storages(ii).type, 'peak')
        storages(ii).cut_e_in_own = @(cut) storages(ii).cut_e_in_peak(cut);
        storages(ii).cut_p_in_own = @(cut) storages(ii).cut_p_in_peak(cut);
        storages(ii).cut_e_in_other = @(cut) storages(ii).cut_e_in_base(cut);
        storages(ii).cut_p_in_other = @(cut) storages(ii).cut_p_in_base(cut);
    else
        error('Unknown storage type, somehow it was not assigned')
    end

end

% Construct Function handles for curves and single storage
noreload = @(ee) interp1(no_reload(:,1), no_reload(:,2), ee, 'linear', 'extrap');
reload = @(ee) interp1(reload(:,1), reload(:,2), ee, 'linear', 'extrap');
ssingle = @(ee) interp1([0 energy_single], [0 power_single], ...
                          ee, 'linear', 'extrap');

%% calc overdimensioning with respect to chi --> ep,eb, pp, pb

% find base and peak storages in storages
base = [];
peak = [];
for ii = 1:length(storages)
    if strcmpi(storages(ii).type, 'base')
        base = [base; storages(ii)]; %#ok (disable mlint msg)
    else
        peak = [peak; storages(ii)]; %#ok (disable mlint msg)
    end
end
 
% 'allocate' solution cell matrix
hybrids = cell(length(base), length(peak));
for ibase = 1:length(base)
    for ipeak = 1:length(peak)
        hybrids{ibase, ipeak} = ...
            calc_eco_combination(base(ibase), peak(ipeak), reload);
    end
end



end
