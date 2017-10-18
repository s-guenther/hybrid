HYBRID
======

HYBRID is a tool which dimensions a hybrid energy storage system consisting
of two different storages. For a given load profile or signal of a storage,
a single storage with minimal dimensions with regard to its power and
energy capacity is calculated. From this point, the single storage is
separated into a base storage and a peak storage which power and energy
capacities add up to these of the single storage. Moreover, the energy
capacity of the peak storage is minimized for a fixed power ratio. This
way, the single storage with an original power to energy ratio (specific
power) is replaced with two new storages, one with a lower specific power
and one with a higher specific power.

Requirements
------------

Besides Matlab, no special requirements. See `$HYBRID/REQUIREMENTS.md`.


Installation
------------

No special installation procedures. Just download the source code and add
it to the Matlab path.


Usage
-----

In Matlab, add folder `$HYBRID` to path. Execute `hybrid`.
See `$HYBRID/sample/minimal.m` for a simple example.
See `$HYBRID/docs/quickstart.md` for further usage information.
See `$HYBRID/docs/informal_introduction.md` for background information regarding
the theory.


License
-------

This software is licensed under GPLv3, excluding later versions.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For details see the license file `$HYBRID/LICENSE`.

GPLv3 explicitely allows a commercial usage without any royalty or further
implications. However, any contact to discuss possible cooperations is
appreciated.


Author
------

hybrid - Calculation Toolbox for Hybrid Energy Storage Systems
Copyright (C) 2017
Sebastian Günther
sebastian.guenther@ifes.uni-hannover.de

Institut für Elektrische Energiesysteme
Fachgebiet für Elektrische Energiespeichersysteme

Institute of Electric Power Systems
Electric Energy Storage Systems Section

https://www.ifes.uni-hannover.de/ees.html
