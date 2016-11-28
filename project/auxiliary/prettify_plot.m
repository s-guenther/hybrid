function prettify_plot(signal, sim_results, vals, valnames)
% PRETTIFY_PLOT adds additional information to a testcase plot
%
% Input:
%   signal          signal struct
%   sim_results     struct from main.m
%       .parameter       [form crest rms arv]
%       .hybrid_table    [cut_off, e_base, e_peak, p_base, p_peak; ...]
%       .single          struct: .energy, .power
%       .transformed     [cut_off, x_base, x_peak, y_base, y_peak; ...]
%       .peak            [x,y] of transformed 
%   vals                 (x,y) vectors which will be displayed in textbox
%   valnames             names for (x,y) vals
%
% Output:           None

annotation('textbox', [0.2, 0.5, 0.1, 0.1], ...
           'String', valnames, ...
           'FitBoxToText', 'on')
annotation('textbox', [0.2, 0.45, 0.1, 0.1], ...
           'String', num2str(flipud(vals)), ...
           'FitBoxToText', 'on')

varnames = ['Form    '; 'Crest   '; 'RMS     '; 'ARV     '; 'AMV     '];
varvalsstr = num2str(sim_results.parameter');
annotation('textbox', [0.2, 0.7, 0.1, 0.1], ...
           'String', varnames, ...
           'FitBoxToText', 'on')
annotation('textbox', [0.26, 0.7, 0.1, 0.1], ...
           'String', varvalsstr, ...
           'FitBoxToText', 'on')

annotation('textbox', [0.2, 0.75, 0.1, 0.1], ...
           'String', func2str(signal.fcn), ...
           'FitBoxToText', 'on')

axis tight

% subplot of input fcn
ax_t_signal = axes('Position', [.6 .2 .25 .2], 'Visible', 'off');
t = linspace(0, signal.period, 2e2);
plot(t, signal.fcn(t), t, zeros(size(t)), 'k')
xlabel('Time')
ylabel('Amplitude')

hold off, axis tight

end
