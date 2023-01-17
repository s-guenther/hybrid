function [res] = hybrid_simple_call(signal)
% HYBRID_SIMPLE_CALL is a wrapper for HYBRID for step discharge signals
%
% It simplifies the invocation of the HYBRID toolbox methods and puts them
% into a single function which outputs the results as simple data types
% which can be easily exported and imported into Python.
%
% Syntax:
%
%    [data, hcurve, ccurve] = HYBRID_SIMPLE_CALL(signal)
%
% Input:
%    signal  1xn vector, time series data. It is expected that the signal
%            represents a step/stair signal of exactly one discharge cycle
%            (storage starts full, ends empty). Spacing is expected to be
%            equidistant
%
% Output:
%    res     1x21 vector, where the position within the vector encodes the
%            following information:
%                1: Hybrid Potential
%                2: Normalized Reload Potential
%                3: Hybrid Skewness
%             4-12: x-values encoding the standard hybrid curve*
%                   (normalized)
%            13-21: x-values encoding the no-reload-hybrid curve*
%                   (normalized)(the curve that is generated if the
%                   storages are forbidden to exchange power)
% 
% * The curve is evaluated at the following discrete points/cuts:
%  [0.075, 0.15, 0.225, 0.3, 0.4, 0.5, 0.625, 0.75, 0.875]


%% Define options for hybrid calculation
cuts = [0, 0.075, 0.15, 0.225, 0.3, 0.4, 0.5, 0.625, 0.75, 0.875, 1];
hybopts = hybridset('cut', cuts, 'verbose', 0, 'plot_sig', 0, 'plot_hyb', 0);

%% Prepare Signal
v = [-signal, signal];
t = 1:length(v);

sig = gen_signal(t, v, 'step', hybopts);

%% Call hybrid calculation
hyb = hybrid(sig, hybopts);

%% Extract data
h = hyb.hybrid_potential;
r = hyb.reload_potential;
s = hyb.hybrid_skewness;
couter = hyb.hybrid.baseenergy(cuts(2:end-1))/sig.maxint;
cinner = hyb.nointer.baseenergy(cuts(2:end-1))/sig.maxint;

res = [h, r, s, couter, cinner];

end
