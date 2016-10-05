function hfigs = plot_study_results(results, datatype, base_fig_no)
% PLOT_STUDY_RESULTS plots all results from study_signal_group and similar
%
% Calls plot_leaf or plot_transformed for each individal result.
%
% Input:
%   results     output of study_signal_group
%   datatype    optional, default: 'leaf', other accepted val: 'transformed'
%               defines which data will be plotted
%   base_fig_no optional, the figure handles consecutive starting from this
%               number + 1; default: 500
%
% Output:
%   hfigs       array/vector of figure handles

if nargin < 2
    datatype = 'leaf'
end
if nargin < 3
    base_fig_no = 500;
end

nresults = length(results);
for ii = 1:nresults
    results{ii}{4} = base_fig_no + ii;
end

hfigs = zeros(nresults, 1);
for ii = 1:nresults
    if strcmpi(datatype, 'leaf')
        hfigs(ii) = plot_leaf(results{ii}{:});
    elseif strcmpi(datatype, 'transformed')
        hfigs(ii) = plot_transformed(results{ii}{:});
    end
end

end
