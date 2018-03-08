function valid = isvaliddtype(dtype)
% ISVALIDDTYPE checks if a dtype string is valid
%

names = {'cost', 'power', 'energy'};
valid = ischar(dtype) && any(strcmpi(dtype, names));

end
