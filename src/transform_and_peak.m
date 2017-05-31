function result_mod = transform_and_peak(result)
% TRANSFORM_AND_PEAK coord trans data and adds peak pos of peak storage
%
% Calls coord_trans_result and then adds the peak of the leaf function of
% the peak storage afterwards.
%
% Input:
%   result      result struct, output of coord_trans_result
%
% Output:
%   result_mod  same struct, added fields:
%       .peak           [x, y] of peak in leaf function of peak storage
%       .transformed    data from coord_trans_result

result_mod = coord_trans_result(result);
xvecpeak = result_mod.transformed(:,3);
yvecpeak = result_mod.transformed(:,5);
[xpmax, ypmax] = find_peak(xvecpeak, yvecpeak);
result_mod.peak = [xpmax, ypmax];

end
