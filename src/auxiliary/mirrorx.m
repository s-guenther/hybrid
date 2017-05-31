function rev_fcn_handle = mirrorx(input_fcn_handle, offset)
% MIRRORX a signal at a line parrallel to x-axis
%
% Mirrors a Signal at a line parallel to the x-axis
%
% Input:
%   input_fcn_handle    fcn handle of time, one dimensional, respectively
%   offset              parrallel line to x axis the Signal will bi
%                       mirrored at, optional, default 0
%
% Output:
%   rev_fcn_handle      Reversed Function Handle

if nargin < 2
    offset = 0;
end

    rev_fcn_handle = @(t) 2*offset - input_fcn_handle(t);

end
