function valid = isvalidstorage(storages)
% ISVALIDSTORAGE performs validity checks on the results of hybrid calc
%
% Checks if a structure is a storage structure

% TODO implement validity check

names = {'name', 'cost', 'spec_power'};
validvec = zeros(1, length(storages));
for ii = 1:length(validvec)
    validvec(ii) = isstruct(storages) && all(isfield(storages(ii), names));
end

valid = all(validvec);

end
