function skew = hybrid_skewness(hybstruct)
% HYBRID_SKEWNESS determines the skewness of a given hybrid curve
%
% SKEW =  HYBRID_SKEWNESS(HYBSTRUCT) calculates the skewness of the
% hybridisation curve which encodes if the shape of the hybridisation curve is
% lopsided towards base or peak storage. HYBSTRUCT is a substrucure from
% the output of HYBRID. The function makes use of the field
% HYBSTRUCT.hybrid
%
% The SKEWNESS value goes from TODO to TODO
% Negative values indicate a bulk towards TODO which means that the shape
% of the hybridisation curve favors TODO
% and positive values indicate a bulk towards TODO which means that the
% shape of the hybridisation curve favors TODO
%
% See also HYBRID


%% Read and Raster Hybrid Curve

% Normalized Hybrid curve
hybcurve = @(cut) hybstruct.baseenergy(cut)/hybstruct.baseenergy(1);

% make chi/mu value pairs

chi = linspace(0, 1, 1e5); % FIXME magic number
mu = hybcurve(chi);


%% Coordinate transformation and new function handle

% Coordinate transformation from base coordinate system to skew coordinate
% system
x = 1/sqrt(2)*(-chi - mu + 1);
y = 1/sqrt(2)*(-chi + mu);
x = flip(x);
y = flip(y);

% make new function handle for curve in skew coordinate system
skewcurve = @(xx) interp1(x, y, xx);
% normalize skewcurve
skewarea = integral(skewcurve, x(1), x(end));
skewcurve = @(xx) skewcurve(xx)/skewarea;


%% Calculate skewness

% Define moments equation
mfun_mu_n = @(x, mu, n) (x - mu).^n.*skewcurve(x);
% Calculate moments
m1 = integral(@(x) mfun_mu_n(x, 0, 1), x(1), x(end));
m2 = integral(@(x) mfun_mu_n(x, m1, 2), x(1), x(end));
m3 = integral(@(x) mfun_mu_n(x, m1, 3), x(1), x(end));
%skewness
skew = m3/(m2^(3/2));
% Scale skewness by maximum possible value for Hybrid curves
skew = skew/(2*sqrt(2)/5);


end
