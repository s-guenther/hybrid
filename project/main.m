function out = main(signal, inter, calc_max_step, calc_max_tol, cut_off_vector)
% MAIN Gather main functionality of hybrid leaf tool
%
% Calculates energy and power for hybrid storage systems containing a base
% and a peak storage. With this, performance and e/p spread can be made
% visible and analysed.
% 
% Input:
%   signal          struct, see issignalstruct
%   inter           optional, default 0, calculates hybrid storage with an
%                   intermediate point strategy within the leaf, as a fraction
%                   of p_cut_ratio
%                   0.. original boundary of leaf
%                   1.. single storage e/p iso time line
%   calc_max_step   maximum integration step size
%                   optional, default 1e-2
%   calc_max_tol    maximum allowed tolerance between hybrid and single
%                   solution before error is thrown
%                   optional, default 1e-2
%   cut_off_vector  rel power sampling points
%                   optional, default nonuniformly spaced vector w/ 11 ele
%   
%
% Output:
%   out         struct
%       .single         .energy, .power of single storage (minimum)
%       .hybrid_table   [cut_off | base.energy | peak.energy | ...
%                        base.power | peak.power]
%       .reload_table   as hybrid table, with reloading strategy
%       .parameter      [form, crest, rms, arv, amv]
%       .transformed    rotated and normed (x,y) value pairs
%       .peak           (x,y) peak of transformed data (interpolated)
%       .theo_peak      theoretically obtained peak (x,y)
%
% Theory involves: cutting signal at specific value, calculating separate
% storages for this, no inter storage power flow (transloading). Only valid
% for point symmetric signals at the moment

assert(issignalstruct(signal), 'Invalid input - no signal struct')

if nargin < 2
    inter = 0;
end
if nargin < 3
    calc_max_step = 1e-2;
end
if nargin < 4
    calc_max_tol = 1e-2;
end
if nargin < 5
    cut_off_fcn = @(x) x - 0.12*sin(2*pi*x);
    cut_off_vector = cut_off_fcn([0:0.1:1]');
end


% Calculate single storage properties
[ssingle.energy, ssingle.power] = calc_single_storage(signal);


% Header of hybrid_table (preallocated two lines below):
% cut_off | base.energy | peak.energy | base.power | peak.power
% Header reload table
% cut_off | base.energy | peak.energy | base.power | peak.power
hybrid_table = [cut_off_vector, zeros(length(cut_off_vector), 4)];
reload_table = [cut_off_vector, zeros(length(cut_off_vector), 4)];
for ii = 1:length(cut_off_vector)
    cut_off = cut_off_vector(ii);

    [base, peak] = calc_hybrid_storage(signal, cut_off, ...
                                       inter, calc_max_step);

    [re_base, re_peak] = calc_hybrid_w_reload(signal, cut_off, ...
                                              inter, calc_max_step);
    hybrid_table(ii,:) = [cut_off, ...
                          base.energy, peak.energy, ...
                          base.power, peak.power];
    reload_table(ii,:) = [cut_off, ...
                          re_base.energy, re_peak.energy, ...
                          re_base.power, re_peak.power];

    hybrid.energy = base.energy + peak.energy;
    hybrid.power = base.power + peak.power;

    e_tol_achieved = abs((hybrid.energy - ssingle.energy)/ssingle.energy);
    p_tol_achieved = abs((hybrid.power - ssingle.power)/ssingle.power);
    assert(e_tol_achieved < calc_max_tol, ...
           'Hybrid Energy mismatches Single Storage Energy')
    assert(p_tol_achieved < calc_max_tol, ...
           'Hybrid power mismatches Single Storage power')

    reload.energy = re_base.energy + re_peak.energy;
    reload.power = re_base.power + re_peak.power;
    re_e_tol_achieved = abs((reload.energy - ssingle.energy)/ssingle.energy);
    re_p_tol_achieved = abs((reload.power - ssingle.power)/ssingle.power);
    assert(e_tol_achieved < calc_max_tol, ...
           'Hybrid Energy mismatches Single Storage Energy')
    assert(p_tol_achieved < calc_max_tol, ...
           'Hybrid power mismatches Single Storage power')
end


% Gather output
out.single = ssingle;
out.hybrid_table = hybrid_table;
out.reload_table = reload_table;
out.parameter = signal_parameters(signal);
out = transform_and_peak(out);
out = add_theo_peak(out);

end%fcn
