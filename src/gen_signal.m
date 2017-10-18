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
%           .int        value vector [n, 1] of integral
%       type == 'fhandle'
%           .fcn        function handle val = @(time) ...
%           .int        function handle for integral val = @(time) ...
%
%   SIGNAL = GEN_SIGNAL(TIME, VAL, <OPT>) where TIME and VAL are vector
%   value pairs of the same length describing the signal function. Uses the
%   options OPT for calculation.
%   SIGNAL = GEN_SIGNAL(TIME, VAL, <TYPE>, <OPT>). TYPE can either be
%   'step' or 'linear', default is 'step'.
%
%   OPT is a parameter structure obtained from HYBRIDSET. Important fields
%   of the OPT struct with regard to this function are 'odeparams',
%   'optimset', 'amv_rel_tol', 'int_neg_rel_tol', 'int_zero_rel_tol',
%   'ampl_sample', 'plot_sig'.
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
%   SI units assumed. The calculations are dimensionless, the user is
%   responsible for a consistent set of units.
%
%   Examples
%
%       signal = GEN_SIGNAL(@(t) sin(t) + 0.5*sin(3*t), 2*pi)
%       signal = GEN_SIGNAL(@(t) interp1([0 2 4  5  7 9], ...
%                                        [0 1 3 -3 -1 0], ...
%                                        mod(t, 9), ...
%                                        'pchip'), ...
%                           9)
%
%       signal = GEN_SIGNAL([1 2 3 4 5 6], [1 2 1 -2 -1 -1])
%       signal = GEN_SIGNAL([0 1 2 3 3+1e-6 7], [0 2 1 2 -1 -1-1e-6], ...
%                           'linear')
%
% See also HYBRIDSET, HYBRID, SIM_OPERATION, PLOT_HYBRID.

[sigtype, opt, in1, in2] = parse_gen_signal_input(varargin{:});

switch lower(sigtype)
    case 'fhandle'
        gen_sig = @gen_sig_fhandle;
    case 'step'
        gen_sig = @gen_sig_step;
    case 'linear'
        gen_sig = @gen_sig_linear;
    otherwise
        error('HYBRID:sig:invalid_input', ...
              ['The provided signal type ''%s'' is unknown, must be\n', ...
               '''fhandle'', ''step'' or ''linear'''], sigtype)
end

signal = gen_sig(in1, in2, opt);

[valid, errmsg] = isvalidsignal(signal, opt);
if ~valid
    error('HYBRID:sig:invalid_signal', errmsg)
end

if opt.plot_sig
    plot_signal(signal, opt);
end

end
