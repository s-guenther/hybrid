function out = hybrid(varargin)
% HYBRID calculates the data for the hybridisation diagram
% 
%   HYBRID is the main calculation routine of this toolbox. It analyzes the
%   signal with respect to its hybridisation potential and provides data for
%   the hybridisation diagram.
%
%   HYBDATA = HYBRID(SIGNAL, <OPT>) analyzes SIGNAL, using the the options
%   OPT for calculation. SIGNAL is preferably obtained by the function
%   GEN_SIGNAL.
%
%   OPT is a parameter structure obtained from HYBRIDSET. Important fields
%   of the OPT struct are 'cut', 'odeparams', 'continuous_solver',
%   'discrete_solver', 'plot_hyb'
%
%   HYBDATA is a structure with the following form:
%
%      hybdata
%           .hybrid             results with inter-storage power flow
%               .basepower          fhandle, fcn of power cut in [0...1]
%               .baseenergy         fhandle, fcn of power cut in [0...1]
%               .peakpower          fhandle, fcn of power cut in [0...1]
%               .peakenergy         fhandle, fcn of power cut in [0...1]
%           .nointer            results without inter-storage power flow
%               .basepower          fhandle, fcn of power cut in [0...1]
%               .baseenergy         fhandle, fcn of power cut in [0...1]
%               .peakpower          fhandle, fcn of power cut in [0...1]
%               .peakenergy         fhandle, fcn of power cut in [0...1]
%           .hybrid_potential   Hybridisation Potential
%           .reload_potential   Reload Potential
%
%   Base and peak storage sizes are calculated at discrete points (see
%   OPT.cut). The function handles are obtained through interpolation
%   routines.
%
%   Results can be visualized with PLOT_HYBRID. By the default
%   specification of OPT, this is done automatically after the calculation
%   finished.
%
%   Examples
%       signal = gen_signal(@(t) sin(t) + 0.5*sin(2*t), 2*pi)
%       hybdata = hybrid(signal)
%
%       opt = hybrisset('plot_hyb', 0, 'continuous_solver', @ode23)
%       hybdata = hybrid(signal, opt)
%
%   Calculates energy and power for hybrid energy storage systems
%   containing a base and a peak storage for various power cuts. With this,
%   performance and e/p spread can be made visible and analysed.
%
%   See also HYBRIDSET, GEN_SIGNAL, ECO, PLOT_HYBRID

out = main(varargin{:});

end
