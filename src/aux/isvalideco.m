function valid = isvalideco(ecodata)
% ISVALIDECO performs validity checks on the results of hybrid calc
%
% Checks if a structure is a eco structure

% TODO implement validity check

names = {'names', 'costs', 'spec_powers', 'base', 'peak', 'both', 'tuple'};
validvec = zeros(1, numel(ecodata));
for ii = 1:numel(validvec)
    validvec(ii) = isstruct(ecodata) && all(isfield(ecodata(ii), names));
end

valid = all(validvec);

end
