function out = main(signal, calc_max_step, calc_max_tol, cut_off_vector)
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
%       .single         .energy, .power of single storage (minimum)
%       .hybrid_table   [cut_off | base.energy | peak.energy | ...
%                        base.power | peak.power]
%       .parameter      [form, crest, rms, arv, amv]
%       .transformed    rotated and normed (x,y) value pairs
%       .peak           (x,y) peak of transformed data (interpolated)
%
% Theory involves: cutting signal at specific value, calculating separate
% storages for this, no inter storage power flow (transloading). Only valid
% for point symmetric signals at the moment

assert(issignalstruct(signal), 'Invalid input - no signal struct')

if nargin < 2
    calc_max_step = 1e-2;
end
if nargin < 3
    calc_max_tol = 1e-2;
end
if nargin < 4
    cut_off_fcn = @(x) x - 0.12*sin(2*pi*x);
    cut_off_vector = cut_off_fcn([0:0.1:1]');
end


% Calculate single storage properties
[ssingle.energy, ssingle.power] = calc_single_storage(signal);


% Header of hybrid_table (preallocated two lines below):
% cut_off | base.energy | peak.energy | base.power | peak.power
hybrid_table = [cut_off_vector, zeros(length(cut_off_vector), 4)];
for ii = 1:length(cut_off_vector)
    cut_off = cut_off_vector(ii);
    [base, peak] = calc_hybrid_storage(signal, cut_off, calc_max_step);
    hybrid_table(ii,:) = [cut_off, ...
                          base.energy, peak.energy, ...
                          base.power, peak.power];
    hybrid.energy = base.energy + peak.energy;
    hybrid.power = base.power + peak.power;
    e_tol_achieved = abs((hybrid.energy - ssingle.energy)/ssingle.energy);
    p_tol_achieved = abs((hybrid.power - ssingle.power)/ssingle.power);
    assert(e_tol_achieved < calc_max_tol, ...
           'Hybrid Energy mismatches Single Storage Energy')
    assert(p_tol_achieved < calc_max_tol, ...
           'Hybrid power mismatches Single Storage power')
end


% Gather output
out.single = ssingle;
out.hybrid_table = hybrid_table;
out.parameter = signal_parameters(signal);
out = transform_and_peak(out);

end%fcn
