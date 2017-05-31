function hybrid = calc_eco_combination(base, peak, hcurve)
% CALC_ECO_COMBINATION determines dim storage and cost w/ respect to cut
%
% Generates a function handle which returns base and storage pair with specific
% powers.
% 
% Input:
%   base        struct from calc_economic()
%   peak        as base
%   hcurve      struct from calc_economic()
% Output:
%   hybrid      struct
%       .powers     [base peak both]
%       .energies   [base peak both]
%       .cost       [base peak both]

% virtual points
ebvirt = @(cut) base.cut_e_in_base(cut);
epvirt = @(cut) peak.cut_e_in_base(cut);
pcut = @(cut) base.cut_p_in_base(cut);
ehvirt = @(cut) hcurve.p_e_in_base(pcut(cut));

ebase = @(cut) min(epvirt(cut), ehvirt(cut)) ...
                    .*(ebvirt(cut) < min(epvirt(cut), ehvirt(cut))) + ...
               ebvirt(cut) ...
                    .*(ebvirt(cut) >= min(epvirt(cut), ehvirt(cut)));
pbase = @(cut) base.e_p_in_base(ebase(cut));

epeakinbase = @(cut) min(ehvirt(cut), epvirt(cut));
ppeakinbase = @(cut) peak.e_p_in_base(epeakinbase(cut));
epeak = @(cut) peak.trans_e(epeakinbase(cut));
ppeak = @(cut) peak.trans_p(ppeakinbase(cut));

costbase = @(cut) base.e_cost_in_own(ebase(cut));
costpeak = @(cut) peak.e_cost_in_own(epeak(cut));

hybrid.energies = @(cut) [ebase(cut), ...
                          epeak(cut), ...
                          ebase(cut) + epeak(cut)];
hybrid.powers = @(cut) [pbase(cut), ...
                        ppeak(cut), ...
                        pbase(cut) + ppeak(cut)];
hybrid.cost = @(cut) [costbase(cut), ...
                      costpeak(cut), ...
                      costbase(cut) + costpeak(cut)];

end
