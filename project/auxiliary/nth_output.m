function value = nth_output(N, fcn, varargin)
% NTH_OUTPUT Returns of the nth output of a fcn w/ multiple output args
%
% Returns from function fcn with the input variables varargin the nth output
% variable N
%
% Example:
%   col = nth_output(2, @size, 0)
%
% From:
% http://stackoverflow.com/questions/3710466/how-do-i-get-the-second-return-value-from-a-function-without-using-temporary-var
  [value{1:N}] = fcn(varargin{:});
  value = value{N};
end
