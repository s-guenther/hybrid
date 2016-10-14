function powers = op_strat_reload(t, p_in, e_base, e_peak, ...
                                  storage_info, signal_info)
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
%   powers          [base; peak; diff] power
%   
% Current implementation: Simply needs the period of the signal and expects
% it to be point symmetric. Storage info contains ideal two-storage
% parameter. Structs can be extended for more sophisticated strategies,
% later.

% FIXME Generalize for shorth change of sign
% FIXME Consider SOC aim =/= {1, 0}

e_base_max = storage_info.e_base;
e_peak_max = storage_info.e_peak;
p_base_max = storage_info.p_base;
p_peak_max = storage_info.p_peak;

T = signal_info.period;

soc_peak = e_peak./e_peak_max;
soc_aim = 0.*(mod(t, T) <= T/2) + 1.*(mod(t, T) > T/2);

tau_peak = time_to_aim(e_peak, e_peak_max, p_peak_max, soc_aim);
tau_base = time_to_aim(e_base, e_base_max, p_base_max, soc_aim);

p_base = (p_in <= 0 & soc_peak < soc_aim).*op_strat_p_le_0_soc_lt_aim() + ...
         (p_in <= 0 & soc_peak == soc_aim).*op_strat_p_le_0_soc_eq_aim() + ...
         (p_in <= 0 & soc_peak > soc_aim).*op_strat_p_le_0_soc_gt_aim() + ...
         ... 
         (p_in > 0 & soc_peak < soc_aim).*op_strat_p_gt_0_soc_lt_aim() + ...
         (p_in > 0 & soc_peak == soc_aim).*op_strat_p_gt_0_soc_eq_aim() + ...
         (p_in > 0 & soc_peak > soc_aim).*op_strat_p_gt_0_soc_gt_aim();

p_peak = sign(- p_in - p_base).*min(abs(- p_in - p_base), p_peak_max); 
         % TODO add limitation if soc peak = 1 or soc peak = 0

p_diff = - p_in - p_base - p_peak;

powers = [p_base; p_peak; p_diff];


    % NESTED FCNS
    function p_base = op_strat_p_le_0_soc_lt_aim()
        % Operational strategy for p_in <= 0 and soc peak < aim
    end

    function p_base = op_strat_p_le_0_soc_eq_aim()
        % Operational strategy for p_in <= 0 and soc peak = aim
    end

    function p_base = op_strat_p_le_0_soc_gt_aim()
        % Operational strategy for p_in <= 0 and soc peak > aim
    end

    function p_base = op_strat_p_gt_0_soc_lt_aim()
        % Operational strategy for p_in > 0 and soc peak < aim
    end

    function p_base = op_strat_p_gt_0_soc_eq_aim()
        % Operational strategy for p_in > 0 and soc peak = aim
        p_base = (e_base < e_base_max).* ...
                 (-min(p_in, p_base_max));
    end

    function p_base = op_strat_p_gt_0_soc_gt_aim()
        % Operational strategy for p_in > 0 and soc peak > aim
        p_base = (e_base < e_base_max).* ...
                 (-p_base_max.*(p_in >= p_base_max) + ...
                  -min(p_base_max, p_in + p_peak_max).*(p_in < p_base_max));
    end

    % DEFERRED
    function p_base = op_strat_soc_eq_aim()
        % Operational Strategy for peak soc equal aim
        p_base = -p_in.*(abs(p_in) <= p_base_max) + ...
                 -p_base_max.*sign(p_in).*(abs(p_in) > p_base_max);
    end
    function p_base = op_strat_soc_gt_aim()
        % Operational Strategy for peak soc greater than aim
        p_base = -p_base_max.*(p_in >= 0) + ...
                 -(min(p_base_max, p_peak_max) - abs(p_in)).*(p_in < 0);
    end

end%mainfcn


% LOCAL FCNS

function tau = time_to_aim(e, e_max, p_max, soc_aim)
    % Calculates the time needed by the storage until it reaches the a fully
    % charged state, respectively a fully discharged state, depending on the
    % aimed soc assuming maximum power
    tau = (e_max - e)./p_max.*(soc_aim < 0.5) + e./p_max.*(soc_aim >= 0.5);
end
