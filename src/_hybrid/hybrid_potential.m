function hyb = hybrid_potential(hybstruct)
% HYBRID_POTENTIAL hybridisation potential for hybridisation data
%
% HYB_POT = HYBRID_POTENTIAL(HYBSTRUCT) calculates the hybridisation
% potential HYB_POT for HYBDATA, where HYBDATA is a substructure from the
% output of HYBRID. HYBSTRUCT = HYBDATA.hybrid or HYBSTRUCT =
% HYBDATA.nointer.
%
% See also HYBRID

hyb = 2*integral(hybstruct.baseenergy, 0, 1)/hybstruct.baseenergy(1) - 1;

end
