function presentation()
%% PRESENTATION script which visualizes leaf theory

%% figure defaults
set(0,'DefaultAxesFontSize', 16) % axislabel 12
set(0,'DefaultTextFontSize', 16) % allfonts 12
set(0,'defaultlinelinewidth',2)  % linewidth 2
set(0,'defaulttextinterpreter','latex')


%% Set up Figure

figure(1000), clf, hold on, grid on

xlabel('Energy')
ylabel('Power')

axis equal
axis([0, 2.5, 0, 1.5])
ax = gca;

pause
ii = 1;

%% Plot isoline

isoline = @(x) interp1([1.3, 1.33, 1.4, 1.5, pi/2, 1.7, 1.9, 3, 6], ...
                       [5, 3, 2, 1.2, 1, 0.9, 0.8, 0.78, 0.77], ...
                       x, 'pchip');
xiso = linspace(1.45, 2.5, 1e3);
h00 = plot(ax, xiso, isoline(xiso), 'k');

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Plot single storage

h01 = plot(ax, pi/2, 1, 'bo', 'Linewidth', 2, 'MarkerSize', 12);
h02 = plot(ax, [0, pi/2, pi/2], [1, 1, 0], 'b');

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Plot isochrones

h03 = plot(ax, [0 pi], [0 2], 'k--', 'linewidth', 1.5);
h04 = plot(ax, 3*[0 0.5], 3*[0 0.5646], 'k', 'linewidth', 1.5);
h05 = plot(ax, 3*[0 1.0708], 3*[0 0.4354], 'k', 'linewidth', 1.5);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause



%% Plot points for RHR AB strategy

h06 = plot(ax, [0.5, pi/4, 1.0708], [0.3183, 0.5, 0.6817], ...
           'kx', 'Linewidth', 2);
h07 = plot(ax, 0.5, 0.5656, ...
           'o', 'color', [255 160 160]/255);
