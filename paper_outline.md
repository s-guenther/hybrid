Outline Paper
=============


XXX Possible Titles and Keywords
--------------------------------

Theoretical sizing/dimensioning limits of hybrid storages for arbitrary signals

Load Profile/ Signal dependend, technology invariant dimensioning limits of
hybrid energy storage systems

Analytical benchmark calculation for determining technology invariant and
signal dependent dimensioning limits of hybrid energy storage systems

- Instead of 'signal' - 'load profile' ?

- analytical
- generalization ?
- hybrid storage
- benchmark
- theoretical
- sizing, dimensioning, design
- predimensioning
- hybridisation potential
- limit
- technology independent
- signal dependend
- minimum peak storage dimensioning 
- technology selection

avoid:

- novel, general, advanced, sophisticated, optimize, study, optimal, analysis,
  high, proposal, modular


XXX Classification/Abstract
---------------------------

- XXX General approach to choose storage combination and to characterize the
  potential for hybridisation


XXX Distinction
---------------

- XXX While other theories/studies imply a favourable use of hybrid storage with
  a certain size and certain strategy and say, it is quantatively better for
  this application, this theory investigates the potential and helps finding a
  good combination, starting point
- XXX Hybrid storages are multivariable optimizations, where in other studies
  most of these variables are implicitely fixed or weighted with a cost
  function and somehow hidden. This way, these studies are hardly comparable
  and the design process is not generic.


XXX Things not considered in theory
-----------------------------------

- nonidealities (like P(E), respectively P(SOC), E(d/dt E) (Ragone)), losses
- nonuniform signals (integral not zero)
- aging, cycle load on storages

- for complete arbitrary signals, a complete knowledge of future is needed,
  which makes the strategy somewhat theoretical and impossible to
  apply/implement


XXX Things that can be done with theory, How can theory be used despite problems
--------------------------------------------------------------------------------

- predimensioning
- determining potential
- does not contradict previous work, only abstracts problem and gives insight
  on the nature of the problem
- theory is analytical and complete. It does not cover many real life problems
  (aging, transients, losses, P(E), physical dimensions, mass, costs, power
  electronic architecture, thermal aspects).
- Simplifications allow unifying dimensioining and design process for small as
  well as large problems, mobile and stationary
- Even if it only provides a good starting point for an optimization, it does
  have value
- can verify applications.
- can be plotted with a lot of technologies for a first cost estimation for
  each technology pairing
- can be used as a design variable within many other design variables in
  multivariable optimization
- The investigations are more or less control strategy free, separating design
  process
- With this, it is easier to see trade offs between overdimensioning, aging,
  mass, transients, costs, losses, power-energy spectrum, spectrum analysis,
  and so on (Paper 2), while in other papers a parameter sensitivity or
  influence is often disguised since general optimizations only output costs,
  which are weighted and calculated up infront
- These analysis can help finding the right control strategy, or tuning a
  specific one


XXX Major insights
------------------

- XXX an ideal single storage is always separable in 2 or more ideal hybrid
  storages
- XXX 2 can never be better than one, but within the limits always as good
- XXX there is a distinct line separating what works, and what does not work
- XXX Leaving line leads to overdimensioning
- XXX can be neccassary to: reduce cycle load

XXX Proposals
-------------

- hybridisation potential parameter, integral and single, maximum
- reload potential parameter, integral and single, maximum
- overdimenisioning factor, utilisation factor
- cycle load, roundtrips, minimal, realized
- aging (d/dt SOH)
- transient stress (d/dt SOC), power spectrum (frequency), and see above
  (things that can be done)
- power energy spectrum (DEFERRED) (spectrogram-like, short time fourier)


XXX How does it perform and compare on 'real life' problems, Examples
-----------------------------------------------------------------

- pulsed loads
- nefz


Work to do/Outlook
------------------

- fix problems
- expand to general signals w/ where system can choose which parts it takes
    - is peak base splitting still optimal if system chooses power greedy
- expand to storages w/ losses and other nonidealities
- embed this in larger design process
- develop a theory comparable to equivalent stress hypothesis
- linear loss models can be easily taken into account, but a way to recalculate
  nonlinear models is needed
- aging theory comparable to rheologic models, fatique limits, wöhler curves
- optimize operational strategy, since it leads to useless interstorage
  charging
- solid predimensioning tools, algorithms and theory that assist finding the
  right technologies, dimensions and control strategies. The results should
  have a value comparable to technical mechanics: Solid and sufficient for
  most applications, delivering good rule of thumbs, but more thorough
  investigations and simulations needed for details. Tools should provide
  results which are tangible for humans and general for all applications and
  not as abstract as generic optimizations.
