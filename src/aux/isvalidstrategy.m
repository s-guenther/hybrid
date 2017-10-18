function valid = isvalidstrategy(strategy)
% ISVALIDSTRATEGY checks if a strategy string is valid
%

names = {'inter', 'nointer'};
valid = ischar(strategy) && any(strcmpi(strategy, names));

end
