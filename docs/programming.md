Programming Structure
=====================

A few notes the programming and project structure a gathered in this document.


Version Control
---------------

Version control follows the git-flow model. For more information, see e.g.

<http://nvie.com/posts/a-successful-git-branching-model/>\
<https://github.com/nvie/gitflow>


Structure
---------

The user functions can be found in `$HYBRID/src/`. Subdirectories of `src/`
contain subfunctions needed by the user functions. They follow the following
convention: Suppose a user function is named `fname` located in `src/`, then all
subfunctions specific to this functions are located in `src/_fname/`, so the
user function name prefixed by an underscore `_`. Additionally, `src/` contains
`auxiliary/` and `miscellaneous/`. The former one gathers functions used by various user
functions but are somehow specific to the toolbox or methodology, `miscellaneous/`
contains functions that are unrelated but used by the toolbox.

The programming structure is influenced by an object oriented mindset without
using object oriented programming. The author is aware that this is possible in
Matlab but prior experience showed that this _may_ lead to peculiar bottlenecks,
which are hard to resolve once the architecture is defined, due to the 
large overhead created by Matlab. Therefore, the architecture centers around
`structs` as a container data type and functions which process these containers.
The structs often contain `function handles` as a simple compensation for
`methods`. 

At many points within the code, the validity or integrity of the
input data is explicitely checked. This will prevent duck typing and tightly
couples data and calculation routines in most cases but emphasizes a fail fast
philosophy useful for end users. When combining this work with other ones it is
advised to build adapters which convert input and output data accordingly.

The interrelation between data containers (`structs`) and user functions is
illustrated in `$HYBRID/docs/progam_structure.svg`. As can be seen by the dashed
grey arrows indicating optional input and outputs. Most functions accept
optional parameters which will default to standard values if not set. Also, some
functions, e.g. `hybrid`, accept various input arguments and adapt their
behaviour depending on the input.
