function out = main(signal)
% MAIN Gather main functionality of hybrid leaf tool
%
% Calculates energy and power for hybrid storage systems containing a base
% and a peak storage. With this, performance and e/p spread can be made
% visible and analysed.
% 
% Input:
%   signal      struct, see issignalstruct
%
% Output:
%   out         struct
%       .e_single   energy of single storage needed for given signal
%       .p_single   power of single storage needed for given signal
%
% Theory involves: cutting signal at specific value, calculating separate
% storages for this, no inter storage power flow (transloading). Only valid
% for point symmetric signals at the moment

assert(issignalstruct(signal), 'Invalid input - no signal struct')

% Calculate single storage properties
[ssingle.energy, ssingle.power] = calc_single_storage(signal);

% Calculate e/p for hybrid storage/multiple storages
cut_off_vector = linspace(0, 1, 1e1 + 1)';
% Header of hybrid_table (preallocated two lines below):
% cut_off | base.energy | peak.energy | base.power | peak.power
hybrid_table = [cut_off_vector, zeros(length(cut_off_vector), 4)];
for ii = 1:length(cut_off_vector)
    cut_off = cut_off_vector(ii);
    [base, peak] = calc_hybrid_storage(signal, cut_off);
    hybrid_table(ii,:) = [cut_off, ...
                          base.energy, peak.energy, ...
                          base.power, peak.power];
    hybrid.energy = base.energy + peak.energy;
    hybrid.power = base.power + peak.power;
    assert(abs((hybrid.energy - ssingle.energy)/ssingle.energy) < 1e-1, ...
               'Hybrid Energy mismatches Single Storage Energy')
    assert(abs((hybrid.power - ssingle.power)/ssingle.power) < 1e-1, ...
               'Hybrid power mismatches Single Storage power')
end

hfig = randi(1e8, 1);
figure(hfig)
hold on, grid on
plot(hybrid_table(:,2), hybrid_table(:,4), 'g')
plot(hybrid_table(:,3), hybrid_table(:,5), 'r')
hold off, axis tight


% Gather output
out.single = ssingle;
out.hybrid_table = hybrid_table;
out.hfig = hfig;

end%fcn
