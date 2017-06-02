function hybdata = hybrid(signal, opt)
% HYBRID calculates the data for the hybridisation diagram
% 
%   HYBRID is the main calculation routine of this toolbox. It analzes the
%   signal with respect to its hybridisation potential and provides data for
%   the hybridisation diagram.
%
%   HYBDATA = HYBRID(SIGNAL, <OPT>) analyzes SIGNAL, using the the options
%   OPT for calculation.
%
%   OPT is a parameter structure obtained from HYBRIDSET. Important fields
%   of the OPT struct are 'cut_vector', 'odeparams', 'cont_solver',
%   'disc_solver', 'hyb_plot'
%
%   HYBDATA is a structure with the following form:
%
%      hybdata
%           .basepower          fhandle, fcn of power cut in [0...1]
%           .baseenergy         fhandle, fcn of power cut in [0...1]
%           .peakpower          fhandle, fcn of power cut in [0...1]
%           .peakenergy         fhandle, fcn of power cut in [0...1]
%           .hybrid_potential   Hybridisation Potential
%           .reload_potential   Reload Potential
%
%   Examples
%
%   Calculates energy and power for hybrid energy storage systems containing a base
%   and a peak storage for various power cuts. With this, performance and
%   e/p spread can be made visible and analysed.
%
%   See also HYBRIDSET, GEN_SIGNAL, ECO, PLOT_HYBRID

end
