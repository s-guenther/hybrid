function valid = isvalidstrategy(strategy)
% ISVALIDHYBRID performs validity checks on the results of hybrid calc
%
% Checks if a structure is a hybrid structure

% TODO implement validity check

names = {'inter', 'nointer'};
valid = ischar(strategy) && any(strcmpi(strategy, names));

end
