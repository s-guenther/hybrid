Data Preparation
================

The toolbox has relatively strict requirements regarding the input data. Your
input data must comply with the following assumptions:

1) arithmetic mean must be zero
2) integral must be zero at beginning and end
3) integral must be larger than or equal to zero for all times

From these assumptions follows:

1) The storages are ideal, there are neither conversion losses nor standby losses.
2) A complete charging and discharging cycle must be analyzed. At the beginning
   and at the end the storage must be empty. Somewhere in between, the storage
   will be fully charged.
3) The charging state of a storage cannot be lower than zero. The third
   restriction ensures that the storage does not become undercharged.

If your data does not comply with the restrictions, the signal generation via
`gen_signal` will fail and you will not obtain a signal struct needed for the
calculation. There are a few options to make your data satisfy the conditions.


1) My storages are not ideal and subject to losses
--------------------------------------------------

You can calculate an ideal storage profile from your storage profile subject to
losses. Suppose your storage has an efficiency of eta=0.8 and a self discharge
rate of dis=1%/time_step. The model will look like this:

```
                                    energy*dis
               .----- *eta -----.   ^
               |                |   |
               |pos             v   |
   -- power -->o                o-->o---> power_ideal
               |neg             ^
               |                |
               .---- *1/eta ----.

    where energy_i = sum (from j = 1 to i) of power_ideal*dtime
```

So, to calculate power_ideal for each time step perform:

```matlab
    eta = 0.8   % or choose appropriate to your data
    dis = 0.01  % 
    % first calculate profile with efficiency respected
    power_ideal = heaviside(power)  .* power * eta + ...
                  heaviside(-power) .* power * 1/eta;
    % add self discharge rate
    n = length(p_ideal);
    timestep = 1  % or whatever discretization your data has
    for i = 1:n
        if i == 1
            e_at_i_minus_1 = 0;
        else
            e_at_i_minus_1 = cumsum(p_ideal(1:i-1)*timestep);
        p_ideal(i) = p_ideal(i) - e_at_i_minus_1*dis;
    end
```

(This is not the most efficient implementation but is believed to be the easiest
one to read)

The same principle can be be applied to other (nonlinear) storage models


2) I only want to analyze my discharging phase and don't care about charging
----------------------------------------------------------------------------

This can be achieved easily by prepending a charging to the data by point
morroring the discharging phase. This ensures, that the virtual charging phase
does not influence the results:

```matlab
    newdata = [-fliplr(data), data];  % if data is a row vector
```

Don't forget to adjust the corresponding time vector. The same principle applies
if you are only interested in the charging phase or if you have a storage power
profile with a complete charging cycle and an incomplete discharging cycle etc.


3) My data does start and end with the same state of charge, but is not zero
----------------------------------------------------------------------------

If you believe that your storage has a complete charging and discharging phase,
but your integral drops below zero in between, then your data does not start at
a state of charge of zero. You can shift your data as shown below.

```matlab
    % Define Data
    t = linspace(0, 2*pi, 2^4+1);
    x = sin(t+pi/2);
    % Integrate, find index of minimum of integral
    intx = cumtrapz(x)*(t(2)-t(1));
    [~, ind] = min(intx);
    % Shift Data (xdouble is only temporary)
    xdouble = [x, x(2:end)];
    xnew = xdouble(ind:ind+length(x)-1);
    intxnew = cumtrapz(xnew)*(t(2)-t(1));
    % Show results
    subplot(2,1,1), plot(t, x, t, intx), title('Original Data'), grid on
    subplot(2,1,2), plot(t, xnew, t, intxnew), title('Shifted Data'), grid on
```

Depending on the definition of your data vector, you may treat the start and end
points differently. In the example above, the start point equals the end point,
so I removed one of them when doubling the data.

If your data is available as a function handle, you can also shift the function
handle directly with:

```matlab
    % Define function
    fcn = @(t) sin(t+pi/2);
    % Determine minimum of the integral, we already know that this is at 3/4*pi
    % in this case
    fcnnew = @(t) fcn(t + 3/4*pi);
```


4) My data complies with the restrictions, but gen_signal fails nevertheless
----------------------------------------------------------------------------

This may happen due to numerical errors. The error message should indicate the
problem. Try tweaking the tolerances

```
    amv_rel_tol
    int_neg_rel_tol
    int_zero_rel_tol
    odeset
```

See function `hybridset` for more information.
