function [form, crest, rms, arv, amv] = signal_parameters(signal)
% SIGNAL_PARAMETERS calculates the most common signal characteristics
%
% Calculates Form Factor, Crest Factor, Root Mean Square, Average Rectified
% Value, Average Mean Value
%
% Input:
%   signal      struct, see issignalstruct
% Output:
%   form
%   crest
%   rms
%   arv
%   amv

rms = root_mean_square(signal);
arv = average_rectified_value(signal);
crest = signal.amplitude/rms;
form = rms/arv;
amv = average_mean_value(signal);

end


%% LOCAL FUNCTIONS

function rms = root_mean_square(signal)
    squared_fcn = @(t) signal.fcn(t).^2;
    [~, y] = ode45(@(t, y) squared_fcn(t), [0 signal.period], 0, ...
                   odeset('MaxStep', signal.period/1e2));
    solved_integral = y(end) - y(1);
    rms = sqrt(solved_integral/signal.period);
end


function arv = average_rectified_value(signal)
    rect_fcn = @(t) abs(signal.fcn(t));
    [~, y] = ode45(@(t, y) rect_fcn(t), [0 signal.period], 0, ...
                   odeset('MaxStep', signal.period/1e2));
    solved_integral = y(end) - y(1);
    arv = solved_integral/signal.period;
end


function amv = average_mean_value(signal)
    [~, y] = ode45(@(t, y) signal.fcn(t), [0 signal.period], 0, ...
                   odeset('MaxStep', signal.period/1e2));
    solved_integral = y(end) - y(1);
    amv = solved_integral/signal.period;
end
