Informal Introduction 
=====================

This file informally discusses the background of the theory and explains how to
read and interpret the results. For details and precise information, see the
scientific documentation `scientific.md`


Setting
-------

Suppose you have a network structure with some loads, renewable energy and grid
connection which is complemented with a storage as shown in the following
picture.

![Example Network](_informal_introduction/network.svg)

An energy management system now calculates a storage profile $$P(t)$$ to achieve
a goal like maximising solar coverage, domestic consumption, grid peak power
limiting or others. For this theory, it is not of importance what goal is aimed
or how the storage profile is determined. This must be subject a preceeding
analysis. All that matters is that a storage profile is generated that may look
like this:

![Storage power and energy profile](_informal_introduction/signal.svg)

This will be the starting point for the following considerations.


Motivation ----------

In the previous figure, the maximum power $$P_s$$ and maximum energy $$E_s$$ are
indicated. Optimally, a storage would have exactly these power and energy
capacities as this would be the minimum dimensions to fulfil the requirements of
the signal. They can be plotted in an $$E-P$$-diagram:

![Storage in E-P plane](_informal_introduction/04_hybrid.svg)

The storage has a specific power $$P_s/E_s$$ indicated as the violett diagonal
line. It is unlikely, that a real available storage has exactly the demanded
specific power. As shown in the following figure, it is either too low (green
line) or too high (red line).

![Storage in E-P plane with differing specific power
lines](_informal_introduction/05_hybrid.svg)

The minimal possible storage with the low green specific power would have the
following dimensions, to match the power requirement $$P_s$$:

![Storage in E-P plane, low specific power
storage](_informal_introduction/06_hybrid.svg)

As can be seen, there must be additional energy capacity installed, which will
not be used:

![Storage in E-P plane, additionally allocated energy
capacity](_informal_introduction/07_hybrid.svg)

The same principle applies for the the storage with the high red specific power.
It must match the energy requirement  $$E_s$$:

![Storage in E-P plane, high specific power
storage](_informal_introduction/08_hybrid.svg)

Then, there is additional unused power capacity installed:

![Storage in E-P plane, additionally allocated power
capacity](_informal_introduction/09_hybrid.svg)

As storages are expensive, this is something that we don't want since the
additionally needed overdimensioning comes with additional costs. Therefore, it
is aimed for an hybrid energy storage system, i.e. a combination of two
different storages with two different specific powers, to achieve an overall
system which matches the desired specific power. In the following, it is shown
how its done.


Hybridisation Approach
----------------------

First, we zoom a little bit into the original diagram and remove the
elaborations for the high and low storage:

![Storage in E-P plane, with differing specific power
lines](_informal_introduction/10_hybrid2.svg)

Now, we perform a parallel translation of the red high specific power line in a
way that it intersects the point $$(E_s, P_s)$$ of the original single storage.

![Parallel translation of high specific power
line](_informal_introduction/11_hybrid2.svg)

In the next step, we construct a green vector along the low specific power line
until the intersection with the parallel translated high specific power line.
From this point on, we continue along the red dotted high specific power line
until we meet the point of the single storage:

![Substitution of original single storage with two hybrid
storages](_informal_introduction/12_hybrid2.svg)

What do we have accomplished now? We substituted a low power green storage,
which is overdimensioned in power, or a high power red storage, which is
overdimensioned in energy, respectively. Now we have a small green storage and a
small red storage with their dimensions adding up to the dimensions of the
original single storage.

You might think something like "Wait, all you did is a simple vector addition
and now you claim that this is some sophisticated methodology to build a hybrid
energy storage system". You are right, for now it is just a simple vector
addition and it is daring claim that this will work.

What we do now is to use a magical algorithm that will be outlined later and
that analyzes the storage profile signal we saw in the beginning. The result is
a signal specific hybridisation curve that looks like this:

![Hybridisation Curve](_informal_introduction/13_hybrid2.svg)

The claim is now, that all storage tuples within the enclosed area, or at the
edge of this area, are valid and can be realised. In other words, if two
specific power lines intersect within this area, the simple vector addition can
be performed exactly how it was done above. If they intersect outside of the
enclosed area, it is not possible to do so without an additionally neccessary
overdimensioning. But we will come to that.

