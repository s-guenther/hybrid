function signal = rep_pulse_signal(T, dT, Amp, dAmp, n)

signal.fcn = @(t) repetive_pulse(t, T, dT, Amp, dAmp, n);
signal.amplitude = Amp;
signal.period = 2*n*T;

end
