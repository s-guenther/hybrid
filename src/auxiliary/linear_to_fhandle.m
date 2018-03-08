function sigfhandle = linear_to_fhandle(siglinear, opt)
% LINEAR_TO_FHANDLE converts a signal of type 'linear' into type 'fhandle'
%
%   SIGFHANDLE = LINEAR_TO_FHANDLE(SIGLINEAR, <OPT>)
%
% See also GEN_SIGNAL, STEP_TO_FHANDLE.

if nargin < 2
    opt = hybridset();
end

opt.plot_sig = 0;

verbose(opt.verbose, 1, ...
        'Converting signal of type ''linear'' into type ''fhandle''')
 
fcn = @(tt) interp1(siglinear.time, siglinear.val, tt, 'linear');

sigfhandle = gen_signal(fcn, siglinear.period, opt);

end
