function [strategy, opt] = parse_hybrid_pair_input(varargin)
% PARSE_HYBRID_PAIR_INPUT provides standardized input data for hybrid_pair
%
% Checks input of hybrid_pair and returns default parameters if needed
%
% [STRATEGY, OPT] = PARSE_HYBRID_PAIR_INPUT(VARARGIN)
%
% See also HYBRID_PAIR

if nargin == 0
    strategy = 'inter';
    opt = hybridset();
end

if nargin == 1
    if ishybridset(varargin{1})
        strategy = 'inter';
        opt = varargin{1};
    elseif any(strcmpi(varargin{1}, {'inter', 'nointer'}))
        strategy = varargin{1};
        opt = hybridset();
    else
        error('HYBRID:hybrid_pair:invalid_input', ...
              ['Third argument does not match a strategy string ', ...
               '''inter'' or ''nointer'' or hybridset OPT structure.'])
    end
end

if nargin == 2
    validatestring(varargin{1}, {'inter', 'nointer'}, 3);
    if ~ishybridset(varargin{2})
        error('HYBRID:hybrid_pair:invalid_input', ...
              '4th Argument is not a hybridset OPT struct.')
    end
    strategy = varargin{1};
    opt = varargin{2};
end

if nargin > 2
    error('HYBRID:hybrid_pair:invalid_input', ...
          ['Too many input arguments, maximum is 4, found ', ...
           num2str(2+nargin)], '.')
end

end
