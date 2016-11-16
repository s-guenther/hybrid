function rev_fcn_handle = reverse(input_fcn_handle, offset)
% REVERSE an input function with a coordinate transformation at offset - t
%
% Reverses a signal. The new coordnate system starts at point in time
% 'offset' and points in opposite direction.
%
% Input:
%   input_fcn_handle    fcn handle of time, one dimensional, respectively
%   offset              point where the new coordinate system starts,
%                       optional, default 0
%
% Output:
%   rev_fcn_handle      Reversed Function Handle

if nargin < 2
    offset = 0
end

    rev_fcn_handle = @(t) input_fcn_handle(offset - t);

end
