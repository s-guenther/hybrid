function [build, decay] = gen_discrete_build_decay(signal, cut, ...
                                                   strategy, opt) %#ok
% GEN_DISCRETE_BUILD_DECAY specialized generator for linear as signal type
%
% [BUILD, DECAY] = GEN_DISCRETE_BUILD_DECAY(SIGNAL, CUT, STRATEGY, OPT)
%
% See also GEN_BUILD_DECAY.

% For linear functions, exploit add_zero_crossing function of gen_signal to
% add crossing points at cut to produce a correct res_sat series
if strcmpi(signal.type, 'linear')
    [signal.time, signal.val] = add_cut_crossings(signal.time, ...
                                                  signal.val, ...
                                                  cut*signal.amplitude);
end

build.type = signal.type;
build.time = signal.time;
decay.type = signal.type;
decay.time = signal.time;

request = -(1 - cut)*signal.amplitude;
if strcmpi(strategy, 'inter')
    request_limit = signal.val - cut*signal.amplitude;
elseif strcmpi(strategy, 'nointer')
    request_limit = signal.val;
end

build.val = res_sat(signal.val, cut*signal.amplitude);
decay.val = max(request, request_limit);

end
