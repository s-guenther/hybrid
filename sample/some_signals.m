% SOME_SIGNALS generates a few sample signals and saves them to mat files
%

opt = hybridset('amv_rel_tol', 1e-2, ...
                'int_zero_rel_tol', 1e-2, 'verbose', 2, ...
                'plot_sim', 0, 'plot_sig', 0, 'plot_hyb', 0);

seeds = [1234, 1000, 9876, 2345, 3456];

t = linspace(0, 2*pi, 1e4);
cut = linspace(0, 1, 1e2);

for seed = seeds
    r = rand_signal(seed);
    sig = gen_signal(r.fcn, r.period, opt);
    hyb = hybrid(sig, opt);
    sim02 = sim_operation(sig, 0.2, opt);
    sim05 = sim_operation(sig, 0.5, opt);
    sim08 = sim_operation(sig, 0.8, opt);

    ps = sig.fcn(t);
    es = cumtrapz(t, ps);
    intere = hyb.hybrid.baseenergy(cut);
    interp = hyb.hybrid.basepower(cut);
    nointere = hyb.nointer.baseenergy(cut);
    nointerp = hyb.nointer.basepower(cut);
    pb = zeros(3, length(t));
    pp = zeros(3, length(t));
    eb = zeros(3, length(t));
    ep = zeros(3, length(t));
    pb(1,:) = sim02.powers.base(t);
    pb(2,:) = sim05.powers.base(t);
    pb(3,:) = sim08.powers.base(t);
    eb(1,:) = sim02.energies.base(t);
    eb(2,:) = sim05.energies.base(t);
    eb(3,:) = sim08.energies.base(t);
    pp(1,:) = sim02.powers.peak(t);
    pp(2,:) = sim05.powers.peak(t);
    pp(3,:) = sim08.powers.peak(t);
    ep(1,:) = sim02.energies.peak(t);
    ep(2,:) = sim05.energies.peak(t);
    ep(3,:) = sim08.energies.peak(t);

    save(['sig', num2str(seed), '.mat'], ...
         't', 'pb', 'eb', 'pp', 'ep', 'ps', 'es', ...
         'intere', 'interp', 'nointere', 'nointerp')

end
