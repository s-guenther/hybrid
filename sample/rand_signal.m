function signal = rand_signal(seed, ...
                              ruggedness, n_harmonics, high_harmonic, ...
                              symmetric, n_subperiods, zerosections, ...
                              period, amplitude)
% rand_signal generates a random signal satisfying energy constraints
%
% Generates a random signal, which has an integral function which starts at
% zero, never becomes negative, and ends at zero. Signal is reproduceable by
% specifying the seed of the random generator. Various options for shaping
% amplitude, period, harmonics, ruggedness.
%
% Input:
%   seed            optional, default 'shuffle', integer number for random
%                   generator
%   ruggedness      optional, default 3, abstract measure for fluctuations in
%                   signal
%   n_harmonics     optional, default 3, integer, number of harmonics in signal
%                   option: if vector is passed, use this specific harmonics
%                   instead of generating them randomly
%   high_harmonic   optional, default 10, highest occouring harmonic in signal
%                   superflous if vector is passed in n_harmonics
%   symmetric       optional, default 0, boolean, if true: discharge side is
%                   point symmmetric to charge site
%   n_subperiods    optional, default 1, number of subperiods within the signal
%   zerosections    optional, default 0, specifies the percentage of time
%                   where the signal is zero
%   period          optional, default 2*pi, length of period
%   amplitude       optional, default 1, maximum peak (positive or negative)
%
%   The last 3 parameters do not alternate the random generation of the
%   signal, rather they stretch/compress the beforehand randomly generated
%   signal.
%
%   CAUTION: Sets the matlab random generator to rng('shuffle', twister) at
%   the end of the algorithm.

if nargin < 1
    seed = 'shuffle';
end
if nargin < 2
    ruggedness = 3;
end
if nargin < 3
    n_harmonics = 3;
end
if nargin < 4
    high_harmonic = 10;
end
if nargin < 5
    symmetric = 0;
end
if nargin < 6
    n_subperiods = 1;
end
if nargin < 7
    zerosections = 0;
end
if nargin < 8
    period = 2*pi;
end
if nargin < 9
    amplitude = 1;
end

% initialize random generator
rng(seed, 'twister');


%% Charging phase TODO call subfcn here, construct mult periods in main fcn

% set expected charge power and duration
mu = rand();
Tc = ceil(100*rand());

% Set frequency an amplitudes of harmonics
if length(n_harmonics) > 1
    harmonics = n_harmonics;
else
    harmonics = [sort(randi([2 high_harmonic-1], 1, n_harmonics - 1)), ...
                 high_harmonic];
end
amp_harm = mu*ruggedness*(harmonics/max(harmonics)).^(1/5).* ...
           (1 + 0.3*randn(size(harmonics)));

% generate base signal and add harmonics iteratively
base_sig = @(t) mu;
for ii = 1:length(harmonics)
    n_points = harmonics(ii) + 1;
    points = [0, (1:(n_points-2)) + (rand(1, n_points-2)-0.5), n_points]*Tc/n_points;
    vals = base_sig(points) + randn(1, n_points)*amp_harm(ii);
    base_sig = @(t) interp1(points, vals, t, 'spline');
end

% determine max amplitude
real_amplitude = max(abs(base_sig(linspace(0, Tc, 1e5))));
real_period = Tc;
signal.amplitude = amplitude;
signal.period = period;
signal.fcn = @(t) base_signal(t*real_period/period)*amplitude/real_amplitude;
signal.fcn = @(t) interp1(period/real_period*points, ...
                          amplitude/real_amplitude*vals, ...
                          t,  ...
                          'spline');

% to ensure fresh numbers for further calculations within matlab
rng('shuffle', 'twister');

end%mainfcn