h08 = plot(ax, 1.6765, 0.6817, ...
           'o', 'color', [160 255 160]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


h09 = plot(ax, [0, 0.5, 0.5], [0.5656, 0.5656, 0], ...
           'Linewidth', 1.5, 'color', [255 200 200]/255);
h10 = plot(ax, [0, 1.676, 1.676], [0.6817, 0.6817, 0], ...
           'Linewidth', 1.5, 'color', [200 255 200]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

% Draw addition of both
rect_red = @(x) interp1([0, 0.5, 0.5+1e-6], [0.5656, 0.5656, 0], ...
                        x, 'linear');
rect_green = @(x) interp1([0, 1.676, 1.676+1e-6], [0.6817, 0.6817, 0], ...
                          x, 'linear');

xred = [linspace(0, 0.5-1e-6, 5e2), linspace(0.5, 0.5+1e-6, 5e2)];
[theta_red, rho_red] = cart2pol(xred, rect_red(xred));

xgreen = [linspace(0, 1.676-1e-6, 5e2), linspace(1.676, 1.676+1e-6, 5e2)];
[theta_green, rho_green] = cart2pol(xgreen, rect_green(xgreen));


pol_add = @(phi) interp1(theta_red, rho_red, phi, 'linear') + ...
                 interp1(theta_green, rho_green, phi, 'linear');
phiadd = linspace(0, pi/2, 1e3);
rhoadd = pol_add(phiadd);
[rectx, recty] = pol2cart(phiadd, rhoadd);

xadd = [linspace(0, 2.176-1e-6, 5e2), linspace(2.176, 2.176+2e-6, 5e2)];

h11 = plot(ax, rectx, recty, 'color', [252 202 255]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Now Add Signal to chart

arr = annotation('arrow');
arr.Parent = ax;
arr.X = [2, pi/2];
arr.Y = [1.35, 1];

% Generic Signal Definition
siggeneric.fcn = @(t) 0;
siggeneric.amplitude = 1;
siggeneric.period = 2*pi;
sig_dbl = siggeneric;
sig_dbl.fcn = @(t) interp1([0 1 2 3 4 5 6 7 8]*2*pi/8, ...
                           [0 1 0 1 0 -1 0 -1 0], ...
                           mod(t, 2*pi), 'linear');
% subplot of input fcn
ax_t_signal = axes('Position', [.67 .72 .2 .17], 'Visible', 'on');
t = linspace(0, 2*pi, 2e2);
h12 = plot(ax_t_signal, t, sig_dbl.fcn(t), t, zeros(size(t)), 'k');
xlabel('Time')
ylabel('Amplitude')
axis tight

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

% add base peak patches
p01 = patch(ax_t_signal, [0 2*pi 2*pi 0], [0.4355 0.4355 1 1], ...
            [1 0 0], 'FaceAlpha', 0.5);
p02 = patch(ax_t_signal, [0 2*pi 2*pi 0], [0.4355 0.4355 -0.4355 -0.4355], ...
            [0 1 0], 'FaceAlpha', 0.5);
p03 = patch(ax_t_signal, [0 2*pi 2*pi 0], [-0.4355 -0.4355 -1 -1], ...
            [1 0 0], 'FaceAlpha', 0.5);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Plot points for leaf strategy

h13 = plot(ax, 0.5, 0.5646, 'ro');
h14 = plot(ax, 1.0708, 0.4354, 'go');

h15 = plot(ax, [0, 0.5, 0.5], [0.5656, 0.5656, 0], ...
           'Linewidth', 1.5, 'color', [255 0 0]/255);
h16 = plot(ax, [0, 1.0708, 1.0708], [0.4354, 0.4354, 0], ...
           'Linewidth', 1.5, 'color', [0 255 0]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

% Draw addition of both
rect_red = @(x) interp1([0, 0.5, 0.5+1e-6], [0.5656, 0.5656, 0], ...
                        x, 'linear');
rect_green = @(x) interp1([0, 1.0708, 1.0708+1e-6], [0.4354, 0.4354, 0], ...
                          x, 'linear');

xred = [linspace(0, 0.5-1e-6, 5e2), linspace(0.5, 0.5+1e-6, 5e2)];
[theta_red, rho_red] = cart2pol(xred, rect_red(xred));

xgreen = [linspace(0, 1.0708-1e-6, 5e2), linspace(1.0708, 1.0708+1e-6, 5e2)];
[theta_green, rho_green] = cart2pol(xgreen, rect_green(xgreen));


pol_add = @(phi) interp1(theta_red, rho_red, phi, 'linear') + ...
                 interp1(theta_green, rho_green, phi, 'linear');
phiadd = linspace(0, pi/2, 1e3);
rhoadd = pol_add(phiadd);
[rectx, recty] = pol2cart(phiadd, rhoadd);

xadd = [linspace(0, pi/2-1e-6, 5e2), linspace(pi/2, pi/2+2e-6, 5e2)];

h17 = plot(ax, rectx, recty, 'color', [204 0 204]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

xpatch = linspace(0.8856, 1.567, 1e2);
p04 = patch(ax, [xpatch, 1.567], [interp1(rectx, recty, xpatch), 1], ...
      [204 0 204]/255, 'FaceAlpha', 0.2);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Delete lines which are not needed anymore

set(h04, 'visible', 'off')
set(h05, 'visible', 'off')
set(h06, 'visible', 'off')
set(h07, 'visible', 'off')
set(h08, 'visible', 'off')
set(h09, 'visible', 'off')
set(h10, 'visible', 'off')
set(h11, 'visible', 'off')
set(h17, 'visible', 'off')
set(p04, 'visible', 'off')

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Plot Other Ratio

% Plot points for dark leaf strategy

set(p01, 'ydata', [0.7 0.7 1 1], 'FaceColor', [0.5 0 0])
set(p02, 'ydata', [0.7 0.7 -0.7 -0.7], 'FaceColor', [0 0.5 0])
set(p03, 'ydata', [-0.7 -0.7 -1 -1], 'FaceColor', [0.5 0 0])

h18 = plot(ax, 0.141, 0.3, 'o', 'color', [130 0 0]/255);
h19 = plot(ax, 1.43, 0.7, 'o', 'color', [0 130 0]/255);

h20 = plot(ax, [0, 0.141, 0.141], [0.3 0.3 0], ...
           'Linewidth', 1.5, 'color', [130 0 0]/255);
h21 = plot(ax, [0, 1.43, 1.43], [0.7, 0.7, 0], ...
           'Linewidth', 1.5, 'color', [0 130 0]/255);
print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

% Plot points for bright leaf strategy

set(p01, 'ydata', [0.2 0.2 1 1], 'FaceColor', [1 0.7 0.7])
set(p02, 'ydata', [0.2 0.2 -0.2 -0.2], 'FaceColor', [0.7 1 0.7])
set(p03, 'ydata', [-0.2 -0.2 -1 -1], 'FaceColor', [1 0.7 0.7])

h22 = plot(ax, 1.005, 0.8, 'o', 'color', [255 130 130]/255);
h23 = plot(ax, 0.565, 0.2, 'o', 'color', [130 255 130]/255);

h24 = plot(ax, [0, 1.005, 1.005], [0.8 0.8 0], ...
           'Linewidth', 1.5, 'color', [255 130 130]/255);
h25 = plot(ax, [0, 0.565, 0.565], [0.2, 0.2, 0], ...
           'Linewidth', 1.5, 'color', [130 255 130]/255);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Plot Leaf

x_base = [...
                 0;
            0.0912;
            0.2582;
            0.5297;
            0.8645;
            1.1781;
            1.4003;
            1.5165;
            1.5592;
            1.5694;
            1.5708;
         ];

y_base = [...
                 0;
            0.0295;
            0.0859;
            0.1859;
            0.3295;
            0.5000;
            0.6705;
            0.8141;
            0.9141;
            0.9705;
            1.0000;
         ];

x_peak = [...
            1.5708;
            1.4796;
            1.3126;
            1.0411;
            0.7063;
            0.3927;
            0.1705;
            0.0543;
            0.0116;
            0.0014;
                 0;
         ];

y_peak = [...
            1.0000;
            0.9705;
            0.9141;
            0.8141;
            0.6705;
            0.5000;
            0.3295;
            0.1859;
            0.0859;
            0.0295;
                 0
         ];

base = @(x) interp1(x_base, y_base, x, 'pchip');
peak = @(x) interp1(x_peak, y_peak, x, 'pchip');

xleaf = linspace(0, pi/2, 1e3);

h26 = plot(ax, xleaf, base(xleaf), 'g--');
h27 = plot(ax, xleaf, peak(xleaf), 'r--');

set(p01, 'visible', 'off')
set(p02, 'visible', 'off')
set(p03, 'visible', 'off')

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Delete rectangular line, only leave points

set(h15, 'visible', 'off')
set(h16, 'visible', 'off')
set(h20, 'visible', 'off')
set(h21, 'visible', 'off')
set(h24, 'visible', 'off')
set(h25, 'visible', 'off')

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% Add connection lines

h28 = plot(ax, [0.565 1.005], [0.2 0.8], 'k', 'linewidth', 1);
h29 = plot(ax, [1.0708 0.5], [0.4354 0.5645], 'k', 'linewidth', 1);
h30 = plot(ax, [1.43 0.141], [0.7 0.3], 'k', 'linewidth', 1);

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% add patches again to show reloading

set(p01, 'visible', 'on')
set(p02, 'visible', 'on')
set(p03, 'visible', 'on')

set(h28, 'visible', 'off')
set(h29, 'visible', 'off')
set(h30, 'visible', 'off')

set(p01, 'ydata', [0.5 0.5 1 1], 'FaceColor', [1 0 0])
set(p02, 'ydata', [0.5 0.5 -0.5 -0.5], 'FaceColor', [0 1 0])
set(p03, 'ydata', [-0.5 -0.5 -1 -1], 'FaceColor', [1 0 0])


arr1 = annotation('arrow');
arr1.Parent = ax_t_signal;
arr1.HeadStyle = 'vback1';
arr1.X = [pi/4, pi/2];
arr1.Y = [0.75, 0.25];

arr2 = annotation('arrow');
arr2.Parent = ax_t_signal;
arr2.HeadStyle = 'vback1';
arr2.X = [pi*2/4, pi*3/4];
arr2.Y = [0.25, 0.75];

arr3 = annotation('arrow');
arr3.Parent = ax_t_signal;
arr3.HeadStyle = 'vback1';
arr3.X = [pi*3/4, pi*5/4];
arr3.Y = [0.75, -0.75];

arr4 = annotation('arrow');
arr4.Parent = ax_t_signal;
arr4.HeadStyle = 'vback1';
arr4.X = [pi*5/4, pi*6/4];
arr4.Y = [-0.75, -0.25];

arr5 = annotation('arrow');
arr5.Parent = ax_t_signal;
arr5.HeadStyle = 'vback1';
arr5.X = [pi*6/4, pi*7/4];
arr5.Y = [-0.25, -0.75];

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause


%% add reloading leaf

x_base = [...
            0.0000;
            0.0919;
            0.2640;
            0.5568;
            0.9498;
            1.3745;
            1.4855;
            1.5437;
            1.5650;
            1.5701;
            1.5708;
         ];

y_base = [...
                 0;
            0.0295;
            0.0859;
            0.1859;
            0.3295;
            0.5000;
            0.6705;
            0.8141;
            0.9141;
            0.9705;
            1.0000;
         ];

x_peak = [...
            1.5708;
            1.4789;
            1.3068;
            1.0140;
            0.6210;
            0.1963;
            0.0853;
            0.0271;
            0.0058;
            0.0007;
                 0;
         ];

y_peak = [...
            1.0000;
            0.9705;
            0.9141;
            0.8141;
            0.6705;
            0.5000;
            0.3295;
            0.1859;
            0.0859;
            0.0295;
                 0;
         ];

base = @(x) interp1(x_base, y_base, x, 'linear');
peak = @(x) interp1(x_peak, y_peak, x, 'linear');

xleaf = linspace(0, pi/2, 1e3);

h31 = plot(ax, xleaf, base(xleaf), 'g');
h32 = plot(ax, xleaf, peak(xleaf), 'r');

print(['draw_ragone_' sprintf('%02d', ii) '.png'], '-dpng')
ii = ii + 1;
pause

end
