function [hybdata, ecodata] = hybrid(varargin)
% HYBRID calculates the data for the hybridisation diagram
% 
%   HYBRID is the main calculation routine of this toolbox. It analyses the
%   signal with respect to its hybridisation potential and provides data for
%   the hybridisation diagram.
%
%   HYBDATA = HYBRID(SIGNAL, <OPT>) analyses SIGNAL, using the the options
%   OPT for calculation. SIGNAL is a structure obtained by the function
%   GEN_SIGNAL().
%
%   [HYBDATA, ECODATA] = HYBRID(SIGNAL, STORAGES, <OPT>) If a storage
%   structure STORAGE is additionally provided, obtained from
%   GEN_STORAGES(), an economic investigation is additionally performed.
%   
%   OPT is an optional parameter structure obtained from HYBRIDSET().
%   Important fields of the OPT struct are 'cut', 'odeset',
%   'continuous_solver', 'discrete_solver', 'plot_hyb'.
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
%   ECODATA is an (m x n) array of structs, where m is the number of base
%   storages and n the number of peak storages. Each struct element has the
%   following fields:
%       .names                {base name, peak name}
%       .costs                [base spec costs, peak specific costs]
%       .spec_powers          [base, peak]
%       <.base .peak .both>
%           .energy           fhandle, energy of <> as function of power cut
%           .power            fhandle, power of <> as function of power cut
%           .cost             fhandle, costs of <> as function of power cut
%       .tuple                describes the minimal theo. storage pair
%           .energy           fhandle, energy as function of power cut
%           .power            fhandle, power as function of power cut
%   For mor information concerning ECODATA, see help of function ECO.
%
%   Base and peak storage sizes are calculated at discrete points (see
%   OPT.cut). The function handles are obtained through interpolation
%   routines.
%
%   Results can be visualized with PLOT_HYBRID. When the default values for
%   OPT are used, this is done automatically after the calculation is
%   finished. Visualization output depends on input arguments.
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
% See also HYBRIDSET, ECO, GEN_SIGNAL, GEN_STORAGES, PLOT_HYBRID.

[hybdata, ecodata] = main(varargin{:});

end
