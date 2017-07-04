function signal = gen_sig_step(time, val, opt)
% GEN_SIG_STEP specialized fcn of gen_signal for step functions
%
% Generates SIGNAL struct for step function input.
%
% SIGNAL = GEN_SIG_STEP(TIME, VAL, OPT) where TIME and VAL are vector value
% pairs describing the function and OPT the options struct obtained from
% HYBRIDSET.
%
% See also GEN_SIGNAL.

verbose(opt.verbose, 1, ...
        'Generating signal of type ''linear''.')

signal.type = 'step';
signal.time = time;
signal.val = val;
signal.period = time(end);
signal.amplitude = max(abs(val));
signal.maxint = max(cumsum(time, val));

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
    rms = sqrt(1/TT*xx.^2*[0; diff(tt)]');
end


function arv = average_rectified_value(signal)
    % ARV implementation for nonuniform step functions
    tt = signal.time;
    xx = signal.val;
    TT = signal.period;
    arv = 1/TT*abs(xx)*[0; diff(tt)]';
end
