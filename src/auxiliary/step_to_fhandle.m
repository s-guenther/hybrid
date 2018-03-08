function sigfhandle = step_to_fhandle(sigstep, opt)
% STEP_TO_FHANDLE converts a signal of type 'step' into type 'fhandle'
%
%   SIGFHANDLE = STEP_TO_FHANDLE(SIGSTEP, <OPT>)
%
% See also GEN_SIGNAL, LINEAR_TO_FHANDLE.

if nargin < 2
    opt = hybridset();
end

opt.plot_sig = 0;

verbose(opt.verbose, 1, ...
        'Converting signal of type ''step'' into type ''fhandle''')

x = sigstep.time(1:end-1);
y = [sigstep.val];
 
xbefore = x - opt.smooth_step;
xafter = x + opt.smooth_step;

ybefore = y(1:end-1);
yafter = y(2:end);

xmatrix = [xbefore, xafter]';
ymatrix = [ybefore, yafter]';

xvec = [0; xmatrix(:); x(end)];
yvec = [y(1); ymatrix(:); y(end)];

fcn = @(xx) interp1(xvec, yvec, xx, 'pchip');

sigfhandle = gen_signal(fcn, sigstep.period, opt);

end
