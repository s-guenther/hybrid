function [prices, names, opt] = parse_gen_storages_input(spec_powers, ...
                                                         varargin)
% Checks input data of gen_storages if types/classes are correct and
% consistent

if nargin == 1
    opt = hybridset();
    prices = make_prices(spec_powers);
    names = make_names(spec_powers);
end

if nargin == 2
    if ishybridset(varargin{1})
        opt = varargin{1};
        prices = make_prices(spec_powers);
        names = make_names(spec_powers);
    elseif isnumeric(varargin{1}) && isvector(varargin{1})
        opt = hybridset();
        prices = varargin{1};
        names = make_names(spec_powers);
    elseif iscell(varargin{1})
        opt = hybridset();
        prices = make_prices(spec_powers);
        names = varargin{1};
    else
        error('HYBRID:stor:invalid_input', ...
              'Invalid 2nd input')
    end
end

if nargin == 3
    if isnumeric(varargin{1}) && isvector(varargin{1})
        prices = varargin{1};
        if ishybridset(varargin{2})
            opt = varargin{2};
            names = make_names(spec_powers);
        elseif iscell(varargin{2})
            opt = hybridset();
            names = varargin{2};
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 3rd input')
        end
    else
        error('HYBRID:stor:invalid_input', ...
              'Invalid 2nd input')
    end
end

if nargin == 4
    if isnumeric(varargin{1}) && isvector(varargin{1})
        prices = varargin{1};
        if iscell(varargin{2})
            names = varargin{2};
            if ishybridset(varargin{3})
                opt = varargin{3};
            else
                error('HYBRID:stor:invalid_input', ...
                      'Invalid 4th input')
            end
        else
            error('HYBRID:stor:invalid_input', ...
                  'Invalid 3rd input')
        end
    else
        error('HYBRID:stor:invalid_input', ...
              'Invalid 2nd input')
    end
end

if nargin > 4
    error('HYBRID:stor:invalid_input', ...
          'Too many input arguments')
end

assert(length(prices) == length(spec_powers), ...
       'number of spec_powers and prices differ')
assert(length(names) == length(spec_powers), ...
       'number of spec_powers and names differ')

end


%% LOCAL FUNCTIONS

function prices = make_prices(spec_powers)
    prices = 1 + spec_powers;
end

function names = make_names(spec_powers)
    names = cellfun(@num2str, num2cell(spec_powers), ...
                    'UniformOutput', false);
end
