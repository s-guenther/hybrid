function val = repetive_pulse(t, T, dT, Amp, dAmp, n)
% REPETIVE_PULSE Generates a pulsed signal
%
%

ischarge = mod(t,2*n*T) < n*T;
ispeak = mod(t,T) < dT*T;

val = Amp*(1*(ischarge.*ispeak) + ...
           dAmp*(ischarge.*~ispeak) + ...
           -1*(~ischarge.*ispeak) + ...
           -dAmp*(~ischarge.*~ispeak));

end
