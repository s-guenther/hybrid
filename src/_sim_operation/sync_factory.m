function sync = sync_factory(cut)
% SYNC_FACTORY builds a parameterized synchronized strategy
%
% The control strategy must be parameterized with a few constants, i.e.
% storage dimensions, and the backward integral. To reduce the number of
% inputs and to avoid overloading functions, this function generates and
% returns the concrete control strategy function.
%
%  SYNC = SYNC_FACTORY(CUT)
%
% The returned function has the form
%   ([pwr_base, pwr_peak]) = sync(pwr_in)
% where the input parameters a usually explicit functions of time t (in
% case signal type == 'fhandle') or step i (in case signal type == 'linear'
% or 'step')
%
% See also: CONTROL_FACTORY, RELOAD_FACTORY, SIM_OPERATION.

sync = @(pwr) [cut; (1 - cut)].*pwr;

end