- How to use theory specifically in a larger design process


To mention
----------

- Analytical derivations of leaf form performed, but not a valid assumption,
  Form and Crest give hint of hybridisation ability
- theory can be done for different chi_charge/discharge - incorporate in theory
  and diagrams - there is a maximum and minimum chi ratio! (dependent on
  current chi?)
- cascading storages
- toolbox


XXX Which diagrams pictures do I need
-------------------------------------

- maximize content of each individual figure

- 1 leaf diagram, with explanation, 2C0.4H or 1C?
- 1 describing arising problem without future knowledge, 1C 0.3H
- 1 decay integral for example signal, w/ reloading, w/o, 1C 0.4H
- 1 for control strategy, schematic, block diagram, 1C 0.4H
- 1 time signal of control strategy 1C, 0.3H
- 2 economic investigation with specific isochrones, construction and result,
    1C 0.3H and 2C 0.3H
- 1 combined for nefz and pulsed 2C 0.3H


Equations
---------


Others, Todo
------------

- new name for leaf diagram needed - hybridisation curve?
- toolbox specifications/requirements for open source publishing
- which journal? what requirements to structure?
- Dissertation title: Methods for selection, design and evaluation of hybrid
  energy storage systems


Story Line
----------

- make reasonable story which embeds decay integral from beginning
- somewhere to include: how to use theory in a larger design process !!
- how much math is allowed before actual math chapter
- structure of description first, math later because: otherwise the whole
  purpose and value only expresses itself after several pages and may get lost
  in between
- do I speak of 'signal' or 'load profile'

- aimed space fo each chapter
    - Abstract & Co     0.5
    - Notation          1
    - 1 Intro           0.5
    - 2 General         2.5
    - 3 Math, Model     2.5
    - 4 Economic        1.5
    - 5 Examples        1
    - 6 To mention      0.5
    - 7 Summary         0.5
    - References        0.5
    - TOTAL             11


### Title

Signal dependend, technology invariant dimensioning limits of hybrid energy
storage systems


### Keywords

hybrid energy storage systems, dimensioning, sizing, predimensioning,
analytic hybridisation potential
(battery-capacitor combination, nefz)


### Abstract

- in this paper, a theoretical and analytical benchmark calculation is
  performed, which results in a maximum possible hybridisation
- with hybridisation is meant...
- therefore, hybridisation diagram is proposed and integral hybridisation
  potential parameter is proposed/introduced
- needs ideal storages, is applicaple to all arbitrary signals
- an ideal single storage is always separable in 2 ideal hybrid storages
- resulting achievable ratio of P/E ratios of the both is dependent on signal
  and marks a clear line of possible and impossible combinations
- Since analytical, only acts as a predimensioning tool and first step of
  design process, more thorough investigations needed afterwards
- General approach to choose storage combination and to characterize the
  potential for hybridisation

- theory is technology, control strategy and topology free, providing a unified
  look on hybrid energy storage problems


### Notation

- list variables and explanation here
- arabic small letters: time dependent (except t)
- capital: scalars
- fat: vectors
- hat: maximum of rectified time signal
- variables:
    - arabic
        - e .. energy
        - p .. power
        - t .. time
        - E .. energy of storage
        - P .. power of storage
        - T .. period
        - A .. general purpose
        - B .. general purpose
        - f .. function, general
        - c .. condition, general
        - H .. hybridisation factor
        - R .. reload factor
        - soc .. state of charge
        - fat __D__ .. dimension (E P)
    - greek
        - chi .. fractional power cut
        - eta .. efficiency
- indicee:
    - p .. peak
    - b .. base
    - s .. single
    - h .. hybrid
    - i .. loop variable
    - 0 .. point in time 0 where period starts
    - virt .. virtual
    - req .. request
    - build .. build
    - decay .. decay
    - fw .. forward
    - bw .. backward
    - sc .. super capacitor
    - lead .. lead acid battery
    - liion .. lithium ion battery
- functions:
    - max
    - min
    - Sat
    - ResSat
    - SwDec, sdode
    - StdMode
    - SyncMode
    - mirror
    - reverse


### 1 Introduction and motivation

- general bla bla, need for storages
- storages expensive, best possible utilisation needed
- better utilisation by combination/hybridisation

- in studies, mostly focoused on specific applications and technology
  combinations
