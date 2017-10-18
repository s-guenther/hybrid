% SAMPLE_SIGNALS generates various signals and adds them to workspace
%
% Script, does not have a function signature.

fprintf('\nThis will add the following variables/signals to workspace:\n')
fprintf(['    sin01   sinsin01   tri01   saw01   needle01   pulse01   tetris01   rand01\n', ...
         '    sin03   sinsin03   tri03   saw03   needle03   pulse03   tetris03   rand03\n', ...
         '    sin10   sinsin10   tri10   saw10   needle10   pulse10   tetris10   rand10\n', ...
         '    square01\n\n'])
in = input('Are you sure you want to continue? [Y/n]\nINPUT>> ', 's');

if ~any(strcmp(in, {'Y', 'y', 'Yes', 'yes', ''}))
    disp('Aborting.')
    return
end

opt = hybridset('plot_sig', 0);

disp('Generating Analytic Signals...')

sin01 = gen_signal(@(t) sin(t), 2*pi, opt);
sin03 = gen_signal(@(t) abs(sin(3*t)).*(t <= pi) - abs(sin(3*t)).*(t > pi), 2*pi, opt);
sin10 = gen_signal(@(t) abs(sin(10*t)).*(t <= pi) - abs(sin(10*t)).*(t > pi), 2*pi, opt);

square01 = gen_signal([pi 2*pi], [1 -1], opt);

sinsin01 = gen_signal(@(t) (sin(t) + 1*sin(11*t))/2, 2*pi, opt);
sinsin03 = gen_signal(@(t) (sin(t) + 3*sin(11*t))/4, 2*pi, opt);
sinsin10 = gen_signal(@(t) (sin(t) + 10*sin(11*t))/11, 2*pi, opt);

tri01 = gen_signal([0 1 2 3 4]/4*2*pi, [0 1 0 -1 0], 'linear', opt);
tri03 = gen_signal([0 1 2 3 4 5 6 7 8 9 10 11 12]/12*2*pi, ...
                   [0 1 0 1 0 1 0 -1 0 -1 0 -1 0], ...
                   'linear', opt);
tri10 = gen_signal(linspace(0, 2*pi, 41), ...
                   [repmat([0 1], 1, 10)  repmat([0 -1], 1, 10) 0], ...
                   'linear', opt);

saw01 = gen_signal([0 1 1+1e-6 2]*pi, [0 1 -1 0], 'linear', opt);
saw03 = gen_signal([0 1 1+1e-6 2 2+1e-6 3 3+1e-6 4 4+1e-6 5 5+1e-6 6]/6*2*pi, ...
                   [0 1 0 1 0 1 -1 0 -1 0 -1 0], ...
                   'linear', opt);
temp_tt = (repmat([1 1+1e-6], 19, 1) + repmat((0:18)', 1, 2))';
temp_tt = [0; temp_tt(:); 20]/20*2*pi;
temp_xx = [repmat([0 1], 1, 10), repmat([-1 0], 1, 10)];
saw10 = gen_signal(temp_tt, temp_xx, 'linear', opt);

temp_xx = [repmat([0 0.01 1 0.01], 1, 1), ...
           repmat([0 -0.01 -1 -0.01], 1, 1), 0];
temp_tt = (repmat([0 0.495 0.5 0.505 ], 2, 1) + repmat((0:1)', 1, 4))';
temp_tt = [temp_tt(:); 2]/2*2*pi;
needle01 = gen_signal(temp_tt, temp_xx, 'linear', opt);

temp_xx = [repmat([0 0.01 1 0.01], 1, 3), ...
           repmat([0 -0.01 -1 -0.01], 1, 3), 0];
temp_tt = (repmat([0 0.495 0.5 0.505], 6, 1) + repmat((0:5)', 1, 4))';
temp_tt = [temp_tt(:); 6]/6*2*pi;
needle03 = gen_signal(temp_tt, temp_xx, 'linear', opt);

temp_xx = [repmat([0 0.01 1 0.01], 1, 10), ...
           repmat([0 -0.01 -1 -0.01], 1, 10), 0];
temp_tt = (repmat([0 0.495 0.5 0.505], 20, 1) + repmat((0:19)', 1, 4))';
temp_tt = [temp_tt(:); 20]/20*2*pi;
needle10 = gen_signal(temp_tt, temp_xx, 'linear', opt);

clear temp_tt temp_xx

pulse01 = pulsed_signal(2*pi/(2), 2*pi/(20), 1, 0, 1, opt);
pulse03 = pulsed_signal(2*pi/(6), 2*pi/(60), 1, 0, 3, opt);
pulse10 = pulsed_signal(2*pi/(20), 2*pi/(200), 1, 0, 10, opt);

tetris01 = pulsed_signal(2*pi/(2), 2*pi/(4), 1, 0.5, 1, opt);
tetris03 = pulsed_signal(2*pi/(6), 2*pi/(12), 1, 0.5, 3, opt);
tetris10 = pulsed_signal(2*pi/(20), 2*pi/(40), 1, 0.5, 10, opt);

disp('Generating Random Signals...')

rand01 = rand_signal(opt, 1659874);
rand03 = rand_signal(opt, 2590912);
rand10 = rand_signal(opt, 6051211);

disp('Finished.')
