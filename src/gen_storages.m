function storages = gen_storages(spec_powers, varargin)
% GEN_STORAGES builds a storage structure for hybrid storage calculation
%
%   GEN_STORAGES takes a list of storages, in form of their specific powers
%   and generates a storage struct array of the form
%
%       storages
%           .spec_power double, specific power of the storage
%           .price      double, price of the storage
%           .name       string, name of the storage
%
%   STORAGES = GEN_STORAGES(SPEC_POWERS, <OPT>) where SPEC_POWERS are the
%   specific powers of the storages, OPT is an optional options struct
%   which defaults to OPT = HYBRIDSET().
%   STORAGES = GEN_STORAGES(SPEC_POWERS, <PRICES>, <NAMES>, <OPT>) where
%   PRICES is an optionally provided vector of prices and NAMES an
%   optionally provided cell array of names
%
%   If PRICES is omitted, it will be proportional to the specific power and
%   default to (1 + SPEC_POWERS).
%   If NAMES is omitted, it will default to num2str(SPEC_POWERS).
%
%   OPT is a parameter structure obtained from HYBRIDSET. The important
%   field of the OPT struct with regard to this function is 'plot_stor'.
%
%   The storages in the output struct will be sorted (ascending) by its
%   specific powers.
%
%   SI units assumed. The calculations are dimensionless, the user is
%   responsible for a consistent set of units.
%
%   Examples
%
%       storages = GEN_STORAGES([1, 5, 2, 10])
%
%       opt = HYBRIDSET('plot_stor', 1)
%       storages = GEN_STORAGES(unique(randi(10, 1, 5)), opt)
%
%       storages = GEN_STORAGES([3 5 100]/3600, [600 800 20000], ...
%                               {'LiIon1', 'LiIon2', 'Flywheel'})
%
% See also HYBRIDSET, ECO, PLOT_STORAGES.

% parse input
[prices, names, opt] = parse_gen_storages_input(spec_powers, varargin{:});

% sort
[spec_powers, ind] = sort(spec_powers);
prices = prices(ind);
names = names(ind);

% preallocate
storages = repmat(struct('spec_power', 0, ...
                         'price', 0, ...
                         'name', ''), ...
                  length(spec_powers), 1);
% fill
for i = 1:length(spec_powers)
    storages(i).spec_power = spec_powers(i);
    storages(i).price = prices(i);
    storages(i).name = names(i);
end

if opt.plot_stor
    plot_storages(storages, opt)
end

end
