function hybdata = main(signal, opt)
% MAIN is wrapped by HYBRID
%
% This function is only intended to be called by HYBRID.
%
% Type 'help hybrid' for more information.
%
% This kind of overloading is done to provide a project hierarchy which
% both has a clear main function as well as the possibility to call the
% main function by the projects name.

% TODO add option to add a point to an existing calculation/result (to
% refine curve afterwards if some crucial points show missing)

if nargin == 0
    help hybrid;
    hybdata = NaN;
    return
end

if nargin < 2
    opt = hybridset();
end

% Calculate the hybrid storage dimensions for each power cut
% In the first case: with allowed inter-storage flow, 
% In the second case: prohibited interstorage power flow
% Results saved in array of structs
verbose(opt.verbose, 1, ...
        ['Starting Calculation of Hybridisation Curve with ' ... 
         'inter-storage power flow allowed.'])
[hyb_base, hyb_peak] = arrayfun(@(cut) hybrid_pair(signal, cut, ...
                                                   'inter', opt), ...
                                opt.cut, 'UniformOutput', true);

verbose(opt.verbose, 1, ...
        ['Starting Calculation of Hybridisation Curve with ' ... 
         'inter-storage power flow prohibited.'])
[noi_base, noi_peak] = arrayfun(@(cut) hybrid_pair(signal, cut, ...
                                                   'nointer', opt), ...
                                opt.cut, 'UniformOutput', true);

% TODO validate output

% Generate the function handles, note the vectorization of the comma
% separated list gained by accessing a struct element of a struct array,
% i.e. the the brackets [] around the second arg of interp1
hybrid.basepower = @(cut) interp1(opt.cut, [hyb_base.power], cut, ...
                                  opt.interhyb);
hybrid.baseenergy = @(cut) interp1(opt.cut, [hyb_base.energy], cut, ...
                                   opt.interhyb);
hybrid.peakpower = @(cut) interp1(opt.cut, [hyb_peak.power], cut, ...
                                  opt.interhyb);
hybrid.peakenergy = @(cut) interp1(opt.cut, [hyb_peak.energy], cut, ...
                                   opt.interhyb);

nointer.basepower = @(cut) interp1(opt.cut, [noi_base.power], cut, ...
                                   opt.interhyb);
nointer.baseenergy = @(cut) interp1(opt.cut, [noi_base.energy], cut, ...
                                    opt.interhyb);
nointer.peakpower = @(cut) interp1(opt.cut, [noi_peak.power], cut, ...
                                   opt.interhyb);
nointer.peakenergy = @(cut) interp1(opt.cut, [noi_peak.energy], cut, ...
                                    opt.interhyb);

hybdata.hybrid = hybrid;
hybdata.nointer = nointer;
hybdata.hybrid_potential = hybrid_potential(hybrid);
hybdata.reload_potential = hybdata.hybrid_potential - ...
                           hybrid_potential(nointer);

if opt.plot_hyb
    plot_hybrid(hybdata, signal, opt);
end

end
