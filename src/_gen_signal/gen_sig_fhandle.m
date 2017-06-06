function signal = gen_sig_fhandle(fcn, period, opt)
% GEN_SIG_FHANDLE specialized fcn of gen_signal for fhandles
%
% Generates SIGNAL struct for function handle input.
%
% SIGNAL = GEN_SIG_FHANDLE(FCN, PERIOD, OPT) where FCN is a function
% handle, PERIOD the period of the function and OPT the options struct
% obtained from HYBRIDSET.
%
% See also GEN_SIGNAL.

signal.type = 'fhandle';
signal.fcn = fcn;
signal.period = period;

% search maximum amplitude with fminbnd
% TODO test if fminbnd is a good choice and produces valid results
[~, minamp, foundmin] = fminbnd(fcn, 0, period, opt.optimset);
[~, maxamp, foundmax] = fminbnd(@(x) -fcn(x), 0, period, opt.optimset);
if ~foundmin || ~foundmax
    error('HYBRID:sig:fminbnderr', ...
          'Unable to find amplitude of fcn via fminbnd')
end
signal.amplitude = -min([minamp, maxamp]);

% integrate signal to get energy within signal
% TODO test if interpolation is neccessary to find maximum
odesol = opt.continuous_solver;
[~, yout] = odesol(@(tt, xx) fcn(tt), [0 period], 0, opt.odeset);
signal.maxint = max(yout);

signal.rms = root_mean_square(signal, opt);
signal.arv = average_rectified_value(signal, opt);
signal.form = signal.rms/signal.arv;
signal.crest = signal.amplitude/signal.rms;

end


%% LOCAL FUNCTIONS

% TODO put identical function bodies into one function
% TODO use 'integral' instead of 'ode'?
function rms = root_mean_square(signal, opt)
    % RMS implementation for continuous functions/function handles
    squared_fcn = @(t) signal.fcn(t).^2;
    odesol = opt.continuous_solver;
    [~, y] = odesol(@(t, y) squared_fcn(t), ...
                    [0 signal.period], ...
                    0, ...
                    opt.odeset);
    solved_integral = y(end) - y(1);
    rms = sqrt(solved_integral/signal.period);
end


function arv = average_rectified_value(signal, opt)
    % ARV implementation for continuous functions/function handles
    rect_fcn = @(t) abs(signal.fcn(t));
    odesol = opt.continuous_solver;
    [~, y] = odesol(@(t, y) rect_fcn(t), ...
                   [0 signal.period], ...
                   0, ...
                   opt.odeset);
    solved_integral = y(end) - y(1);
    arv = solved_integral/signal.period;
end
