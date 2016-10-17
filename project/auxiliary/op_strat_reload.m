function [p_base, p_peak, p_diff] = op_strat_reload(t, p_in, ...
                                                    e_base, e_peak, ...
                                                    storage_info, ...
                                                    signal_info)
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
%   storage_info    struct, dimensions of storage
%                   .e_base, .e_peak, .p_base, .p_peak
%   signal_info     struct, information structure (see issignalstruct)
%                   .period, .amplitude
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

e_base_max = storage_info.e_base;
e_peak_max = storage_info.e_peak;
p_base_max = storage_info.p_base;
p_peak_max = storage_info.p_peak;

T = signal_info.period;

soc_peak = e_peak./e_peak_max;
soc_aim = 0.*(mod(t, T) <= T/2) + 1.*(mod(t, T) > T/2);

tau_peak = time_to_aim(e_peak, e_peak_max, p_peak_max, soc_aim);
tau_base = time_to_aim(e_base, e_base_max, p_base_max, soc_aim);

powers = repmat((tau_peak < tau_base), 1, 3).*standard_operation() +  ...
         repmat((tau_peak >= tau_base), 1, 3).*synchronized_operation();

p_base = powers(:,1);
p_peak = powers(:,2);
p_diff = powers(:,3);


    % NESTED FCNS
    function powers = standard_operation()
        % p_peak_request = p_peak_max.*(soc_peak > soc_aim + 1e-4) + ...
        %                 -p_peak_max.*(soc_peak < soc_aim - 1e-4);
        p_peak_request = p_peak_max.*tanh(50*(soc_peak - soc_aim));

        p_base_virtual = -(p_in + p_peak_request);
        p_base_nes = (p_base_virtual > 0 & e_base > 0).* ...
                            min(p_base_virtual, p_base_max) + ...
                     (p_base_virtual < 0 & e_base < e_base_max).* ...
                            max(p_base_virtual, -p_base_max);

        p_peak_virtual = - p_in - p_base_nes;
        p_peak_nes = (p_peak_virtual > 0 & e_peak > 0).* ...
                            min(p_peak_virtual, p_peak_max) + ...
                     (p_peak_virtual < 0 & e_peak < e_peak_max).* ...
                            max(p_peak_virtual, -p_peak_max);

        p_diff_nes = - p_in - p_base_nes - p_peak_nes;

        powers = [p_base_nes, p_peak_nes, p_diff_nes];
    end

    function powers = synchronized_operation()
        cut = p_base_max/(p_base_max + p_peak_max);

        p_peak_nes = -(1 - cut)*p_in.*(e_peak < e_peak_max & e_peak > 0);
        p_base_nes = (- p_in - p_peak_nes).*(e_base < e_base_max & e_base > 0);
        p_peak_nes = (- p_in - p_base_nes).*(e_peak < e_peak_max & e_peak > 0);

        p_diff_nes = - p_in - p_base_nes - p_peak_nes;

        powers = [p_base_nes, p_peak_nes, p_diff_nes];
    end

end%mainfcn


% LOCAL FCNS

function tau = time_to_aim(e, e_max, p_max, soc_aim)
    % Calculates the time needed by the storage until it reaches the a fully
    % charged state, respectively a fully discharged state, depending on the
    % aimed soc assuming maximum power
    tau = (e_max - e)./p_max.*(soc_aim < 0.5) + e./p_max.*(soc_aim >= 0.5);
end
