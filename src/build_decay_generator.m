function [build, decay] = build_decay_generator(signal, ...
                                                cut_plus, cut_minus)
% BUILD_DECAY_GENERATOR generates input functions for switched_decay_ode
%
% Generates from an input Signal (for a storage system) the build_fcn and
% decay_fcn which will be passed to switched_decay_ode.
%
% Input:
%   input_fcn   signal object, see issignalstruct()
%   cut_plus    optional, default 0.5
% DEFERRED
%   cut_minus   optional, default 0.5
%
% Output:
%   build       function handle for the build up function
%   decay       function handle for the decay function
%
% DEFERRED: No distiction between cut_plus and cut_minus atm.

if nargin < 2
    cut_plus = 0.5;
end
if nargin < 3
    cut_minus = -cut_plus;
end

tanh_grad = 100;

build = @(t) residual_saturate(signal.fcn(t), ...
                               cut_plus*signal.amplitude, ...
                               cut_minus*signal.amplitude);

request = -(1 - cut_plus)*signal.amplitude;
request_limit = @(t) (signal.fcn(t) - cut_plus*signal.amplitude);
decay = @(t) max(request, request_limit(t));

end
