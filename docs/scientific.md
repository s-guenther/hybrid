latex input:    texpreamble.tex
Title:          Scientific Documentation


Scientific Documentation
========================

Last Update:
Thu 29. Sep 2016


Outline
-------

- Theory Description - 
  Leaf theory description, proposed leaf diagram, summary, purpose, findings
- Signal Parameters - 
  Properties and characteristics
- Investigated Signals - 
  Parametric signal study w/ resulting leaf diagrams
- Data Fitting - 
  Efforts to find analytical description of leaf
- Results - 
  Major insights and discoveries
- Open Questions, Not Analyzed - 
  Not considered and investigated aspects
- Short Toolbox Description - 
  Quickstart/How to get started with program code
- Development History/Git Log Summary - 
  Short chronological description of work
- Project Folder Tree - 
  File Structure in Folder


Theory Description
------------------

- Idea: divide every incomming signal, respectively storage profile, into base
  and peak signal, handed to a base and peak storage.
- The signal is divided at a specified power cut, which is a fraction of the
  maximum peak power. Everything above this cut is handles by the peak storage,
  everything below by the base storage.
- No complicated operating strategy or model prediction neccessary. Works
  without dynamic/history.
- Works on every artificial and real signal. At the moment: point symmetric
  signal needed, rendering the discharge phase equal to the charging phase.
  This prevents a separate treatment and simplifies the matter for first
  insights into the problem.
- Strategy ensures that the added power and energy of the hybrid storage is
  always equal to a single storage solution.
- With this strategy, the split signals usually have another power to energy
  ratio than the original complete signal. For the peak storage, it is higher,
  for the base storage, it is lower. Depending on the input signal, and
  depending on the cut off value, the spread between original and divided power
  ratios gets higher or lower.
- This relationship can be represented in a power(energy) diagram, the lines
  build a leaf-alike shape. As peak storage size increases, starting from the
  lower left, base storage size decreases, starting from the upper right. A
  typical shape can be seen below

![][fig:leafsin]

- This basic leave shape can degenerate for certain signals:
    - To a line: Square wave input, there is no spread for peak an base
      as both always have the same power/energy ratio as the original single
      storage
    - To a diamond: for l_shaped and step like discrete functions
    - To a square: For an impulse like signal with a remaining base power:

![][fig:leafsquare]
![][fig:leaftetris]
![][fig:leafimpulse]

- Every point in diagram is calculated via simulation, making the generation
  expensive.

- Idea: Signal can be described by a few key parameters:
    - Root Mean Square (RMS),
    - Average Rectified Value (ARV),
    - Form Factor (F) or
    - Crest Factor (C)
  which are sufficient to fully describe the leaf shape
- Turned out to be invalid or not sufficient: Signals found with identical
  parameter but different leaf shape
- New Idea: sorted power profile contains all information needed for leaf shape
- Questionable if there is any numerical advantage

- Theory must be extented to allow non-symmetrical input signals.
- Theory must be extented to allow inter storage power flow.


Parameters
----------

- Average rectified value, ARV
    - \\( \overline{|x|} = \frac{1}{T} \int_0^T x(t) dt \\)
    - Only used indirectly in Form Factor
- Root mean square, RMS
    - \\( X = \sqrt{\frac{1}{T} \int_0^T x^2(t) dt} \\)
    - Only used indirectly in Form and Crest Factor
- Crest Factor
    - \\( C = \frac{\hat{x}}{X} \\)
    - Ranges from 1 to infinity
    - Tendency:
        - Low Factors: little spreading potential, narrow leaf shape
        - High Factors: high spreading potential, strongly pronounced leaf
          shape
- Form Factor
    - \\( F = \frac{X}{\overline{|x|}} \\)
    - Ranges from 1 to infinity
    - Tendency:
        - Low Factors: little spreading potential, narrow leaf shape
        - High Factors: high spreading potential, strongly pronounced leaf
          shape
- Total Harmonic Distortion, THD
    - \\( THD = \frac{sqrt{U^2 - U_1^2}}{U} \\)
    - Not considered in investigation


Investigated Signals
--------------------

- Distorted Sinus Shapes
    - ![][fig:sinnarrow]
    - ![][fig:sinnormal]
    - ![][fig:sinbulky]