Be aware that no particular control strategy that distributes the input power
between the storages is specified. It is simply stated, that control strategies
exist that can do that. A control strategy that verifies that it works is
implemented within the toolbox, but there may be others that do the same and
perform better. But a further distinction can be made: There are control
strategies that allow a power flow between the storages (i.e. storage 1 can
charge storage 2 or vice versa), and control strategy that prohibit this (the
storages can only charge/discharge into the signal). For the last case, a second
Hybridisation Curve can be calculated:

![Hybridisation Curve w/ and w/o interstorage Power
flow](_informal_introduction/14_hybrid2.svg)

In the following figure, the information is a little bit rearranged. For the red
high specific power storage, a second coordinate system is introduced, starting
in the top right corner. The original coordinate system is now dedicated to the
green low specific power storage. The storages are now called base storage and
peak storage and the coordinate systems consequently base coordinate system and
peak coordinate system. The reason for the naming convention will become clear
later. The advantage of the two coordinate system is that both storage
dimensions can be easily read in their own coordinate system. At last, the
Parameters $$H = 0,57$$ and $$R = 0,10$$ appear now in the figure. The first one
is an integral formulation of the hybridisation potential. It is the normalized
grey area. The latter one describes the additional gain in the hybridisation
potential by allowing an inter-storage power flow.

![Example for Hybridisation Diagram](_informal_introduction/14v2_hybrid2.svg)

The hybridisation diagram can be used in this form to analyze multiple storage
combinations fast and efficiently:

![Analyze multiple storage technologies within one hybridisation
diagram](_informal_introduction/19_hybrid3.svg)

Here, two base storage technologies `b1` and `b2` and two peak storage
technologis `p1` and `p2` are analyzed. `b1` and `p1` were examined before, `b2`
and `p2` are new. 

![They intersect at different points](_informal_introduction/20_hybrid3.svg)

The storage specific power lines intersect with each other at 4 different
points. The combination `b1-p1` is optimally realised in `1`, combination
`b1-p2` in point `2`. Combination `b2-p1` can also be realised in `3`, but only
if an inter-storage power flow is allowed. Combination `b2-p2` cannot be
realised without adjustments, as the intersection `4` is outside the
hybridisation area. What can be done is to chose a point at the hybridisation
curve and map from it to the base and peak storage technology line as shown in
the following figure, but consider that the resulting system will be
overdimensioned again:

![Construction for intersections outside hybridisation
area](_informal_introduction/21_hybrid3.svg)

As mentioned before, the hybridisation curve is signal dependend. In the
following are a few examples, left uncommented.

![Sinusodial signal](_informal_introduction/sin.svg)

![Square signal](_informal_introduction/square.svg)

![Spikes](_informal_introduction/needle.svg)

![Tetris-shaped signal](_informal_introduction/tetris.svg)


Calculation Principles
----------------------

Only the principles of the calculation will be outlined. For details, see the
scientific documentation.

Let's take a rather simple and academic signal - A symmetric double triangle
pulse:

![Symmetric double triangle pulse](_informal_introduction/trisignal.svg)

Now, we introduce a power cut $$\chi$$ which is a fraction of the peak power
(absolute value), everything below this power cut is taken care of by the base
storage, everything above by the peak storage. The original single single
collapses into two separate signals - a base signal and a peak signal.

![Power splitting through power cut](_informal_introduction/splitsignal.svg)

All we did for now is a simple peak shaving or peak power reduction. But if we
integrate the separate signals and we can determine the maximum energy. Then, we
gain the separate storage dimensions and can draw them as vectors into the
previously introduced E-P-plane.

![Result in E-P-plane for power cut =
0.5](_informal_introduction/hybridcut05.svg)

The power and energy capacities of both storages still add up to the original
single storage, but what we gained now is a base storage with a lower specific
power, and a peak storage with a higher specific power.

Nobody says that we have to do the cut at $$\chi = 0.5$$, we can do it any other
point, e.g. at $$\chi = 0.25$$ or $$\chi = 0.75$$

![Power splitting at different power
cuts](_informal_introduction/splitsignal_2.svg)

