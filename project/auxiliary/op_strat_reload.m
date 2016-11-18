function [p_base, p_peak, p_diff] = op_strat_reload(t, p_in, ...
                                                    e_base, e_peak, ...
                                                    soc_fcn, ...
                                                    storage_info, ...
                                                    signal_info, ...
                                                    tanh_grad)
% OP_STRAT_RELOAD time dependend operational strat for dimensioning
%
% Is a generic operational strategy considering reloading or inter storage
% power flow, respectively. It does consider available storage information
% as well as signal information but is static otherwise and not subject to
% optimization. Does not show dynamic behaviour considering history or
% predictions.
%
% Input:
%   t               Simulation time
%   p_in            power input (to both storages/storage system)
%   e_base          current energy of base storage
%   e_peak          current energy of peak storage
%   soc_fcn         fcn handle specifying the aimed soc as fcn of time
%   storage_info    struct, dimensions of storage
%                   .e_base, .e_peak, .p_base, .p_peak
%   signal_info     struct, information structure (see issignalstruct)
%                   .period, .amplitude
%   tanh_grad       optional, default = 50, gradient of the tanh function
%                   smoothing the peak power reduction. To prevent numerical
%                   oscilliation. The lower the value, the smoother the
%                   function.
%
% Output:
%   p_base          power of base storage
%   p_peak          power of peak storage
%   p_diff          differential power, which cannot be handled by storage
%                   system
%   
% Current implementation: Simply needs the period of the signal and expects
% it to be point symmetric. Storage info contains ideal two-storage
% parameter. Structs can be extended for more sophisticated strategies,
% later.

if nargin < 8
    tanh_grad = 100;
end


e_base_max = storage_info.e_base;
e_peak_max = storage_info.e_peak;
p_base_max = storage_info.p_base;
p_peak_max = storage_info.p_peak;

T = signal_info.period;

soc_peak = e_peak./e_peak_max;
soc_aim = soc_fcn(e_peak, t);

tau_peak = time_to_aim(e_peak, e_peak_max, p_peak_max, soc_aim);
tau_base = time_to_aim(e_base, e_base_max, p_base_max, soc_aim);

powers = repmat((tau_peak < tau_base), 1, 3).*standard_operation() +  ...
         repmat((tau_peak >= tau_base), 1, 3).*synchronized_operation();
% powers = 1*standard_operation() +  ...
%          0.*synchronized_operation();

p_base = powers(:,1);
p_peak = powers(:,2);
p_diff = powers(:,3);


    % NESTED FCNS
    function powers = standard_operation()
        peak_request = p_peak_max.*tanh(tanh_grad*(soc_peak - soc_aim));

        base_virtual = -(p_in + peak_request);
        base = (base_virtual > 0 & e_base > 0).* ...
                        min(base_virtual, p_base_max) + ...
               (base_virtual < 0 & e_base < e_base_max).* ...
                        max(base_virtual, -p_base_max);

        peak_virtual = - p_in - base;
        peak = (peak_virtual > 0 & e_peak > 0).* ...
                        min(peak_virtual, p_peak_max) + ...
               (peak_virtual < 0 & e_peak < e_peak_max).* ...
                        max(peak_virtual, -p_peak_max);

        diffp = - p_in - base - peak;

        powers = [base, peak, diffp];
    end

    function powers = synchronized_operation()
        cut = p_base_max/(p_base_max + p_peak_max);

        % Double assign peak in case base energy is already at min/max
        peak = -(1 - cut)*p_in.*(e_peak < e_peak_max & e_peak > 0);
        base = (- p_in - peak).*(e_base < e_base_max & e_base > 0);
        peak = (- p_in - base).*(e_peak < e_peak_max & e_peak > 0);

        diffp = - p_in - base - peak;

        powers = [base, peak, diffp];
    end

end%mainfcn


% LOCAL FCNS

function tau = time_to_aim(e, e_max, p_max, soc_aim)
    % Calculates the time needed by the storage until it reaches the a fully
    % charged state, respectively a fully discharged state, depending on the
    % aimed soc assuming maximum power
    tau = (e_max - e)./p_max.*(soc_aim < 0.5) + e./p_max.*(soc_aim >= 0.5);
end