- Triangle shaped signal
    - ![][fig:trinarrow]
    - ![][fig:trinormal]
    - ![][fig:tribulky]
- Step-like, l-shaped, tetris-shaped, square, pwm functions
    - ![][fig:square]
    - ![][fig:pwm]
    - ![][fig:tetris]


Data Fitting
------------

### Neccessary conditions

- Tested trail functions must fullfill: exact agreement at boundaries of leaf
  diagram (or transformed leaf diagram)
- (E,P) data was scaled to (1,1) and (0,0) at corners
- In best case: functions are not even defined outside this range

### Eligible functions

- Trigonometric functions sin, cos, tan, asin, acos, atan
- Hyperbolic functions sinh, cosh, tanh and arcus fcns
- Exponential and logarithmic functions
- Polynomials, power and root functions

### Fitting Attempts

- Untransformed coordinate system
    - Root Functions \\( \sqrt[n]{f(E, \pi)} \\)
    - Combined with Trigonometric \\( \sin^n({\frac{\pi}{2}E, \pi)} \\)
    - Also satisfy limit F=1 (simple linear function) and F = infty (sqaure)
    - Polynomials do not fulfill boundary conditions in all circumstances
    - Within boundaries: non-removable deviations, function does not represent
      shape exactly

- 45 degree rotation, translation to mid, scale to (-1,1)
    - sin/cos shaped functions, sinh, cosh, stretched in between, nevertheless,
      no satisfying results
    - Limits: zero line if F/C = 1, Triangle when F/C = infty

- polar coordinates
    - last coordinate transformation was further transformed into polar coordinates
    - leaf ranges between -pi/2 and +pi/2
    - cosh-alike shape, but no formulation found to exactly meet data
    - Limits: for F/C = 1 cosh degenerates to 1 at boundaries and zero in
      between; for F/C = infty: 1 at boundaries and 0 deg, 0.71 at +-pi/4,
      cos-alike shape in between

- 45 degree rotation, bending curve approximation
    - Idea: shape looks after 45 deg rotation like a bending curve of a beam
      an asymmetric application of force
    - bending line is definied as two functions, left and right to application
      of force
    - Problem: peak of bending line is always between ca 0.4 to 0.6,
      independent of point of application of force, but the range of the leaf
      shape is larger -- inadequate approximation

- analytical
    - observation: leaf degenerates to a diamond shape for l-shaped or
      step-like signals
    - idea: the maximum of this step can be derivated analytically and can be
      correlated analytically with Shape and crest factor
    - The following relationship can be found implicitly found:
      (C,F) |--> (E_peak, P_peak) |--> (x_max, y_max) |--> leaf shape
      which holds true for every signal with this distinct step
    - does not hold true for other signals, although results are of the same
      magnitude

- two signals with identical para but other leaf shape found:
    - ![][fig:identstep]
    - ![][fig:identtri]
    - disproves theory that there is a simple relationship between (C,F) and
      leaf shape

- the first 3 approaches are not completely investigated and __may__ be still
  adequate to describe the leaf shape, but a functional relationship was not
  found


Results
-------

- The sum of e/p of two storages is always equal to e/p of the single storage
- the e/p ratio of each individual hybrid storage is for one higher, for the
  other one lower than the ratio of the single storage
- The spreading potential of the hybrid storage solution depends on the input
  signals
- Higher C, F values generally lead to more potential
- In its extremes, the leaf shape is a straight line or a square. Everything in
  between is possible.
- Base leaf and peak leaf a point symmetric and rotatable by 180 deg. around
  the mid point of the leaf (in normalized coordinates: around (0.5,0.5))
- The corresponding base/peak pairs can be found by rotation of a straight line
  around this mid point; a pair is a the two points of intersection
- The single functions of the leaf are strictly monotone
- Analytical formulation can be found for a class of signal shapes, but
  different classes have different shapes, while having identical signal
  parameters
- A sorted load profile should allow a functional relationship to generate the
  leaf shape


Open Questions, Not Analyzed
----------------------------

- Cascaded hybrid storages, leaf in leaf for more than two storages
- Thesis: Every Point/Pairs within leaf should be reachable, but this requires 
  modified operation strategy. This strategy should be comparibly simple and
  dumb.
- The area within the curve could be a measurement for the
  spreading/hybridisation potential.
