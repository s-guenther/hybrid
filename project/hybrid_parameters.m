function [hyb, rel] = hybrid_parameters(hybrid_result)
% HYBRID_PARAMETERS calculates hybridisation and reload factors
%
% Input:
%   hybrid_result   result structure from hybrid_leaf calculation
% Output:
%   hyb             Hybridisation Potential
%   rel             Reload Potential
%   hybfcn          Function handle of Hybridisation Factor
%   relfcn          Function handle of Reload Factor


[~, fenergy] = make_fcn_handle(hybrid_result.reload_table(:, [1 4 2]));
[~, fenergy_norel] = make_fcn_handle(hybrid_result.hybrid_table(:, [1 4 2]));


hyb = hybridisation_fcn(fenergy);
hyb_norel = hybridisation_fcn(fenergy_norel); 
rel = hyb - hyb_norel;

end


%% Local Functions

function [power, energy] = make_fcn_handle(chi_pwr_enrgy)
% Generates a function handle cut --> power, energy from input matrix

chi_pwr_enrgy(chi_pwr_enrgy < 0) = 0;

cutvec = chi_pwr_enrgy(:, 1);
powervec = chi_pwr_enrgy(:, 2);
energyvec = chi_pwr_enrgy(:, 3);

power = @(cut) interp1(cutvec, powervec, cut, 'linear');
energy = @(cut) interp1(cutvec, energyvec, cut, 'linear');

end

function hyb = hybridisation_fcn(energy_fcn)
% Calculates the Hybridisation factor of a function handle
e_single = energy_fcn(1);
hyb = 2*(integral(energy_fcn, 0, 1)/e_single - 1/2);
end
