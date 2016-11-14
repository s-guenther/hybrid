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
%   ruggedness      optional, default 3, abstract measure for fluctuations
%                   in signal, if passed as vector, use this specific
%                   ruggedness for each frequency. Size must be equal to
%                   n_harmonics or length(n_harmonics), respectively.
%   n_harmonics     optional, default 3, integer, number of harmonics in
%                   signal option: if vector is passed, use this specific
%                   harmonics instead of generating them randomly
%   high_harmonic   optional, default 10, highest occouring harmonic in
%                   signal superflous if vector is passed in n_harmonics
%   rel_mu          optional, default 0.5, fraction of the expected
%                   rectified mean value the signal is shifted upwards
%   symmetric       optional, default 0, boolean, if true: discharge side is
%                   point symmmetric to charge site
%   zerosections    optional, default 0, specifies the percentage of
%                   time where the signal is zero
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
    rel_mu = 0.5;
end
if nargin < 6
    symmetric = 0;
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
Tp = 100;
Tc = ceil(Tp*(0.5*rand() + 0.25));

% Set frequency and amplitudes of harmonics
if length(n_harmonics) > 1
    harmonics = n_harmonics;
else
    harmonics = [sort(randi([2 high_harmonic-1], 1, n_harmonics - 1)), ...
                 high_harmonic];
end
amp_harm = abs(1 + ruggedness.*randn(size(harmonics)));

% generate base signal and add harmonics iteratively
mean_gauss = sqrt(2/pi);
mu = rel_mu*mean(amp_harm)*mean_gauss;
base_sig = @(t) mu.*(t <= Tc) + -mu*(Tc)/(Tp-Tc).*(t > Tc);
for ii = 1:length(harmonics)
    n_points = 4*harmonics(ii) + 1;
    points = [0, (1:(n_points-2)) + (rand(1, n_points-2)-0.5), n_points]*4*Tp/n_points;
    vals = base_sig(points) + randn(1, n_points)*amp_harm(ii);
    base_sig = @(t) interp1(points, vals, t, 'pchip');
end

% integrate signal, add mu_top, mu_bot, cut exceeding vals
[time, energy] = ode45(@(t,y) base_sig(t), [0 4*Tp], 0, ...
                       odeset('MaxStep', 2e-1*4*Tp/n_points));
power = base_sig(time);
cut_low = 0;
cut_top = inf;
% filter energy exceedings;
power = power(energy > cut_low & energy < cut_top);
dtime = [0; diff(time)];
dtime = dtime(energy > cut_low & energy < cut_top);
time = [cumsum(dtime)];
energy = energy(energy > cut_low & energy < cut_top);
% construct f_handle again
base_sig = @(t) interp1(time, power, t, 'pchip');


% determine max amplitude
real_amplitude = max(abs(power));
real_period = time(end);
signal.amplitude = amplitude;
signal.period = period;
signal.fcn = @(t) interp1(period/real_period*time, ...
                          amplitude/real_amplitude*power, ...
                          t,  ...
                          'pchip');

% to ensure fresh numbers for further calculations within matlab
rng('shuffle', 'twister');

end%mainfcn