- Generation of leaf with a sorted load profile.
- Is leaf most practical visualisation or are there better representations
- Inter storage energy flow was not considered, proposed parameter
- Non symmetrical signals may make this energy flow neccessary
- Number of cycles of storages are not reduced with this operational strategy


Short Toolbox Description
-------------------------

- Function hybrid_leaf calls main and gathers complete calculation
    - call: result = hybrid_leaf(input_signal)
    - in: struct with
        - fcn: function handle of signal
        - period: period of signal
        - amplitude: amplitude of signal
    - out: struct with
        - single: struct with single storage parameters (energy, power)
        - hybrid_table: leaf shape with
          cut_off_power | energy base | energy peak | power base | power peak
          columns
        - transformed: as hybrid_table, but with rotated and scaled data
        - parameter: form, crest, rms, arv, amv
        - peak: (x,y) max in transformed data
        - theo_peak: theoretically calculated peak
- Visualize results with plot_leaf or plot_transformed
- Most samples in `sample/` executable w/o arguments


Development History/Git Log Summary
-----------------------------------

- Simple numerical calculation for single storage
- Simple numerical calculation for hybrid storage, based on single storage
- Simple plotting functionality
- First leaf investigation, failed fitting them w/o coord transformation in
  cli
- Bending Line Approximation (w/ 45 deg rotation), and polar transformation in cli
- Refactored sequential programming to modular functions
- Pretty Output w/ additional info
- Parametric Study w/ Triangular fcns
- Parametric Study for other functions: tetris, l-shape, distorted sin, pwm
- High resultion study
- Automated coord transformation + peak finding interpolated
- Study of diamond shaped leafs (l-shape input fcns)
- Simple automated processing script to analyze shape, crest functional
  behaviour
- Analytical calculation for l-shape


Project Folder Tree
-------------------

```
.
|-- docs
|   |-- beginning.tex
|   |-- hybrid_leaf.md
|   |-- quickstart.md
|   |-- scientific
|   |-- scientific.md
|   |-- scientific.pdf
|   `-- scientific.tex
|-- hybrid_leaf.m
|-- LICENSE
|-- log160926
|-- project
|   |-- add_theo_peak.m
|   |-- auxiliary
|   |-- calc_hybrid_storage.m
|   |-- calc_single_storage.m
|   |-- coord_trans_result.m
|   |-- main.m
|   |-- plot_leaf.m
|   |-- plot_transformed.m
|   |-- signal_parameters.m
|   `-- transform_and_peak.m
|-- README.md
|-- REQUIREMENTS.md
|-- sample [17 entries exceeds filelimit, not opening dir]
|-- scihtml.html
|-- test
|   `-- test_main.m
|-- test_hybrid_leaf.m
`-- todo.md

6 directories, 24 files
```


[fig:leafsin]: scientific/leafsin.png "Leave Diagram of a Sine Curve"
[fig:leafimpulse]: scientific/leafimpulse.png "Leave Diagram of an Impulse-like Curve"
[fig:leaftetris]: scientific/leaftetris.png "Leave Diagram of a L-Shape/Step Curve"
[fig:leafsquare]: scientific/leafsquare.png "Leave Diagram of a Square Curve"
[fig:sinnarrow]: scientific/sinnarrow.png "Leave Diagram of a narrow sine Curve"
[fig:sinnormal]: scientific/sinnormal.png "Leave Diagram of a Sine Curve"
[fig:sinbulky]: scientific/sinbulky.png "Leave Diagram of a Bulky Sine Curve"
[fig:trinarrow]: scientific/trinarrow.png "Leave Diagram of a narrow triangular Curve"
[fig:trinormal]: scientific/trinormal.png "Leave Diagram of a triangular Curve"
[fig:tribulky]: scientific/tribulky.png "Leave Diagram of a bulky triangular Curve"
[fig:square]: scientific/square.png "Leave Diagram of a square Curve"
[fig:pwm]: scientific/pwm.png "Leave Diagram of a pwm Curve"
[fig:tetris]: scientific/tetris.png "Leave Diagram of a tetris Curve"
[fig:identstep]: scientific/identstep.png "Step w/ parameter a = 0.5"
[fig:identtri]: scientific/identtri.png "Triangular Signal w/ parameter a = 0.25"
