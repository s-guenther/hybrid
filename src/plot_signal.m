function hfig = plot_signal(signal, opt, ax)
% PLOT_SIGNAL plots a signal struct
%
%   HFIG = PLOT_SIGNAL(SIGNAL, <OPT>) Plots the signal provided as a SIGNAL
%   struct through GEN_SIGNAL using the options OPT. OPT is an option
%   structure provided through HYBRIDSET. HFIG is the handle to the figure
%   the result is plotted in.
%
% See also GEN_SIGNAL, HYBRIDSET.

if nargin < 2
    opt = hybridset();
end
if nargin < 3
    ax = 'none';
end

if strcmpi(ax, 'none')
    if ~opt.plot_sig
        hfig = figure(100);
    else
        hfig = figure(opt.plot_sig);
    end
    clf;
    ax = gca;
else
    hfig = gcf;
end
hold on

switch lower(signal.type)
    case 'fhandle'
        tt = linspace(0, signal.period, 1e3);
        ax = plotyy(ax, tt, signal.fcn(tt), tt, signal.int(tt));
    case 'step'
        tvals = [signal.time, signal.time]';
        tvals = [0; tvals(:)];
        xvals = [signal.val, signal.val]';
        xvals = [xvals(:); xvals(end)];
        ax = plotyy(ax, ...
                    tvals, xvals, ...
                    [0; signal.time], [0; signal.int]);
    case 'linear'
        ttime = linspace(0, signal.time(end), length(signal.time)*10);
        ttime = unique(sort([ttime'; signal.time]));
        vval = interp1(signal.time, signal.val, ttime);
        iint = cumtrapz(ttime, vval);
        ax = plotyy(ax, signal.time, signal.val, ttime, iint);
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

ax(1).XLim = [0, signal.period];
ax(2).XLim = [0, signal.period];
ax(1).YLim = max(ax(1).YLim)*[-1 1];
ax(2).YLim = max(ax(2).YLim)*[-1 1];
plot(ax(1), [0, signal.period], [0 0], 'k')
title('Time series of Signal')
xlabel('Time t')
ylabel(ax(1), 'Power p')
ylabel(ax(2), 'Energy e')
grid on

text(ax(1), 0.1*signal.period, 0.5*ax(1).YLim(1), ...
     {['RMS: ' num2str(signal.rms)]; ...
      ['ARV: ' num2str(signal.arv)]; ...
      ['Form: ' num2str(signal.form)]; ...
      ['Crest: ' num2str(signal.crest)]})

end