- mainly sc and li-ion, and automobile or photovoltaik
- rather specific goals, like investigating power electronics topologies or
  control strategies
- no general top level view
- While other theories/studies imply a favourable use of hybrid storage with a
  certain size and certain strategy and say, it is quantatively better for this
  application, this theory investigates the potential and helps finding a good
  combination, starting point
- Hybrid storages are multivariable optimizations, where in other studies most
  of these variables are implicitely fixed or weighted with a cost function and
  somehow hidden. This way, these studies are hardly comparable and the design
  process is not generic.
- Different aims of hybridisation, mostly costs, or lifetime extension by peak
  power cuts
- focussing on dimensioning, control and topology combinded seems reasonable
  since they all interact one with another, yet it blures tho view for a
  comprehensive design

- Dimensioning is only a consequence, not considered solely
- therefore, aim of this paper: application, technology and control strategy
  free investigation of hybridisation potential, analytic which only focusses
  on theoretical possible dimensioning
- aim is to split a theoretical e/p ratio in two other e/p ratio, which might
  be nearer to real ones
- thorough description/presentation of idea in following 2nd chapter, 3rd
  chapter provides mathematical and modelling background. 4th is expansion to
  an economical formulation and adaption of the problem, or a mapping of
  theoretical results to specific, 5th is application to common problems in
  other studies, pulsed and nefz, 6th are some loosely gathered notes, 7th is
  conclusion and summary


### 2 General theory description

#### 2.1 idea and aim

- structure of description first, math later because: otherwise the whole
  purpose and value only expresses itself after several pages and may get lost
  in between
- calculation and formal introduction is deferred to to next chapter, as well
  es prove and formal introduction of assumptions, for now, idea is presented
  to better follow math derivations in next chapter, and resulting insights

- for a given arbitrary signal or load profile for one period, an ideal storage
  with power and energy (independent of soc), without losses can be easily
  calculated by determining min/max power and max of integral
- to hybridize this storage, insert two storages - base and peak where base has
  a specific fraction of the single power, and peak the difference
- hybridisation always leads to same dimension in power as single
- with these powers, following verbal strategy is applied: charge only when
  neccessary, i.e. when input power exceeds the power of base (or soc_peak is
  not high enough in case of coming demand) and discharge whenever possible
  with as much as possible. This is the case for reloading mode; exception:
  synchronized mode: if tau_full is equal, switch to synchronize mode to
  prevent overcharging of base
- this way, for a given ratio chi = base/total power, the total energy needed for
  peak becomes as small as possible
- moreover, with this method, the addition of energy also equals single storages
- doing this for various chi from 0..1 leads to distinct line

#### 2.2 Major insights 

- THEOREM: with this, the single storage with E/P collapses into 2 other E/P
  ratios, which are spread as much as possible for given chi as long as
  overdimensioing is forbidden
- also, a hybrid storage can never be smaller, or: 2 can never be better than
- one, but within the limits always as good there is a distinct line separating
- what works, and what does not work Leaving line leads to overdimensioning


#### 2.3 Proposal Showing/Explaining resulting diagram, characteristic parameters

- as mentioned, the resulting tuples of base/peak with dependency on chi can be
  plotted in e/p diagram, like fig 1

- fig 1 caption: Hybridisation curve in p/e diagram; note the two coordinate
  systems, where the first 'normal' one represents base storage, and the second
  one is rotated by 180 deg and tranlated to the point of the single storage
  for peak. For given power cut chi, the base and peak storage sizes can be
  read in the according coordinate systems

- figure shows 3 lines. dotted one is isochrone of ideal single storage.
- at the end, a second coordiante system starts pointing in opposite diretions.
  this is peak coordinate system where dimensions of peak can be read, while
  the first is base coordinate system, where dims of base can be read
- solid line marks for given chi the base/peak storage tuple which with a
  maximum spread in energy. this means the peak storage size is as small as
  possible to fullfill the requirements of the signal. a further reduction is
  not possible since there is a high power demand which can not be covered by
  base which has this energy when integrated
- dashed line is similar, but this marks the border which is reachable, when
  power flow between storages is forbidden, this means, peak can only be
  charged, discharged from signal, not from base, or: peak cannot discharge its
  energy into base
- a tuple of storages can be read as follows: choose a point at curve. this
  point implies a certain power cut chi and mark a p/e tuple of both base and
  peak in the corresponding co-system and can be read at the axis
- e.g. like in this example, the cut chi=0.25 can be reached with base storage
  of p = ..., e = ..., read at left and low axis, and peak storage of p = ...,
  e = ..., read at top and right axis
