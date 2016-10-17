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
%
% Strategy works as long as a change of sign in power profile is not
% "severe".  Then, the peak storage cannot be accidentally be empty or full,
% respectively.

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
    % Solve system with real strategy
    storage_info.e_base = base.energy;
    storage_info.e_peak = peak.energy;
    storage_info.p_base = base.power;
    storage_info.p_peak = peak.power;

    p_base = @(t, p_in, e_base, e_peak) ...
             nth_output(1, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        storage_info, signal);
    p_peak = @(t, p_in, e_base, e_peak) ...
             nth_output(2, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        storage_info, signal);
    p_diff = @(t, p_in, e_base, e_peak) ...
             nth_output(3, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        storage_info, signal);

    ode = @(t, y) [dedt_base(p_base(t, p_in(t), y(1), y(2)));
                   dedt_peak(p_peak(t, p_in(t), y(1), y(2)))];

    opt = odeset('MaxStep', max_step);
    [t, y] = ode45(ode, [0 period], [0, 0], opt);

    % plot
    p_in_vec = p_in(t);
    p_base_vec = p_base(t, p_in_vec, y(:,1), y(:,2));
    p_peak_vec = p_peak(t, p_in_vec, y(:,1), y(:,2));
    p_diff_vec = p_diff(t, p_in_vec, y(:,1), y(:,2));
    figure(floor(double(output))),
    plot(t, [y, p_in_vec, p_base_vec, p_peak_vec, p_diff_vec]),
    legend({'e_{base}','e_{peak}', ...
            'p_{in}', 'p_{base}', 'p_{peak}', 'p_{diff}'}, ...
           'Location', 'NorthWest'),
    grid on,
    axis tight
end

end%mainfcn
