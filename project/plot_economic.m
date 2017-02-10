function plot_economic(base, peak, hybrid, noreload, reload, ssingle)
     
power_single = base(1).cut_p_in_base(1);
energy_single = fsolve(@(x)ssingle(x) - power_single, ...
                       0.5, optimset('Display','off'));
%
%% Plot hybridisation curve


figure(), hold on, grid on, axis([0, energy_single, 0, power_single]),
evec = linspace(0, energy_single);

% single and hybridisation curve
plot(evec, ssingle(evec), ':', 'Color', [0, 0, 0])
plot(evec, noreload(evec), '--', 'Color', [0, 0, 0])
plot(evec, reload(evec),  'Color', [0, 0, 0])

% plot base storages
basecolors = winter(length(base));
for ii = 1:length(base)
    plot(evec, base(ii).e_p_in_base(evec), 'Color', basecolors(ii,:))
end
 
% plot peak storages
peakcolors = autumn(length(peak));
for ii = 1:length(base)
    plot(evec, peak(ii).e_p_in_base(evec), 'Color', peakcolors(ii,:))
end

end
