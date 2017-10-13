function valid = ishybridset(opt)
% ISHYBRIDSET tests if a struct is a hybridset struct
%
% Checks if a structure is a hybrid structure

% TODO add all parameters

names = {'cut', 'odeset', 'optimset', 'verbose', 'discrete_solver', ...
         'continuous_solver'};
valid = isstruct(opt) && all(isfield(opt, names));

end
