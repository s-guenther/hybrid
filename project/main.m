function out = main(signal)
% MAIN Gather main functionality of hybrid leaf tool
%
% Calculates energy and power for hybrid storage systems containing a base
% and a peak storage. With this, performance and e/p spread can be made
% visible and analysed.
% 
% Input:
%   signal      struct, see issignalstruct
%
% Output:
%   out         struct
%       .e_single   energy of single storage needed for given signal
%       .p_single   power of single storage needed for given signal
%
% Theory involves: cutting signal at specific value, calculating separate
% storages for this, no inter storage power flow (transloading). Only valid
% for point symmetric signals at the moment

assert(issignalstruct(signal), 'Invalid input - no signal struct')

% Calculate single storage properties
[e_single, p_single] = calc_single_storage(signal);

% TODO Calculate e/p for hybrid storage multiple storages

% Gather output
out.p_single = p_single;
out.e_single = e_single;

end%main
