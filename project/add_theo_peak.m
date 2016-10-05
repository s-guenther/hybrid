function result_mod = add_theo_peak(result)
% ADD_THEO_PEAK adds the theoretical calculated peak to result struct
%
% Calculates the theoretical peak of the given input signal to the result
% struct.
%
% Input:
%   result      struct, see hybrid_leaf calculation
%
% Output:
%   result_mod  same as result from input, field added:
%       .theo_peak  [x, y] of the maximum in the transformed peak leaf

form = result.parameter(1);
crest = result.parameter(2);

[xp, yp] = calc_peak(form, crest);

result_mod = result;
result_mod.theo_peak = [xp, yp];

end
