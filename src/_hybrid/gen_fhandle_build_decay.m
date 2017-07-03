function [build, decay] = gen_fhandle_build_decay(signal, cut, ...
                                                  strategy, opt)
% GEN_FHANDLE_BUILD_DECAY specialized generator for fhandle as signal type
%
% [BUILD, DECAY] = GEN_FHANDLE_BUILD_DECAY(SIGNAL, CUT, STRATEGY, OPT)
%
% See also GEN_BUILD_DECAY.

% TODO For solver speed up, sat and residual sat could be build with a
% tanh_function to resolve discrete steps in functions and to speed up ode
% integration (similar behaviour to an audio compressor/expander)
% alternatively, a convolution is also conceivable

if ~opt.tanh
    warning('HYBRID:build_decay:no_tanh', ...
            ['Approximation of signal with tanh function not ' ...
             'implemented at the moment.\nIgnoring option OPT.TANH.'])
end

request = -(1 - cut)*signal.amplitude;
if strcmpi(strategy, 'inter')
    request_limit = @(t) (signal.fcn(t) - cut*signal.amplitude);
elseif strcmpi(strategy, 'nointer')
    request_limit = @(t) signal.fcn(t);
end

build.fcn = @(t) res_sat(signal.fcn(t), cut*signal.amplitude);
decay.fcn = @(t) max(request, request_limit(t));

end
