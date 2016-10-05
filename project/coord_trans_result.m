function results_mod = coord_trans_result(results)
% COORD_TRANS_RESULT rotates and norms result of main/hybrid_leaf
%
% Takes result struct from main calculation and applies rot_and_norm to
% adequate data.
%
% (e, p) |--> (x, y)
%
% Input:
%   results      result struct, output of main/hybrid_leaf
%
% Output:
%   results_mod  same struct, with added field:
%       .transformed    [x_base; x_peak; y_base; y_peak]

cut_off = results.hybrid_table(:,1);

ebase = results.hybrid_table(:,2);
pbase = results.hybrid_table(:,4);
epeak = results.hybrid_table(:,3);
ppeak = results.hybrid_table(:,5);

[xbase, ybase] = rot_and_norm(ebase, pbase);
[xpeak, ypeak] = rot_and_norm(epeak, ppeak);

results_mod = results;
results_mod.transformed = [cut_off, xbase, xpeak, ybase, ypeak];

end
