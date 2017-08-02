function [signals, results] = one_year_cycle()
% Process real life data

inputdata = load('one_year_sample.mat');
raw_powerarray = inputdata.P_s_out;
raw_time = inputdata.t';

fprintf('\n----- Start preparing input data ------\n')

tic
signals = batch_prepare(raw_time, raw_powerarray);
toc

fprintf('\n----- Start executing hybrid_leaf -----\n')
tstart = tic;
%results = calc_hybrid_results(signals);
results = NaN;
fprintf('\nTotal calculation elapsed time:\n')
toc(tstart)

end


%% LOCAL FUNCTIONS

function signal = prepare(intime, inpower)
    % convert one time/power so that it matches the requirements for
    % gen_signal

    % shift signal in a way that e(t=0) = 0 and e(t) >= 0 forall t
    inenergy = cumsum(diff([0; intime]).*inpower);
    [~, minind] = min(inenergy);
    power = [inpower(minind+1:end); inpower(1:minind)];
    time = intime*3600;

    opt = hybridset('verbose', 1, 'plot_sig', 0);
    signal = gen_signal(time, power, opt);

end

function signals = batch_prepare(intime, inpowerarray)
    % execute 'prepare' for all power vectors

    powercell = mat2cell(inpowerarray, ...
                         size(inpowerarray, 1), ...
                         ones(1, size(inpowerarray, 2)));
    signals = cellfun(@(power) prepare(intime, power), powercell, ...
                      'UniformOutput', false);
    signals = cell2mat(signals);

end

function results = calc_hybrid_results(signals)
    % calculate 'hybrid_leaf' for all signals


    for ii = 1:length(signals)
        opt = hybridset('verbose', 2, 'plot_sig', 0, 'plot_hyb', 1000+ii);
        fprintf('\n---\nStarting hybrid calculation number %s\n', ...
                num2str(ii))
        tic

        results(ii) = hybrid(signals(ii), opt); %#ok
        toc
    end

end