- dotted and solid, respectively dashed line, enclose an area Ia and Ib. all points
  within are base/peak tuples, which can satisfy the signal, all points outside
  in area IIa and IIb cannot be reached without violated the demand of not
  overdimension the hybrid system
- top left corner visualizes the corresponding signal in time/p(t) diagram.
  Moreover integral values to characterize this signal, form and crest, are
  provided and a function definition.
- below p(t) diagram, a few integral paramters describing hybridisation curve
  are provides. These are defined and explaind at end of subsection

- can degenerate for some signals,
    - for rectangular signals, it becomes a straight line equivalent to single
      storage, since energy and power are always proportional and takeover of
      high power parts do not lead to reduction in energy
    - for sinus-like signals no recharging possible
    - for signal with dirac like impulse and infenitesimal base - curve
      degenerates to rotated L, maximum hybridisation
    - for signals with discrete power steps - discontinuities in hybridisation
      curve, respectively kink in curve

- with this diagram alone, a visual representation of the hybridisation
  potential is given
- can be expressed mathematical as integral and specific values
- hybridisation factor H(chi) = (base(chi)/peak(chi))_(e/p)
    - between 1 and inf, where peak e/p is H times larger than
- hybridisation potential ^01H = int H(chi) d chi
    - integral form, between 1..inf
- maximum hybridisation factor ^maxH(chi=..)
- reloading factor R(chi) = peak_wo/peak_w(chi) - 1
- reloading potential ^01R = int R(chi) d chi
- maximum hybridisation factor ^maxR(chi=..)


#### 2.4 Limitations, assumptions, not considered

- ideal storage with no losses, power and energy independent of soc
- no distinction between charge, discharge power
- nonidealities (like P(E), respectively P(SOC), E(d/dt E) (Ragone)), losses
- nonuniform signals (integral not zero), makes sense since ideal, but for load
  profiles where storage can choose and dump problematec, now storage is forced
  to take input
- aging, cycle load on storages
- for complete arbitrary signals, a complete knowledge of future is needed,
  which makes the strategy somewhat theoretical and impossible to
  apply/implement, not as problematic, since it is only meant as benchmark
  possibility, and the real implementations performance can be compared to that

#### 2.5 Value, how to use

- predimensioning
- determining potential
- does not contradict previous work, only abstracts problem and gives insight
  on the nature of the problem
- theory is analytical and complete. It does not cover many real life problems
  (aging, transients, losses, P(E), physical dimensions, costs, power
  electronic architecture, thermal aspects).
- Simplifications allow unifying dimensioining and design process for small as
  well as large problems, mobile and stationary
- Even if it only provides a good starting point for an optimization, it does
  have value
- can verify applications.
- can be plotted with a lot of technologies for a first cost estimation for
  each technology pairing
- can be used as a design variable within many other design variables in
  multivariable optimization
- The investigations are more or less control strategy free, separating design
  process
- With this, it is easier to see trade offs between overdimensioning, aging,
  transients, costs, losses, power-energy spectrum, spectrum analysis, and so
  on (Paper 2), while in other papers a parameter sensitivity or influence is
  often disguised since general optimizations only output costs, which are
  weighted and calculated up infront
- These analysis can help finding the right control strategy, or tuning a
  specific one


### 3 Model and Math behind, Formal explanation/description

- aim: find set chi mapsto ep,eb,pp,pb in a way, that ep becomes minimal
- two storages must take the same power as single storage for all times
- it follows: hybrid system always has the same combined soc as single storage,
  and there must be a at least one point within period, where both storages are
  completely full
- chellenge: find dimensions/pairing and control strategy in a way, that no
  storage 'drops out' because its full, while power is still required

Assumptions

- signal is periodic, 'makes sense' and no hard restriction
- storages are ideal with no losses and load = discharge power
- storages are forced to take signal, no possibility to 'dump' power
- it follows: integral (energy) of one period is zero
- integral at beginning, and therefore end of period is zero, can be always
  achieved by shifting signal

Dimensioning

- power dimenioning simply: p_peak = 1-chi p; p_base = chi p
- ensures that p_hybrid = p_single
- peak storage must take all signal parts larger than p_base (or lower -p_base,
  respectively)
- separate treatment of positive and negative load requirements to find minimum
  peak dimension
- for this: switched decay ode = ...
- with build = ResSat fcn (with ResSat = ...)
- decay = ....
- this is an ode which conditionally chooses if f_build or f_decay is being
  integrated; build and decay chosen in a way that: only positive integrating
  when needed and not more than needed; always negative integrating when
  possible with as much as possible as long as integral is larger zero
