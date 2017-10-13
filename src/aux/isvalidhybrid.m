function valid = isvalidhybrid(hybdata)
% ISVALIDHYBRID performs validity checks on the results of hybrid calc
%
% Checks if a structure is a hybrid structure

% TODO implement validity check

names = {'hybrid', 'nointer', 'hybrid_potential', 'reload_potential'};
valid = isstruct(hybdata) && all(isfield(hybdata, names));

end
