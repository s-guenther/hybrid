function [build, decay] = gen_build_decay(signal, cut, varargin)
% GEN_BUILD_DECAY for sdode from signal for specific cut
%
% Separates the signal at a specified cut into a build function and decay
% function with the help of a Saturation or Residual Saturation function,
% respectively.
%
% The output type varies corresponding to the signal type.
%
% [BUILD, DECAY] = GEN_BUILD_DECAY(SIGNAL, CUT, <OPT>)
% [BUILD, DECAY] = GEN_BUILD_DECAY(SIGNAL, CUT, <STRATEGY>)
% [BUILD, DECAY] = GEN_BUILD_DECAY(SIGNAL, CUT, <STRATEGY>, <OPT>)
%
% STRAGEGY can be 'inter' or 'nointer', dependent on whether inter-storage
% power flow is allowed or forbidden. Default is 'inter'. OPT is an option
% structure by HYBRIDSET().
%
% If SIGNAL.type == 'fhandle', BUILD and DECAY are structs with the fields
%   .fcn        function handle
%   .type       = 'fhandle'
%
% If SIGNAL.type == ('step' or 'inter')
%   .time       time vector
%   .val        associated signal vector
%   .type       = 'step' or 'inter'
%
% See also HYBRID_PAIR.

[strategy, opt] = parse_hybrid_pair_input(varargin);

switch lower(signal.type)
    case 'fhandle'
        [build, decay] = ...
            gen_fhandle_build_decay(signal, cut, strategy, opt);
    case {'step', 'linear'}
        [build, decay] = ...
            gen_discrete_build_decay(signal, cut, strategy, opt);
    otherwise
        error('HYBRID:hybrid_pair:invalid_signal', ...
              ['Unknown signal type ''' signal.type ''', must be ', ...
               '''fhandle'', ''step'' or ''linear''.'])
end

end
