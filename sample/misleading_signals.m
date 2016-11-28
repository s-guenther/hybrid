function misleading_signals()
% MISLEADING_SIGNALS script for creating deceptive sample functions

None = 'none';

x1 = [0 1 2 3 4 5 6 7 7.5];
y1 = [1 1 1 -2 1 1.5 0.5 1 1];

xcont = [7.5 8 9];
ycont = [1 1 1];

x2 = [0 1 2 3 4 4.5 6 7 7.5];
y2 = [2 2 -1.5 -1.5 -1.5 1.5 2 1 1];

x3 = [0 1 2 3 4 5 6 7 7.5];
y3 = [1 2 0 -2 2 1 1 1 1];

f1 = @(xx) interp1(x1, y1, xx, 'previous');
f2 = @(xx) interp1(x2, y2, xx, 'previous');
f3 = @(xx) interp1(x3, y3, xx, 'previous');
fcont = @(xx) interp1(xcont, ycont, xx, 'previous');

xx = linspace(0, 7.5, 1e3);
xxcont = linspace(7.5, 9, 1e1);

clf
hold on
plot([0 9], [0 0], 'k')
plot(xx, f1(xx), 'b')
plot(xxcont, fcont(xxcont), 'b:')
axis equal, grid on
ylim([-2.5 2.5])
xlim([0 9])

patch([0 3 3 0], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3)
patch([3 4 4 3], [-1 -1 0 0], [0 1 0], 'FaceAlpha', 0.3)
patch([3 4 4 3], [-1 -1 -2 -2], [1 0 0], 'FaceAlpha', 0.8)
patch([4 6 6 4], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', None)
patch([5 6 6 5], [1.5 1.5 1 1], [1 0 0], 'FaceAlpha', 0.3)
patch([6 7 7 6], [0 0 0.5 0.5], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', None)
patch([7 9 9 7], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', None)


pause

clf
hold on
plot([0 9], [0 0], 'k')
plot(xx, f2(xx), 'b')
plot(xxcont, fcont(xxcont), 'b:')
axis equal, grid on
ylim([-2.5 2.5])
xlim([0 9])

patch([0 2 2 0], [0 0 1.5 1.5], [0 1 0], 'FaceAlpha', 0.3)
patch([0 2 2 0], [2 2 1.5 1.5], [1 0 0], 'FaceAlpha', 0.3)
patch([2 4 4 2], -[0 0 1.5 1.5], [0 1 0], 'FaceAlpha', 0.3)
patch([4 4.5 4.5 4], [0 0 -0.5 -0.5], [1 0 0], 'FaceAlpha', 0.3)
patch([4 4.5 4.5 4], [-1.5 -1.5 -0.5 -0.5], [1 0 0], 'FaceAlpha', 0.8)
patch([4.5 7 7 4.5], [0 0 1.5 1.5], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', None)
patch([6 7 7 6], [2 2 1.5 1.5], [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor', None)
patch([7 9 9 7], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor', None)


pause

clf
hold on
plot([0 9], [0 0], 'k')
plot(xx, f3(xx), 'b')
plot(xxcont, fcont(xxcont), 'b:')
axis equal, grid on
ylim([-2.5 2.5])
xlim([0 9])

patch([0 3 3 0], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3)
patch([1 2 2 1], [2 2 1 1], [1 0 0], 'FaceAlpha', 0.3)
patch([2 3 3 2], [0 0 -1 -1], [1 0 0], 'FaceAlpha', 0.3)
patch([3 4 4 3], -[0 0 1 1], [0 1 0], 'FaceAlpha', 0.3)
patch([3 4 4 3], -[2 2 1 1], [1 0 0], 'FaceAlpha', 0.8)
patch([4 9 9 4], [0 0 1 1], [0 1 0], 'FaceAlpha', 0.3)
patch([4 5 5 4], [2 2 1 1], [1 0 0], 'FaceAlpha', 0.3)

end
