function signal = gen_signal(varargin)
% GEN_SIGNAL generates signal structure for hybrid storage calculation
%
%   GEN_SIGNAL takes several different input variants and generates an
%   input signal structure for other calculations specific to this toolbox
%   of the form
%
%       signal
%           .period     period of signal
%           .amplitude  amplitude of signal
%           .maxint     maximum integral value within period
%           .rms        root mean square
%           .arv        average rectified value
%           .form       form factor
%           .crest      crest factor
%           .type       can be discrete - 'step' or 'linear', 
%                       or continuous - 'fhandle'
%   
%       Depending on type, it has the following additional fields
%
%       type == 'step' || type == 'linear'
%           .time       time vector [n, 1]
%           .val        value vector [n, 1]
%       type == 'fhandle'
%           .fcn        function handle val = @(time) ...
%
%   SIGNAL = GEN_SIGNAL(TIME, VAL, <OPT>) where TIME and VAL are vector
%   value pairs of the same length describing the signal function. Uses the
%   options OPT for calculation.
%   SIGNAL = GEN_SIGNAL(TIME, VAL, <TYPE>, <OPT>). TYPE can either be
%   'step' or 'linear', default is 'step'.
%
%   OPT is a parameter structure obtained from HYBRIDSET. Important fields
%   of the OPT struct are 'odeparams', 'amv_tol', 'sig_plot'
%
%   SIGNAL = GEN_SIGNAL(FHANDLE, PERIOD, <OPT>) where FHANDLE is a function
%   handle of a periodic function of the form VAL = @(TIME) ... with period
%   PERIOD. The TYPE defaults to 'fhandle'.
%   
%   It must be ensured that the signal is periodic, has an arithmetic mean
%   of zero and that its integral does not drop below zero.
%
%   It is highly recommended to build the signal structure with the help of
%   this function as it performs some validation and plausibility checks.
%
%   SI units assumed.
%
%   Examples
%
%       SIGNAL = GEN_SIGNAL(@(t) sin(t) + 0.5*sin(2*t), 2*pi)
%       SIGNAL = GEN_SIGNAL(@(t) interp1([0 2 4  5  7 9], ...
%                                        [0 1 3 -3 -1 0], ...
%                                        mod(t, 9), ...
%                                        'pchip'), ...
%                           9)
%
%       SIGNAL = GEN_SIGNAL([1 2 3 4 5 6], [1 2 1 -2 -1 -1])
%       SIGNAL = GEN_SIGNAL([0 1 2 3 3+eps 7], [0 2 1 2 -1 -1], 'linear')
%
%   See also HYBRIDSET, HYBRID, SIM_OPERATION, PLOT_HYBRID.


[sigtype, opt, in1, in2] = parse_gen_signal_input(varargin);

switch lower(sigtype)
    case 'fhandle'
        fcn = in1;
        period = in2;
        signal = gen_sig_fhandle(fcn, period, opt);
    case 'step'
        time = in1;
        val = in2;
        signal = gen_sig_step(time, val, opt);
    case 'linear'
        time = in1;
        val = in2;
        signal = gen_sig_linear(time, val, opt);
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The privided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

check_signal_validity(signal, opt);

end
