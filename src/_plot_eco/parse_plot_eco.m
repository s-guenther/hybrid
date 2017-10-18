function [dtype, opt] = parse_plot_eco(varargin)
% Parses plot_eco input data

% NOTE: option for setting dtype not activiated for the moment

if nargin == 0
    dtype = 'cost';
    opt = hybridset();
end

if nargin == 1
    if ishybridset(varargin{1})
        dtype = 'cost';
        opt = hybridset(varargin{1});
    else
        error('HYBRID:plot_eco:invalid_input', ...
              '2nd argument must be an options struct.')
    end
end

% if nargin == 1
%     if isvaliddtype(varargin{1})
%         dtype = varargin{1};
%         opt = hybridset();
%     elseif ishybridset(varargin{1})
%         dtype = 'cost';
%         opt = varargin{1};
%     else
%         error('HYBRID:plot_eco:invalid_input', ...
%               '2nd argument must be a dtype or an options struct.')
%     end
% end
% 
% if nargin == 2
%     if isvaliddtype(varargin{1})
%         dtype = varargin{1};
%         if ishybridset(varargin{2})
%             opt = hybridset();
%         else
%             error('HYBRID:plot_eco:invalid_input', ...
%                   '3rd argument must be an options struct.')
%         end
%     else
%         error('HYBRID:plot_eco:invalid_input', ...
%               '2nd argument must be a valid dtype.')
%     end
% end

if nargin > 1
        error('HYBRID:plot_eco:invalid_input', ...
              'Too many input arguments.')
end

end
