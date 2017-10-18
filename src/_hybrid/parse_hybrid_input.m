function [storages, opt] = parse_hybrid_input(varargin)
% PARSE_HYBRID_INPUT Parses input of hybrid function
%

if nargin == 0
    opt = hybridset();
    storages = false;
end

if nargin == 1
    if ishybridset(varargin{1})
        opt = varargin{1};
        storages = false;
    elseif isvalidstorage(varargin{1})
        storages = varargin{1};
        opt = hybridset();
    else
        error('HYBRID:hybrid:invalid_input', ...
              '2nd argument must be storage struct or options struct.')
    end
end

if nargin == 2
    if isvalidstorage(varargin{1})
        storages = varargin{1};
        if ishybridset(varargin{2})
            opt = hybridset(varargin{2});
        else
            error('HYBRID:hybrid:invalid_input', ...
                  '3rd argument must be an options struct.')
        end
    else
        error('HYBRID:hybrid:invalid_input', ...
              '2nd argument must be storage struct.')
    end
end

end
