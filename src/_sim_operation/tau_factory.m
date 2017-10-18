function tau = tau_factory(storage)
% TAU_FACTORY builds parameterized time-until-full function
%
% The control strategy must be parameterized with a few constants, i.e.
% storage dimensions, and the backward integral. To reduce the number of
% inputs and to avoid overloading functions, this function generates and
% returns the concrete control strategy function.
%
% This function determines the time which would be needed to completely
% charge or discharge the storage assuming maximum power, respecting the
% current state of charge.
%
% TAU = TAU_FACTORY(STORAGE), where STORAGE is a structure with .power and
% .energy as elements. TAU is a function of the form
%   tau = @(storage_enrgy, bw_int) ...
%
% See also CONTROL_FACTORY, SIM_OPERATION.

tau = @(enrgy, enrgy_peak, bw_int) ...
      ((storage.energy - enrgy)/storage.power).*(enrgy_peak > bw_int) + ...
      (enrgy/storage.power).*(enrgy_peak <= bw_int);
% tau = @(enrgy, bw_int) ...
%       ((storage.energy - enrgy)/storage.power);

end
