function result_array = study_signal_group(genericsignal, groupname, ...
                                            showprogress, signal_para_vec)
% STUDY_SIGNAL_GROUP studies a signal with a free parameter
%
% Performs hybrid_leaf calculation for a number of signals. The signal is a
% variation of the signal struct from issignalstruct.m with a free parameter
% which alters the signal.
%
% Input:
%   generic_signal  signal struct, see issignalstruct.m, but .fcn 
%                   depends on time t and a free parameter para, which will
%                   be substituted within the algorithm
%   groupname       string, name which describes the kind of signal,
%                   can be chosen arbitrarily, e.g. 'PWM'
%   showprogress    optional, bool, display progress of calculation,
%                   default: 0
%   signal_para_vec optional, default: nonuniform distribution satisfying
%                   0 < signal_para_vec < 1, with 11 elements
% Output:
%   result_array    cell vector, each element contains:
%                   {signal, result, name, signal_para_val}

if nargin < 3
    showprogress = 0;
end
if nargin < 4
    signal_para_fcn = @(x) x - 0.15*sin(x*2*pi);
    signal_para_vec = signal_para_fcn(linspace(1e-2, 1 - 1e-2, 11));
end


n_signal_para = length(signal_para_vec);
result_array = cell(n_signal_para, 1); % cell vector of cell vectors
for ii = 1:n_signal_para

    if showprogress; tic; end

    signal_para_val = signal_para_vec(ii);

    name = [groupname, ', Signal Parameter: ', num2str(signal_para_val)];

    signal = genericsignal;
    signal.fcn = @(t) signal.fcn(t, signal_para_val);

    result = hybrid_leaf(signal);

    result_array{ii} = {signal, result, name, signal_para_val};

    if showprogress; disp(['SimTime for ' name, ': ' num2str(toc)]); end
end

end
