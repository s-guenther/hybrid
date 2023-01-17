function [sigs, data] = test_simple_call()
% Creates some sample signals and calls hybrid_simple_call

x = 0:50:1000;
y = -rand(10, length(x));

nrow = size(y,1);
ncol = 1000;

xx = 1:ncol;
yy = zeros(nrow,  ncol);

for ii = 1:nrow
    yy(ii,:) = interp1(x, y(ii,:), xx);
end

sigs = yy;

data = zeros(nrow, 21);
for ii = 1:nrow
    data(ii,:) = hybrid_simple_call(yy(ii,:));
end

end
