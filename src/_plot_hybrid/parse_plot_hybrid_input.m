function [signal, opt] = parse_plot_hybrid_input(varargin)
% Looks at the varargin inputs of plot_hybrid and returns the right signal
% and opt struct

if nargin == 0
    signal = false;
    opt = hybridset();
elseif nargin == 1
    if ishybridset(varargin{1})
        signal = false;
        opt = varargin{1};
    elseif isvalidsignal(varargin{1})
        signal = varargin{1};
        opt = hybridset();
    else
        error('HYBRID:plot_signal:invalid_input', ...
              'Input does not match signal struct or options struct.')
    end
elseif nargin == 2
    if isvalidsignal(varargin{1}) &&ishybridset(varargin{2}) 
        signal = varargin{1};
        opt = varargin{2};
    else
        error('HYBRID:plot_signal:invalid_input', ...
              'Input does not match signal struct or options struct.')
    end
else
    error('HYBRID:plot_signal:invalid_input', ...
          'Too many input arguments')
end

end
