function control = control_factory(cut, strategy, base, peak, opt)
% CONTROL_FACTORY takes divers parameters and returns a control strategy
%
% The control strategy must be parameterized with a few constants, i.e.
% storage dimensions, and the backward integral. To reduce the number of
% inputs and to avoid overloading functions, this function generates and
% returns the concrete control strategy function.
%
% CONTROL = CONTROL_FACTORY(CUT, STRATEGY, BASE, PEAK), where
% BW_INT is a structure of type 'fhandle', 'step' or 'linear', CUT is the
% power cut [0..1], STRATEGY is 'inter' or 'nointer', depending an allowed
% or forbidden inter-storage power flow and BASE and PEAK are structures
% with the power and energy capacity.
% 
% Returns a function of the form
%   ([pwr_base, pwr_peak]) = control(pwr_in, bw_int, [enrgy_base, enrgy_peak])
%
% See also SIM_OPERATION.

if nargin < 5
    opt = hybridset();
end

reload = reload_factory(strategy, base, peak, opt);
sync = sync_factory(cut);
tau_peak = tau_factory(peak);
tau_base = tau_factory(base);

control = @(pwr, bw_int, enrgy) ...
          reload(pwr, bw_int, enrgy).* ...
                (tau_peak(enrgy(2), enrgy(2), bw_int) < ...
                 tau_base(enrgy(1), enrgy(2), bw_int)) + ...
          sync(pwr).* ...
                (tau_peak(enrgy(2), enrgy(2), bw_int) >= ...
                 tau_base(enrgy(1), enrgy(2), bw_int));

end
