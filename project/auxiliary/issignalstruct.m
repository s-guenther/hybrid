function truefalse = issignalstruct(signal)
% ISSIGNALSTRUCT checks if input is a struct containing various fields
%
% If signal is a struct containing the fields 'fcn', 'period', 'amplitude',
% return true.
%
% Input:
%   signal      some variable
% Output:
%   truefalse   bool

compfieldnames = {'fcn', 'period', 'amplitude'};
try
    truefalse = all(ismember(compfieldnames, fieldnames(signal)));
catch
    truefalse = false;
end

end%fcn
