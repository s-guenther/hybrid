HYBRID
======

HYBRID is a tool which dimensions a hybrid energy storage system consisting of
two different storages. It uses a strategy, which divides the load profile into
a base signal and a peak signal which is taken care of by a base storage or a
peak storage, respectively. The devision is simply a cut at a certain percentage
of peak power of the original load profile. Depending on the value of the cut,
various E/P ratios for peak and base storage occour, building a characteristic
hybridisation curve. The investigaion of these is subject to this toolbox.


Requirements
------------

Besides Matlab, no special requirements. See `$HYBRID/REQUIREMENTS.md`.


Installation
------------

No special installation procedures. Just download source code.


Usage
-----

Execute `$HYBRID/hybrid.m` in Matlab.
See `$HYBRID/sample/minimal.m` and others for a working example.
See `$HYBRID/docs/quickstart.md` and others for further information.


License
--------

See `$HYBRID/LICENSE`.


Author
------

Sebastian Günther, sebastian.guenther@ifes.uni-hannover.de
Created: Wed 14. Sep 2016
Last Update: Tue 04. Jul 2017