- it is possible, that required energy for discharging event is larger than
  charging event, therefore: applying same ode to mirror(reverse(fcn))
- the decay function has to possibilities: first one: power of base is
  incorporated, this means, peak can discharge into base, so a power flow
  between the storages can exist; second one: not allowed, peak must wait with
  discharge until the input signal becomes negative
- the working sdode is visualized in fig 2

- Fig 2 Example decay ode for determining minimal e_peak dimension w/ (top) and
  w/o (bottom) recharging for chi = 0.5; ResSat is applied to input signal p -
  if larger zero: positive integrate, if zero or lower: negative integrate
  decay; differences in w/ and w/o marked and commented

- with this, e_peak determined by ... max(sdode)
- and e_base = single - peak


Control
- The realization of the control is presented in blcok diagram, fig 3

- Fig 3 control strategy block diagram; standard reloading mode which ensures a
  minimum usage of peak storage. Peak requests its discharging power, if it
  actually can, depends on current input power; Storages will switch to
  synchronized mode, when base is nearly full, to prevent dropping out

- has a standard reloading mode and a synchronized mode depending on variables
  tau_peak and tau_base
- assume we are in standard mode: it realizes the load when needed, discharge
  when possible strategy
- peak requests to discharge if soc_aim = 0 and soc_peak greater 0, if it actually
  can discharge, depends on the input power
- vice versa if aim = 1 and actual lower 1
- soc_aim is controlled by future power/energy demands, which are known by the
  result of the backward integral previously calculated; if current soc_peak is
  going to drop below bw integral, it will switch its aim to 1 until its again
  larger. This means: future knowledge is needed for general signals; if the
  signal has a distinct charging and discharging period, without intermediate
  sign changes, the soc_aim change only becomes active when storage is full,
  and the future knowledge is not needed
- this standard mode will make problems at the end when combined hybrid storage
  becomes fully charged. It will cause peak to discharge into base even if it
  is nearly full - then base is full and cannot provide power anymore,
  decreasing the power of the overall system, and a high power demand cannot be
  handled anymore. Therefore, the 'time until storage is full' of both storages
  is evaluated, if base full will happen earlier than peak full, the control
  strategy switches to synchronized mode, where power is distributed evenly
  between storages, weighted by the ratio of individual powers (chi)
- This control can be mathematically expressed by: ...
- fig 4 shows the individual phases for an example signal, it can be seen that:
    - at time .. peak must take the ResSat Signal. right at this time, it
      starts to request its discharging, but cannot and must wait until time
      ..; Later at time .. it switches to soc aim 1, because the bw integral
      signals an incomming discharge event and ensures, that peak has enough
      energy to provide the discharging power. at point .. base becomes nearly
      full and storage switches to discharging mode. at time .. storages switch
      back to reloading mode; at time .. again, peak needs to charge because of
      bw integral. It can be seen, there is a distinct moment, when both are
      full, and are empty at beginning and end

- Fig 4 Power distribution between storages for an example input signal. The
  individual states and phases of the currently active control strategy are
  marked

- The control strategy will always work, but can lead to unneccessary
  charge/discharge events for peak.
- This will be unwanted in reality, since it increases losses
- strategy is not meant to be optimal, only to provide minimal instruction set
  to ensure theoretical working
- It still works, when e_peak is dimensioned larger than needed (and base
  smaller by that amount). It will fall into synchronized mode earlier to
  balance the energies.


### 4 Economic choosing ?how to use/and application within design process?


- area within the hybridisation line and single storage isochrone give possible
  tuples of base/peak storages
- in reality, only distinct technology lines are available limiting the choice
- Which chi to choose depends on real e/p of available technologies (and signal)
- for each chi, an optimal base/peak tuple can be determined, for some chi,
  multiple tuples (pareto front) can be found, for others only one.
- there can be 1 point maximum, which does not lead to an overdimensioning in
  power or energy, otherwise to realize a chi within hybridisation area with
  concrete technologies, will most likely lead to overdimensioning

- Fig 5: construction of minimal pairing for defined storage isochrones;
  pairing I: optimal chi_cross without overdimensioning; pairing IIa and IIb:
  optimal for chi lower chi_cross; overdimensining in power, pareto front;
  pairing III: optimal for chi greater chi_cross, overdimensioning in energy,
  no pareto front, single solution; pairing IV: if both isochrones outside:
  overdimensioning in both energy and power, no pareto, single optimal solution

