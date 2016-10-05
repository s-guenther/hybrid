% Generate various signals
siggeneric.fcn = @(t) 0;
siggeneric.amplitude = 1;
siggeneric.period = 2*pi;

sig_square = siggeneric;
sig_square.fcn = @(t)square(t);

sig_trapz = siggeneric;
sig_trapz.fcn = @(t) interp1([0 0.2 1 1.8 2 2.2 3 3.8 4]*2*pi/4, ...
                            [0 1 1 1 0 -1 -1 -1 0], ...
                            mod(t, 2*pi), ...
                            'linear');

sig_sin = siggeneric;
sig_sin.fcn = @(t)sin(t);

sig_tri = siggeneric;
sig_tri.fcn = @(t) interp1([0 1 2 3 4]*2*pi/4, ...
                          [0 1 0 -1 0], ...
                          mod(t, 2*pi), ...
                          'linear');

sig_dist = siggeneric;
sig_dist.fcn = @(t) interp1([0 0.5 1 1.5 2 2.5 3 3.5 4]*2*pi/4, ...
                           [0 0.2 1 0.2 0 -0.2 -1 -0.2 0], ...
                           mod(t, 2*pi), ...
                           'linear');

sig_high = siggeneric;
sig_high.fcn = @(t) interp1([0 0.9 1 1.1 2 2.9 3 3.1 4]*2*pi/4, ...
                           [0 0.05 1 0.05 0 -0.05 -1 -0.05 0], ...
                           mod(t, 2*pi), ...
                           'linear');


% Calculate leaf diagram (and signal parameters)
res_square = hybrid_leaf(sig_square);
res_trapz = hybrid_leaf(sig_trapz );
res_sin = hybrid_leaf(sig_sin);
res_tri = hybrid_leaf(sig_tri);
res_dist = hybrid_leaf(sig_dist);
res_high = hybrid_leaf(sig_high);


% Plot calculated results
hfig_square = plot_testcase(sig_square, res_square, 'Square', 101);
hfig_trapz = plot_testcase(sig_trapz, res_trapz , 'Trapezodial Signal ', 102);
hfig_sin = plot_testcase(sig_sin, res_sin, 'Sinus', 103);
hfig_tri = plot_testcase(sig_tri, res_tri, 'Triangle', 104);
hfig_dist = plot_testcase(sig_dist, res_dist, 'Distorted Triangle', 105);
hfig_high = plot_testcase(sig_high, res_high, 'Highly Distorted Triangle', 106);
