function [hybdata, storages, strategy, opt] = parse_eco_input(varargin)
% Checks input data of eco and returns consistent data set

if nargin == 0
    error('HYBRID:eco:invalid_input', ...
          ['Function ''eco'' takes at least 1 ', ...
           'argument, %i provided.'], nargin) 
end

if nargin >= 1
    if isvalidhybrid(varargin{1})
        hybdata = varargin{1};
    else
        error('HYBRID:eco:invalid_input', ...
              '1st argument must be a hybrid structure ')
    end
end

spec_pwr = hybdata.hybrid.basepower(1)/hybdata.hybrid.baseenergy(1);

if nargin == 1
    opt = hybridset();
    strategy = 'inter';
    storages = gen_storages([1/3, 3]*spec_pwr);
end

if nargin == 2
    if ishybridset(varargin{2})
        opt = varargin{2};
        strategy = 'inter';
        storages = gen_storages([1/3, 3]*spec_pwr);
    elseif isvalidstrategy(varargin{2})
        strategy = varargin{2};
        storages = gen_storages([1/3, 3]*spec_pwr);
        opt = hybridset();
    elseif isvalidstorage(varargin{2})
        storages = varargin{2};
        strategy = 'inter';
        opt = hybridset();
    else 
        error('HYBRID:eco:invalid_input', ...
              ['2nd argument must be an options structure, strategy ', ...
               'or storage structure.'])
    end
end%nargin==2

if nargin == 3
    if isvalidstorage(varargin{2})
        storages = varargin{2};
        if isvalidstrategy(varargin{3})
            strategy = varargin{3};
            opt = hybridset();
        elseif ishybridset(varargin{3})
            strategy = 'inter';
            opt = varargin{3};
        else
            error('HYBRID:eco:invalid_input', ...
                  ['3rd argument must be a strategy ', ...
                   'or options structure.'])
        end
    elseif isvalidstrategy(varargin{2})
        strategy = varargin{2};
        if ishybridset(varargin{3})
            storages = gen_storages([1/3, 3]*spec_pwr);
            opt = varargin{3};
        else
            error('HYBRID:eco:invalid_input', ...
                  ['3rd argument must be an ', ...
                   'options structure.'])
        end
    else
        error('HYBRID:eco:invalid_input', ...
              ['2nd argument must be a strategy ', ...
               'or storage structure.'])
    end
end

if nargin >= 4
    if isvalidstorage(varargin{2})
        storages = varargin{2};
        if isvalidstrategy(varargin{3})
            strategy = varargin{3};
            if ishybridset(varargin{4})
                opt = varargin{4};
            else
                error('HYBRID:eco:invalid_input', ...
                      '4th argument must be an options structure.')
            end
        else
            error('HYBRID:eco:invalid_input', ...
                  '3rd argument must be a valid strategy.')
        end
    else
        error('HYBRID:eco:invalid_input', ...
              '2nd argument must be a storage structure.')
    end
end



end%fcn
