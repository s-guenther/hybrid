HYBRID_LEAF
==========

Hybrid Leaf is a tool which dimensions a hybrid senergy storage system
consisting of two different storages. It uses a strategy, which divides the
load profile into a base signal and a peak signal which is taken care of by a
base storage or a peak storage, respectively. The devision is simply a cut at a
certain percentage of peak power of the original load profile. Depending on the
value of the cut, various E/P ratios for peak and base storage occour, building
a leaf. The investigaion of these is subject to this toolbox.

Works for arbitrary signals, as long as they are point symmetric. Inter storage
energy flow is not considered, yet.

An analytical formulation for the leaf form is searched, without success atm

Various samples for investigation behaviour are generated. Various tools for
visualizing them are provided.


Requirements
------------

Besides Matlab, no special requirements. See `$HYBRID_LEAF/REQUIREMENTS.md`


Installation
------------

No special installation procedures. Just download source code.


Usage
-----

Execute `$HYBRID_LEAF/hybrid_leaf.m` in Matlab
See `$HYBRID_LEAF/sample/minimal.m` and others for a working example.
See `$HYBRID_LEAF/docs/quickstart.md` and others for further information


License
--------

See `$HYBRID_LEAF/LICENSE`


Author
------

Sebastian Günther, sebastian.guenther@ifes.uni-hannover.de
Created: Wed 14. Sep 2016
Last Update: Mon 26. Sep 2016
