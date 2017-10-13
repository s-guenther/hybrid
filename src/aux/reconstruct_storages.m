function storages = reconstruct_storages(ecodata)
% RECONSTRUCT_STORAGES builds storage structure from ecodata structure
%
%   STORAGES = RECONSTRUCT_STORAGES(ECODATA)
%
% See also ECO, GEN_STORAGES

if ~isvalideco(ecodata)
    error('HYBRID:aux:invalid_input', ...
          'Input is not an eco struct')
end

[nbase, npeak] = size(ecodata);

base_spec_powers = zeros(1, nbase);
base_costs = zeros(1, nbase);
base_names = cell(1, nbase);
peak_spec_powers = zeros(1, npeak);
peak_costs = zeros(1, npeak);
peak_names = cell(1, npeak);

for ii = 1:nbase
    base_spec_powers(ii) = ecodata(ii, 1).spec_powers(1);
    base_costs(ii) = ecodata(ii, 1).costs(1);
    base_names{ii} = ecodata(ii, 1).names{1};
end
for ii = 1:npeak
    peak_spec_powers(ii) = ecodata(1, ii).spec_powers(2);
    peak_costs(ii) = ecodata(1, ii).costs(2);
    peak_names{ii} = ecodata(1, ii).names{2};
end

storages = gen_storages([base_spec_powers, peak_spec_powers], ...
                        [base_costs, peak_costs], ...
                        [base_names, peak_names]);

end
