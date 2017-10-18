function comb = eco_combination(hcurve, base, peak)
% ECO_COMBINATION generates economic data for a specific base/peak pair

% initialize empty output struct
emptysub = struct('energy', @(x)x, 'power', @(x)x, 'cost', @(x)x);
comb = struct('names', '', ...
              'costs', [0, 0], ...
              'spec_powers', [0, 0], ...
              'base', emptysub, ...
              'peak', emptysub, ...
              'both', emptysub, ...
              'tuple', struct('energy', @(x)x, 'power', @(x)x));

% simple copying of data
comb.names = {base.name, peak.name};
comb.costs = [base.cost, peak.cost];
comb.spec_powers = [base.spec_power, peak.spec_power];

singlepower = hcurve.basepower(1);
singleenergy = hcurve.baseenergy(1);

% virtual intersection points with curves in base coordinate system
ebvirt = @(cut) (cut*singlepower)/base.spec_power;
epvirt = @(cut) singleenergy - ((1 - cut)*singlepower)/peak.spec_power;
ehvirt = @(cut) hcurve.baseenergy(cut);

% mapping to storage sizes
ebase = @(cut) min(epvirt(cut), ehvirt(cut)).* ...
                    (ebvirt(cut) < min(epvirt(cut), ehvirt(cut))) + ...
               ebvirt(cut).* ...
                    (ebvirt(cut) >= min(epvirt(cut), ehvirt(cut)));
epeak = @(cut) singleenergy - min(epvirt(cut), ehvirt(cut));

pbase = @(cut) base.spec_power*ebase(cut);
ppeak = @(cut) peak.spec_power*epeak(cut);

etup = @(cut) ehvirt(cut).* ...
                    (ehvirt(cut) <= min(ebvirt(cut), epvirt(cut))) + ...
              min(ehvirt(cut), epvirt(cut)).* ...
                    (ebvirt(cut) < min(ehvirt(cut), epvirt(cut))) + ...
              min(ehvirt(cut), ebvirt(cut)).* ...
                    (epvirt(cut) < min(ehvirt(cut), ebvirt(cut)));
ptup = @(cut) cut*singlepower;

% writing to output
comb.base.energy = ebase;
comb.base.power = pbase;
comb.base.cost = @(cut) base.cost*comb.base.energy(cut);

comb.peak.energy = epeak;
comb.peak.power = ppeak;
comb.peak.cost = @(cut) peak.cost*comb.peak.energy(cut);

comb.both.energy = @(cut) comb.base.energy(cut) + comb.peak.energy(cut);
comb.both.power = @(cut) comb.base.power(cut) + comb.peak.power(cut);
comb.both.cost = @(cut) comb.base.cost(cut) + comb.peak.cost(cut);

comb.tuple.energy = etup;
comb.tuple.power = ptup;

end
