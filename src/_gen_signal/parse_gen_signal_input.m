function [sigtype, opt, out1, out2] = parse_gen_signal_input(varargin)
% Checks input data of gen_signal if types/classes are correct and
% consistent

if nargin < 2
    error('HYBRID:sig:invalid_input', ...
          ['Function ''gen_signal'' takes at least 2 ', ...
           'arguments, %i provided.'], nargin) 
end

in1 = varargin{1};
in2 = varargin{2};

%% Check that input types are valied
if isa(in1, 'function_handle') && isnumeric(in2)
    % Check if correct function handle input
    if ~all(size(in2) == [1, 1])
        error('HYBRID:sig:invalid_input', ...
              'Second parameter period must be a scalar double.')
    end
    sigtype = 'fhandle';
elseif isnumeric(in1) && isnumeric(in2)
    % Check if correct time, val pair input
    in1 = in1(:); % make row vec if not already the case
    in2 = in2(:); % make row vec if not already the case
    if size(in1, 2) ~= 1 || size(in2, 2) ~=1
        error('HYBRID:sig:invalid_input', ...
              'Time and val inputs are not vectors')
    end
    if length(in1) ~= length(in2)
        error('HYBRID:sig:invalid_input', ...
              'Time and val vector do not have the same length')
    end
    if length(in1) == 1
        error('HYBRID:sig:invalid_input', ...
              'Input vectors must be larger than 1')
    end
    sigtype = 'discrete';
else
    error('HYBRID:sig:invalid_input', ...
          ['The classes of the first two input arguments do ', ...
           'not match the specification'])
end

%% If only two inputs, assign sigtype and opt accordingly
if nargin == 2
    opt = hybridset();
    if strcmpi(sigtype, 'discrete')
        sigtype = 'step';
    end
end

%% If 3 inputs, check type of 3rd input and assign opt and sigtype accrdgly
if nargin == 3
    if ishybridset(varargin{3}) && strcmpi(sigtype, 'fhandle')
        opt = varargin{3};
    elseif ishybridset(varargin{3}) && strcmpi(sigtype, 'discrete')
        sigtype = 'step';
        opt = varargin{3};
    elseif ischar(varargin{3})
        sigtype = varargin{3};
        opt = hybridset();
    else
        error('HYBRID:sig:invalid_input', ...
              ['The provided 3rd parameter must be a ', ...
               'string or a hybridsetstruct'])
    end
end

%% If 4 inputs, check types, then assign
if nargin == 4
    sigtype = varargin{3};
    opt = varargin{4};
    if ~ischar(sigtype)
        error('HYBRID:sig:invalid_input', ...
              '3rd parameter must be a string')
    end
    if ~ishybridset(opt)
        error('HYBRID:sig:invalid_input', ...
              '4th parameter must be a hybridset struct')
    end
end

%% If more than 4 inputs --> too many
if nargin > 4
    error('HYBRID:sig:invalid_input', ...
          'Too many input parameters, must be lower 5, found %i', nargin)
end


%% Assign missing outputs
out1 = in1;
out2 = in2;

end