Then, we gain different base/peak pairs but their dimensions still add up to the
dimension of the single storage.

![Result in E-P-plane at different power
cuts](_informal_introduction/hybridcutmultiple.svg)

When we do this for all power cuts $$\chi \in [0,1]$$, we gain the
characteristic hybridisation curve.

![1st Hybridisation curve for double triangle
signal](_informal_introduction/hybridcutcurve.svg)

Now we have a hybridisation curve that looks familiar to the previously
introduced. But what do we want to achieve? For a specific power cut (which
already determines the power capacities for base and peak storage), we want to
maximize the energy capacity of the base storage, and minimize the energy
capacity of the peak storage. Consequently, we minimize the specific power of
the base storage and maximize it for the peak storage. By doing so for all power
cuts, we maximize the hybridisation area. This is the final result we want,
because this enables us to solve the problem with more base/peak storage tuples
and the designer has more options to choose from.

So again, for a specific power cut, we want to maximize the base energy
capacity, and minimize the peak energy capacity. But is this the best we can do?
If we forbid the storages to charge/discharge one another, it is. So the drawn
curve resembles the hybridisation curve for an prohibited inter-storage power
flow. But what we can do is to discharge the peak storage into the base storage
as soon as the first peak of the double triangle signal has passed (and vice
versa in the second half of the period:

![Power split with reloading](_informal_introduction/reload.svg)

Doing this for all power cuts leads to a hybridisation curve again in the
E-P-plane:

![2nd Hybridisation curve with inter-storage power flow
allowed](_informal_introduction/tri_hybridcurves.svg)

This is now the final form of the hybridisation diagram including the curve with
an inter-storage power flow allowed. Of course, this is a really simple example,
but it shows the approach or principle. To make it applicaple for all signals, a
few things must be considered:

  1. Charge the peak storage only if neccessary, i.e. if the input power exceeds
     the power capacity of the base storage.
  2. Discharge it whenever possible, but not if the left energy in the peak
     storage is needed in future when a negative input power exceeds the power
     capacity of the base storage.
  3. Precharge the peak storage if a negative power demand, that exceeds the
     power capacity of the base storage, is anticipated (in future) to have the
     right amount of energy available for a discharging request.
  3. Prevent over- and undercharging of the base storage, or peak storage
  4. Do not exceed the power capacities of the storages.
  5. Handle the input signal at all times, do not curtail it.

How this problem is solved is subject to the scientific documentation. The
explanation is just enough to illustrate the idea behind the generation of the
hybridisation diagram.


Things kept secret
------------------

Of course, this toolbox is not a swiss-army knife for hybrid energy storage
systems and can in fact only be used as a pre-dimensioning tool. There are quite
a few things neglected.

  1. The storages are not subject to losses, neither stand-by nor efficiency.
     This is not a neccessary restriction, it's just not implemented at the
     moment. Even then losses must be linear (in the sense of the linear system
     theory)
  2. Nonlinearities in general cannot be efficiently handled (e.g. p =
     f(SOC)) within the methodology and must be neglected. A subsequent general
     optimisation can address these shortcomings. This toolbox can provide
     reasonable starting points for such a task, accelerating the calculation.
  3. System response times/slew rates are neglected and the storages are
     "infinetely fast".  This can be addressed by a subsequent analysis or
     control strategies that are superposed, e.g. low pass filtering.
  4. Cycle life, aging behaviour or operation costs cannot be examined
     efficiently. The toolbox may only be useful for a worst case estimation.
  5. The provided control strategy needs omniscient signal knowledge. Open to
     question is how a real life control strategy may look like.

What it can do instead:

  1. The fact that the calculation is done without an inherent control strategy
     may actually be an advantage, as it provides a benchmark that cannot be
     surpassed.
  2. The calculation is quite fast and provides an easy insight concerning the
     potential for hybridisation. Maybe the result is, that the application is
     not effectively hybridisable. Maybe it can be shown that deeper analysis
     will be profitable.
  3. It is not limited to specific applications.
  4. A quick overview of feasible technology combinations, including a
     predimensioning, is possible. This can provide reasonable initial values
     for subsequent analysis and optimisation.
