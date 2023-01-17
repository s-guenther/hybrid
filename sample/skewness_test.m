function skewness_test()
% SKEWNESS_TEST Create some test hybrid curves to test plausibility and
% range of values of hybrid skewness factor

%% Test Symmetry
 
sym = @(cut) interp1([0, 0.001, 1], [0, 0.999, 1], cut);
halfleft = @(cut) interp1([0, 0.5, 1], [0, 0.999, 1], cut);
halfright = @(cut) interp1([0, 0.001, 1], [0, 0.5, 1], cut);

% make hybridstruct mockups
hsym.baseenergy = sym;
hhalfleft.baseenergy = halfleft;
hhalfright.baseenergy = halfright;

c = 0:0.0001:1;
s = sym(c);
l = halfleft(c);
r = halfright(c);
plot(s,c, l,c, r,c, 'LineWidth', 2)
legend('sym', 'halfleft', 'halfright')

Ss = hybrid_skewness(hsym);
Sl = hybrid_skewness(hhalfleft);
Sr = hybrid_skewness(hhalfright);

fprintf('Sym: %.16f\n', Ss)
fprintf('Halfleft: %.16f\n', Sl)
fprintf('Halfright: %.16f\n', Sr)

%% Create progression for multiple triangle curves to determine boundaries

progression = [0.25, 0.5, 0.75, 0.9, 0.99, 0.999];
res = [];

fprintf('\n')

for p=progression
    curve = @(cut) interp1([0, p, 1], [0, 1, 1], cut);
    hstruct.baseenergy = curve;
    sp = hybrid_skewness(hstruct);
    fprintf('Skew(p = %.16f) = %.16f\n', p, sp)
    res(end+1) = sp;  %#ok
end

loglog(1-progression, res)

fprintf('\n')

%% test half hybdia for same value
orig.baseenergy = @(cut) interp1([0, 0.5, 1], [0, 1-eps, 1], cut);
half.baseenergy = @(cut) interp1([0, 0.625, 1], [0, 0.875, 1], cut);
fprintf('Skew(orig) = %.16f\n', hybrid_skewness(orig))
fprintf('Skew(half) = %.16f\n', hybrid_skewness(half))

end
