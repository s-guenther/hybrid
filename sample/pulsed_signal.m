function pulse = pulsed_signal(T, dT, Amp, dAmp, n, opt)
% PULSED_SIGNAL Generates a pulsed signal
%
%   Generates a signal structure of type 'step' representing a repetitive
%   pulse of the following form:
%
%           -
%           |         OOO   OOO   OOO   OOO
%       Amp |      -  OOO   OOO   OOO   OOO         n = 4
%           | dAmp |  OOOOOOOOOOOOOOOOOOOOOOOO
%           |      |  OOOOOOOOOOOOOOOOOOOOOOOO
%           -      - |<->|                    OOOOOOOOOOOOOOOOOOOOOOOO
%                     dT                      OOOOOOOOOOOOOOOOOOOOOOOO
%                    |<--->|                  OOO   OOO   OOO   OOO
%                       T                     OOO   OOO   OOO   OOO
%
%   pulse = PULSED_SIGNAL(T, dT, Amp, dAmp, n)
%
%   Input:
%       T       Period of one pulse, optional, default 1
%       dT      Pulse width of one pulse (absolute), optional, default 0.1
%       Amp     Amplitude of Pulse (peak to zero), optional, default 1
%       dAmp    Residual Amplitude in the rest of the time frame
%               (absolute), optional, default 0
%       n       number of positive repetitions, optional, default 10
%       opt     options structure by HYBRIDSET()
%
%   Output:
%       pulse   signal struct of type 'step', see GEN_SIGNAL()
%
%   The period of the total pulsed signal will be 2*n*T.
%
% See also RAND_SIGNAL, GEN_SIGNAL.

if nargin < 1
    T = 1;
end
if nargin < 2
    dT = 0.1;
end
if nargin < 3
    Amp = 1;
end
if nargin < 4
    dAmp = 0;
end
if nargin < 5
    n = 10;
end
if nargin < 6
    opt = hybridset();
end

times = (repmat([dT T], 2*n, 1) + ...
         repmat([T T], 2*n, 1).*repmat((0:2*n-1)', 1, 2))';
times = times(:);

pos_amps = repmat([Amp dAmp], n, 1);
amps = [pos_amps; -pos_amps]';
amps = amps(:);

pulse = gen_signal(times, amps, 'step', opt);

end
