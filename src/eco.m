function ecodata = eco(varargin)
% ECO economically investigates the problem for spec. storage technologies
%
%   The function provides a first economic estimation of the problem. It
%   analyzes the hybridisation potential with respect to specific storage
%   technologies and provides optimal storage pairings (optimal in the
%   context of the model and its underlying assumptions).
%
%   ECODATA  = ECO(HYBDATA, <STORAGES>, <STRATEGY>, <OPT>) with HYBDATA
%   being the result of HYBRID(). STORAGES is a structure obtained from
%   GEN_STORAGES() and OPT and options structure obtained from HYBRIDSET().
%
%   STORAGES, STRATEGY and OPT are optional parameters. STORAGES will
%   default to a base storage with a specific power of a third of the
%   specific power of the problem and a peak storage with a specific power
%   three times the specific power of the problem. STRATEGY can be 'inter'
%   or 'nointer' and defaults to 'inter'. It defines whether an inter
%   storage power flow is considered or not. OPT is a parameter structure
%   for the calculation.
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
%
%   Results can be visualized with PLOT_ECO. When the default values for
%   OPT are used, this is done automatically after the calculation is
%   finished.
%
%   Examples
%      % Setup
%      sig = gen_signal(@(t) (sin(t) + 3*sin(5*t)), 2*pi)
%      stor = gen_storages([0.5, 2])
%      hyb = hybrid(signal)
%
%      ecodata = eco(hyb)
%      ecodata = eco(hyb, stor, 'nointer')
%
% See also HYBRID, GEN_STORAGES, HYBRIDSET, PLOT_ECO.

[hybdata, storages, strategy, opt] = parse_eco_input(varargin{:});

if strcmpi(strategy, 'inter')
    hcurve = hybdata.hybrid;
elseif strcmpi(strategy, 'nointer')
    hcurve = hybdata.nointer;
end

spec_power = hcurve.basepower(1)/hcurve.baseenergy(1);

% separate peak and base
ind = find([storages.spec_power] > spec_power, 1, 'first');
base = storages(1:ind-1);
peak = storages(ind:end);
nbase = length(base);
npeak = length(peak);

% Assert that base and peak storages exist
if ~nbase
    error('HYBRID:eco:invalid_input', ...
          'No base storages exist, check input data of ''storages''')
end
if ~npeak
    error('HYBRID:eco:invalid_input', ...
          'No peak storages exist, check input data of ''storages''')
end

% imitate meshgrid for struct arrays
basemat = repmat(base, 1, npeak);
peakmat = repmat(peak', nbase, 1);

% calculate eco data for each combination
ecodata = arrayfun(@(base, peak) eco_combination(hcurve, base, peak), ...
                   basemat, peakmat);

if opt.plot_eco
    plot_eco(ecodata);
end

end
