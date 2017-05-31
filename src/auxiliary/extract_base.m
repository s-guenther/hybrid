function [reload, no_reload] = extract_base(leafdata)
% EXTRACT_BASE separates needed hybridisition curve info from hybrid table
%
% Takes the table result of hybrid_leaf calculation and separates the needed
% hybridisation base storage curve from it. For strategy with reloading, and
% for strategy without
%
% Input:
%   leafdata   result of hybrid_leaf()
%
% Output:
%   reload      [n 2] vector pair E/P describing base line, reloading
%               considered
%   no_reload   [n 2] vector pair E/P describing base line, reloading
%               not considered

reload = leafdata.reload_table(:, [2, 4]);
no_reload = leafdata.hybrid_table(:, [2, 4]);

end
