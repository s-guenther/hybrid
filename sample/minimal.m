path(path, genpath(cd))

signal = struct('fcn', @(t) sin(t), ...
                'period', 2*pi, ...
                'amplitude', 1);

results = main(signal)
hfig = plot_testcase(results, 'Simple Sinus', signal);
