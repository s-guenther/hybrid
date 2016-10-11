function [base, peak] = calc_hybrid_w_reload(signal, p_cut_ratio, ...
                                             inter, max_step)
% CALC_HYBRID_W_RELOAD simulation w/ inter storage power flow
%
% Calculates for a point symmetric input signal and a given power ratio the
% energy and power of the peak and base storage, considering inter storage
% power flow. The strategy tries to minimize energy of peak storage.
%
% Input:
%   signal          signal struct, see issignalstruct
%   p_cut_ratio     power ratio, where peak begins to work, between 0..1
%   inter           optional, default 0, calculates hybrid storage with an
%                   intermediate point strategy within the leaf, as a fraction
%                   of p_cut_ratio, partial reloading of maximum possible
%                   0.. maximum possible reload strategy
%                   1.. original boundary of leaf
%   max_step        optional, default 1e-2, max integration step size
%
% Output:
%   base.energy     energy of base storage
%   base.power      power of base storage
%   peak.energy     energy of peak storage
%   peak.power      power of peak storage

assert(issignalstruct(signal), 'Invalid input - no signal struct')

if nargin < 3
    inter = 0;
end
if nargin < 4
    max_step = 1e-2;
end

% Define storage odes
dedt_base = @(p_base) -p_base;
dedt_peak = @(p_peak) -p_peak;

% extract signal info
p_in = signal.fcn;
period = signal.period;
p_base_max = signal.amplitude*p_cut_ratio;
p_base = @(t, e_peak) op_strat_reload_dim(p_in(t), t, p_base_max, e_peak, period);

% Construct dae
% y1.. e_base, y2.. e_peak, y3.. dae for p_base, y4.. dae for p_peak
dae = @(t,y) [dedt_base(p_base(t, y(2)));
              dedt_peak(y(3));
              p_in(t) + p_base(t, y(2)) + y(3);
              ];


% Set up for dae solving
opt = odeset('MaxStep', max_step, 'Mass', diag([1, 1, 0]));
[t, y] = ode23t(dae, [0 signal.period], [0, 0, 0], opt);

plot(t,y),
legend('e_base','e_peak','p_peak'), 
grid on, 
axis tight

end%mainfcn
