function hfigs = plot_study_results(results, base_fig_no)
% PLOT_STUDY_RESULTS plots all results from study_signal_group and similar
%
% Calls plot_testcase for each individal result.
%
% Input:
%   results     output of study_signal_group
%   base_fig_no optional, the figure handles consecutive starting from this
%               number + 1; default: 500
%
% Output:
%   hfigs       array/vector of figure handles

if nargin < 2
    base_fig_no = 500;
end

nresults = length(results);
for ii = 1:nresults
    results{ii}{4} = base_fig_no + ii;
end

hfigs = zeros(nresults, 1);
for ii = 1:nresults
    hfigs(ii) = plot_testcase(results{ii}{:});
end

end
