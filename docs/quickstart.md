Quickstart
==========

Last Update: Thu 29. Sep 2016


Setup
-----

- Start matlab
- change directory to project root folder `cd ~/hybrid_leaf`
- add folder to path `path(path, genpath(cd))`

Function definition
-------------------


First, it is neccessary to define a power signal which will be analyzed, e.g.

```matlab
mysin.fcn = @(t) sin(t);
mysin.amplitude = 1;
mysin.period = 2*pi;
```

or

```matlab
triangular.fcn = @(t) interp1([0 1 -1 0], [0 0.5 1.5 2]*pi, ...
                              mod(t, 2*pi), 'linear');
triangular.amplitude = 1;
triangular.period = 2*pi;
```


Execute calculation
-------------------

Simply run with defaults

```matlab
resulttri = hybrid_leaf(triangular)
```

or with optional parameters

```matlab
help hybrid_leaf

max_int_step = 1e-1;
max_int_tol = 1e-3;
cut_offs = linspace(0, 1, 0.3e2);

resultsin = hybrid_leaf(mysin)
```


Visualize
---------

Visualize without coordinate transformation, open new figure

```matlab
hfigsin = plot_leaf(mysin, resultsin, 'Leaf diagram of Sine Curve')
```

or w/ coordinate transformation, further, specify a figure number the output
shall be printed to

```matlab
hfigtri = plot_leaf(triangular, resulttri, 'Leaf diagram of Triangular Curve', 1)
```
