% MINIMAL is an example executing all relevant functions
%
% Script, does not have a function signature.
%
% run
%   path(path, genpath(cd))
% in advance while in root folder '$HYBRID'

% Define some options for the calculation
opt = hybridset('verbose', 1, 'cut', linspace(0, 1, 7));

% Generate signal and calculate hybridisation diagram
signal = gen_signal(@(t) sin(t*2*pi) + 3*sin(3*t*2*pi), 1, opt);
hybdata = hybrid(signal, opt);

% Show simulation/operation for an allowed and prohibited power flow
sim05inter = sim_operation(signal, 0.25, opt);
% Change options, so the second result will be plotted into another figure
opt2 = hybridset('verbose', 1, 'plot_sim', 104);
sim05nointer = sim_operation(signal, 0.25, 'nointer', opt2);

% Perform some economic analysis
storages = gen_storages([3, 4, 8, 10], opt);
ecodata = eco(hybdata, storages, opt);

% Plot output in a combined result, change output figure again
opt3 = opt;
opt3.plot_hyb = 105;
plot_hybrid(hybdata, ecodata, signal, opt3);
% The same result is obtained by
%   [hybdata, ecodata] = hybrid(signal, storages, opt3)
