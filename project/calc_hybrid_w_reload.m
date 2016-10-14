function [base, peak] = calc_hybrid_w_reload(signal, p_cut_ratio, ...
                                             inter, max_step, output)
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
%                   intermediate point strategy within the leaf, as a
%                   fraction of p_cut_ratio, partial reloading of maximum
%                   possible
%                   0.. maximum possible reload strategy
%                   1.. original boundary of leaf
%   max_step        optional, default 1e-2, max integration step size
%   output          optional, default 0, if True (arbitrary integer number),
%                   plot diagram in figure <integer output number>
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
if nargin < 5
    output = 0;
end


% Define storage odes
dedt_base = @(p_base) -p_base;
dedt_peak = @(p_peak) -p_peak;

% extract signal info
period = signal.period;
p_base_max = signal.amplitude*p_cut_ratio;
p_peak_max = signal.amplitude*(1 - p_cut_ratio);

p_in = signal.fcn;

p_base = @(p_in, e_peak) op_strat_reload_dim(p_in, e_peak, ...
                                             p_base_max, p_peak_max);
p_peak = @(p_in, p_base) -p_in - p_base;

% Construct ode w/ op_strat
% y1.. e_base, y2.. e_peak
ode = @(t,y) [dedt_base(p_base(p_in(t), y(2)));
              dedt_peak(p_peak(p_in(t), p_base(p_in(t), y(2))))];

% Set up ode solving
opt = odeset('MaxStep', max_step);
[t, y] = ode45(ode, [0 period/2], [0, 0], opt);

% Determine base, peak storage dimensions
peak.energy = max(y(:, 2));
peak.power = signal.amplitude*(1 - p_cut_ratio);

diff_peak = peak.energy - y(end, 2);
base.energy = y(end, 1) - diff_peak;
base.power = signal.amplitude*p_cut_ratio;

% output
if output
    p_in_vec = p_in(t);
    p_base_vec = p_base(p_in_vec, y(:,2));
    p_peak_vec = p_peak(p_in_vec, p_base_vec);
    figure(floor(double(output))),
    plot(t, [y, p_base_vec, p_peak_vec, p_in_vec]),
    legend({'e_base','e_peak','p_base', 'p_peak', 'p_in'}, ...
           'Location', 'NorthWest'),
    grid on,
    axis tight
end

end%mainfcn
