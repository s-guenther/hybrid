function [storages, ecodata, signal, opt] = ...
                                        parse_plot_hybrid_input(varargin)
% Looks at the varargin inputs of plot_hybrid and returns the right signal
% and opt struct

if nargin == 0
    storages = false;
    ecodata = false;
    signal = false;
    opt = hybridset();
end

if nargin == 1
    if ishybridset(varargin{1})
        storages = false;
        ecodata = false;
        signal = false;
        opt = varargin{1};
    elseif isvalidsignal(varargin{1})
        storages = false;
        ecodata = false;
        signal = varargin{1};
        opt = hybridset();
    elseif isvalidstorages(varargin{1})
        storages = varargin{1};
        ecodata = false;
        signal = false;
        opt = hybridset();
    elseif isvalideco(varargin{1})
        ecodata = varargin{1};
        storages = reconstruct_storages(ecodata);
        signal = false;
        opt = hybridset();
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              'Input does not match any allowed argument.')
    end
end

if nargin == 2
    if isvalidstorage(varargin{1})
        storages = varargin{1};
        ecodata = false;
    elseif isvalideco(varargin{1})
        ecodata = varargin{1};
        storages = reconstruct_storages(varargin{1});
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              '2nd argument must be a storage or eco struct.')
    end
    if isvalidsignal(varargin{2})
        signal = varargin{2};
        opt = hybridset();
    elseif ishybridset(varargin{2})
        signal = false;
        opt = varargin{2};
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              '3rd argument must be a signal or options struct.')
    end
end

if nargin == 3
    if isvalidstorage(varargin{1})
        storages = varargin{1};
        ecodata = false;
    elseif isvalideco(varargin{1})
        ecodata = varargin{1};
        storages = reconstruct_storages(varargin{1});
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              '2nd argument must be a storage or eco struct.')
    end
    if isvalidsignal(varargin{2})
        signal = varargin{2};
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              '3rd argument must be a signal struct.')
    end
    if ishybridset(varargin{3})
        opt = varargin{3};
    else
        error('HYBRID:plot_hybrid:invalid_input', ...
              '4th argument must be an options struct.')
    end
end

if nargin > 3
    error('HYBRID:plot_hybrid:invalid_input', ...
          'Too many input arguments')
end

end