- explanation of fig 5
- isochrones always have a intersection 
    - within field: there exists a point without overdimensioning
    - overdimensiong in only one dimension (power when below crosspoint),
      energy when above cross point (only when crosspoint within
    - outside field: no chi without overdimensioning

    - below intersection and base is innermost line: "drive along at base" -
      find for one base size the corresponding peak size, this is where peak
      isochrone intersects with base storage rectangle. The found dimensioning
      can be operated for all chi at found vertical line between base an hybrid
      line or base and peak line (smaller one); which one to choose: p/pmax of
      both can be tuned; costs: take lowest chi; leads to overdimensiong in
      power
    - at intersection and intersection is within hybridisation area: optimal
      point from "dimension point of view", no overdimensioning
    - above intersection and peak is innermost line: "drive along at peak" -
      find for one peak size the correspoinding base size, this is where base
      isochrone intersects with peak storage rectangle. Only one chi at which
      storage pair can be operated, but max depth of discharge can be tuned
      along all points between peak and base or peak and hybrid (smaller one);
      leads to overdimensioning in energy
    - hybrid line is innermost line: go horizontal to base to find minimum base
      for chi; go vertical to find peak to find minimum peak for chi;
      overdimensioning in both energy and power; not neccessarily worse area,
      in contrary, if intersection point is outside, optimum will be in this
      area

    - short: from innermost line: map to next base and peak

- results of this construction can be represented in extension of fig 1, like
  shown in fig 6
- for every power cut the dimensions of the best storages for given isochrones
  are plotted in overdimensioning diagram right next to hybridisation diagram;
  dims are normalized with single storage dim - show overdimensioning: right
  direction in energy, left direction in power
- can be plotted for each pairing, but only the most interesting/smallest one
  is plotted for a given chi
- a few things can be seen, as mentioned in construction in diagram above:
  below intersection (chi=x..y), power is overdimensioned, while energy is not,
  above: vice versa (chi=x..y); at chi=x..y where both curves are outside of
  hybridisation curve: both are overdimensioned, but nevertheless,
  added/overall becomes minimal
- when costs are known, a cost(chi) diagram can also be plotted, again,
  dimensionless and normalized with minimal cost in right diagram. Note: with
  costs, the smallest pairing with respect do overdimensioning is not
  neccessarily the cheapest pairing, if this is not the case and the costs do
  not correspond to the dimensions in diagram left to it, the area is darkened.

Fig 6: Overdimensioning and cost curve; left diagram is original hybridisation
diagram; middle shows overdimensioning in power and energy dimension
(horizontal axis) depending on chi (vertical) axis and right diagram shows
costs with respect to chi. Both diagrams are normalized and dimensionless


### 5 Examples 'Real Life'

- pulsed signal: see diagram economic choosing above, with the following
  parameter: ...; explain a little bit, interesting because analyzed for sc-bat
  combinations in many studies and allow another point of view, compare liion,
  lead and sc
- nefz, interesting because integral is nonzero and often analyzed in other
  studies, compare liion, flywheel, sc; alternative: pv
- TODO: edvance further, new insights
- Fig 7: eco diagram for nefz; TODO generate, caption


### 6 To mention, Final notes and comments; or: Appendix

- Analytical derivations of leaf form performed, but not a valid assumption,
  Form and Crest give hint of hybridisation ability
- theory can be done for different chi_charge/discharge - incorporate in theory
  and diagrams - there is a maximum and minimum chi ratio! (dependent on
  current chi?)
- cascading storages
- toolbox


### 7 Conclusion and Summary

- paper introduces theoretical concept to calculate minimal set of storage
  pairings for a specific signal/problem in a sense that added power and energy
  of both storages always equals single storage and that for given power ratio,
  a maximum spread of energy content of both storages is achieved
- For This a hybridisation diagram is proposed as well as integral
  hybridisation factors.
- A the dimensioning approach is layed out and a control strategy provided,
  which will work for this dimensioning
- The theory is expanded by an economical choosing strategy, if it will be
  applied to distinct storage technologies
- This is applied to an nefz example, showing ... new insight
- Main drawback is the theory is its theoretical nature, needing ideal storages
  and an omniscient control strategy
- But it can serve as a predimensioning and preselection tool, as well as
  signal potential analysis for hybridisation and a benchmarking result for
  comparision of real implementations.


### References

- needed for theory: 0-2
- needed for classification within field of research (introduction): 5-15
- needed for tell story in examples 5-10
