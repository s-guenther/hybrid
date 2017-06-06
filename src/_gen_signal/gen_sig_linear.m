function signal = gen_sig_linear(time, val, opt)
% GEN_SIG_LINEAR specialized fcn of gen_signal for fhandles
%
% Generates SIGNAL struct for piecewise linear function input.
%
% SIGNAL = GEN_SIG_STEP(TIME, VAL, OPT) where TIME and VAL are vector value
% pairs describing the function and OPT the options struct obtained from
% HYBRIDSET.
%
% See also GEN_SIGNAL.

signal.type = 'linear';
signal.time = time;
signal.val = val;
signal.period = time(end);
signal.amplitude = max(abs(val));
signal.maxint = max(cumtrapz(time, val));

signal.rms = root_mean_square(signal, opt);
signal.arv = average_rectified_value(signal, opt);
signal.form = signal.rms/signal.arv;
signal.crest = signal.amplitude/signal.rms;

end


%% LOCAL FUNCTIONS

function rms = root_mean_square(signal)
    % RMS implementation for nonuniform step functions
    % TODO is function correct?
    tt = signal.time;
    xx = signal.val;
    TT = signal.period;
    % integral of (mt + n)^2 is (mt + n)^3/3m
    % definite integral is ((m*t2 + n)^3 - (m*t1 + n)^3)/3m
    % find m and n for each timestep
    % m = (x2 - x1)/(t2 - t1)
    % n = x1 - m*t1
    mm = (xx(2:end) - xx(1:end-1))./(tt(2:end) - tt(1:end-1));
    nn = xx(1:end-1) - mm.*tt(1:end-1);
    sepints = ((mm*tt(2:end) + nn).^3 - (mm*tt(1:end-1) + nn).^3)./(3*mm);
    rms = sqrt(1/TT*sum(sepints));
end


function arv = average_rectified_value(signal)
    % ARV implementation for nonuniform step functions
    % TODO is function correct?
    tt = signal.time;
    xx = signal.val;
    TT = signal.period;
    arv = 1/TT*trapz(tt, xx);
end
