% MINIMAL is an example executing all relevant functions
%
% Script, does not have a function signature.
%
% run
%   path(path, genpath(cd))
% in advance while in root folder '$HYBRID'

opt = hybridset('verbose', 1, 'cut', linspace(0, 1, 7));

signal = gen_signal(@(t) sin(t*2*pi) + 3*sin(3*t*2*pi), 1, opt);
hybdata = hybrid(signal, opt);

opt2 = hybridset('verbose', 1, 'plot_sim', 104);
sim05inter = sim_operation(signal, 0.5, opt);
sim05nointer = sim_operation(signal, 0.5, 'nointer', opt2);

storages = gen_storages([1, 2, 5, 10], opt);
ecodata = eco(hybdata, storages, opt);
