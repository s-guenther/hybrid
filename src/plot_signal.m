function hfig = plot_signal(signal, opt, ax)
% PLOT_SIGNAL plots a storage signal struct
%
% HFIG = PLOT_SIGNAL(SIGNAL, <OPT>) Plots the signal provided as
% a SIGNAL struct through GEN_SIGNAL using the options OPT. OPT is an
% option structure provided through HYBRIDSET. HFIG is the handle to the
% figure the result is plotted in.
%
% See also GEN_SIGNAL, HYBRIDSET.

% TODO make pretty and complete

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
        plot(ax, tt, signal.fcn(tt))
    case 'step'
        stairs(ax, [0; signal.time], [signal.val; signal.val(end)]);
    case 'linear'
        plot(ax, signal.time, signal.val)
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

axis tight
title('Time series of Signal')
xlabel('Time t')
ylabel('Power p')

end
