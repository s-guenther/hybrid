function [base, peak] = calc_hybrid_w_reload(signal, p_cut_ratio, ...
                                             inter, max_step, rel_tol, output)
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
%   max_step        optional, default 1e-1, max integration step size
%   rel_tol         optional, default 1e-5, reletive integration error
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
    max_step = 1e-1;
end
if nargin < 5
    rel_tol = 1e-5;
end
if nargin < 6
    output = 0;
end

% set solver properties
ode_opt = odeset('RelTol', rel_tol, 'MaxStep', max_step);

% extract signal info
period = signal.period;
p_base_max = signal.amplitude*p_cut_ratio;
p_peak_max = signal.amplitude*(1 - p_cut_ratio);

% integrate positive part of signal
[build, decay] = build_decay_generator(signal, p_cut_ratio);
[tpos, ypos] = ode45(@(t,y) switched_decay_ode(t, y, build, decay), ...
                     [0 period], 0, ode_opt);

% integrate negative part of signal
reversed = signal;
reversed.fcn = mirrorx(reverse(signal.fcn, period));
[revbuild, revdecay] = build_decay_generator(reversed, p_cut_ratio);
[tneg, yneg] = ode45(@(t,y) switched_decay_ode(t, y, revbuild, revdecay), ...
                     [0 period], 0, ode_opt);

% check validity
assert(all(abs([ypos(end), yneg(end)]) < 5e-1), ...
       'Unable to meet decay end condition - impossible storage config');

% determine maximum peak storage size
peak.energy = max(max(ypos), max(yneg));
peak.power = p_peak_max;

% To determine base, calc single and substract peak
[ssingle.energy, ssingle.power] = calc_single_storage(signal, max_step);
base.energy = ssingle.energy - peak.energy;
base.power = p_base_max;


% plot if output true, for this, simulated with correct strategy before
% TODO refactor and exclude in separate function
if output
    % Solve system with real strategy
    storage_info.e_base = base.energy;
    storage_info.e_peak = peak.energy;
    storage_info.p_base = base.power;
    storage_info.p_peak = peak.power;

    % construct soc predictor
    fw_decay = @(t) interp1(tpos, ypos, t, 'spline');
    rev_bw_decay = @(t) interp1(tneg, yneg, t, 'spline');
    bw_decay = reverse(rev_bw_decay, period);
    soc_fcn = ideal_predictor(bw_decay);

    p_in = signal.fcn;
    p_base = @(t, p_in, e_base, e_peak) ...
             nth_output(1, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        soc_fcn, storage_info, signal);
    p_peak = @(t, p_in, e_base, e_peak) ...
             nth_output(2, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        soc_fcn, storage_info, signal);
    p_diff = @(t, p_in, e_base, e_peak) ...
             nth_output(3, @op_strat_reload, t, p_in, e_base, e_peak, ...
                        soc_fcn, storage_info, signal);

    % Define storage odes
    dedt_base = @(p_base) -p_base;
    dedt_peak = @(p_peak) -p_peak;

    ode = @(t, y) [dedt_base(p_base(t, p_in(t), y(1), y(2)));
                   dedt_peak(p_peak(t, p_in(t), y(1), y(2)))];

    [t, y] = ode45(ode, [0 period], [0, 0], ode_opt);

    % plot
    p_in_vec = p_in(t);
    p_base_vec = p_base(t, p_in_vec, y(:,1), y(:,2));
    p_peak_vec = p_peak(t, p_in_vec, y(:,1), y(:,2));
    p_diff_vec = p_diff(t, p_in_vec, y(:,1), y(:,2));
    figure(floor(double(output))),
    subplot(60,1,1:30),
    plot(t, p_in_vec, 'b', t, p_base_vec, 'g', ...
         t, p_peak_vec, 'r', t, 1e1*p_diff_vec, 'm');
    ax = gca; ax.XTick = [((0:0.125:1)*signal.period)]; ax.XTickLabel = {};
    legend({'p_{in}', 'p_{base}', 'p_{peak}', 'p_{diff}*1e1'}, ...
           'Location', 'NorthWest'),
    ylabel('Power')
    grid on, axis tight, ylim([-1 1]*max(abs(p_in_vec)))

    % build handle for bw decay fcn
    rev_bw_decay = @(t) interp1(tneg, yneg, t, 'spline');
    bw_decay = reverse(rev_bw_decay, period);
    bw_soc = @(t) bw_decay(t)/peak.energy;
    % .. and for single storage
    [tsingle, ysingle] = ode45(@(t,y) signal.fcn(t), [0, signal.period], 0, ...
                               ode_opt);
    intsig = @(t) interp1(tsingle, ysingle, t, 'spline');
    intadd = y(:,1) + y(:,2);
    socsig = @(t) intsig(t)/ssingle.energy;
    socadd = intadd/ssingle.energy;

    subplot(60,1,32:48)
    plot(t, intsig(t), 'b', t, intadd, 'b--', ...
         t, y(:,1), 'g', t, y(:,2), 'r', t, bw_decay(t), 'r--');
    ax = gca; ax.XTick = [((0:0.125:1)*signal.period)]; ax.XTickLabel = {};
    legend({'e_{single}', 'e_{add}', 'e_{base}', 'e_{peak}', ...
            'e_{back}'}, 'Location', 'NorthWest'),
    ylabel('Energy')
    text(0.02*t(end), 0.5*max(max(y)), ...
         {['e_{peak} = ' num2str(peak.energy), ...
           ',  e_{base} = ' num2str(base.energy)]; ...
          ['p_{peak} = ' num2str(peak.power), ...
          ',  p_{base} = ' num2str(base.power)]; ...
          ['(e/p)_{peak} = ' num2str(peak.energy/peak.power), ...
           ',  (e/p)_{base} = ' num2str(base.energy/base.power), ...
           ',  (e/p)_{single} = ' num2str(ssingle.energy/ssingle.power)]})
    grid on, axis tight

    subplot(60,1,50:60)
    plot(t, socsig(t), 'b', ...
         t, socadd, 'b--', ...
         t, y(:,1)/max(y(:,1)), 'g', ...
         t, y(:,2)/max(y(:,2)), 'r', ...
         t, bw_soc(t), 'r--', ...
         t, soc_fcn(y(:,2), t), 'm')
    ax = gca; ax.XTick = ((0:0.125:1)*signal.period);
    legend({'soc_{single}', 'soc_{add}', 'soc_{base}', ...
            'soc_{peak}', 'soc_{aim}'}, 'Location', 'NorthWest'),
    ylabel('SOC')
    xlabel('Time')
    grid on, axis tight
end

end%mainfcn
