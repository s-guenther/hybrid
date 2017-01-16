latex input:    texpreamble.tex
Title:          Presentation


Konzept Hybrid Speicher Dimensionierung via Peak/Base Signal Separation
=======================================================================


Mathematische Formulierung punktsym. Signale ohne Vorzeichenwechsel
-------------------------------------------------------------------

### Dimensionierung und Betriebsführung ohne Umladen

\\[
    \chi \mapsto \left( \hat{e}_{base}, \hat{e}_{peak}, \hat{p}_{base}, \hat{p}_{peak} \right)
\\]

\\( \chi \\)... Prozentualer Cut vom Eingangssignal (von Maximaler Amplitude
\\( \hat{p} \\)), bei dem Base u. Leaf getrennt wird.

\\[ 
    \hat{p}_{base} = \chi \cdot\hat{p} \qquad 
    \hat{p}_{peak} = (1 - \chi) \cdot\hat{p}
\\]

\\[ 
    \hat{e}_{base} = \int_{t_0}^{t_0 + T/2} p_{base}(t) dt = \int_{t_0}^{t_0 +
    T/2} Sat(p(t), \hat{p}_{base}) dt
\\]
\\[ 
    \hat{e}_{peak} = \int_{t_0}^{t_0 + T/2} p_{peak}(t) dt = \int_{t_0}^{t_0 +
    T/2} ResSat(p(t), \hat{p}_{base}) dt

\\]

dabei: \\(t_0\\) derart, dass \\(\hat{e}(t_0) = 0\\)

und: \\(e(t)\\) monoton: \\( e(t) \leq e(t + dt) \quad \forall t \low
        \frac{T}{2} \quad\land\quad e(t) \geq e(t + dt) \quad \forall t \geq
        \frac{T}{2}\\)

und: \\(p(t)\\) punktsymmetrisch: \\( p(\frac{T}{2} + t) = -p(\frac{T}{2} - t) \quad\forall t\\)

und: \\(p(t)\\) periodisch: \\( p(t) = p(t + T) \quad\forall t\\)

mit:

\\[
    Sat: (a,b) \mapsto a^\ast
\\]
\\[
    a^\ast = max\left( min(a,b), -b \right)
\\]

und:

\\[
    ResSat: (a,b) \mapsto a^\ast
\\]
\\[
    a^\ast = b - Sat(a, b)
\\]

Betriebsführung entspricht Dimensionierung mit unbestimmten Integralen.


### Dimensionierung mit Umladen

\\[ 
    \hat{p}_{base} = \chi \cdot\hat{p}
\\]

\\[ 
    \hat{p}_{peak} = (1 - \chi) \cdot\hat{p}
\\]

\\[
    \frac{d}{dt}\begin{pmatrix}e_{base}\\e_{peak}\end{pmatrix} = 
    \begin{pmatrix}-p_{base}(p(t), e_{peak})\\-p(t) - p_{base}(...)\end{pmatrix}
\\]

mit:

\\[
    p_{base} = Sat(p_{base}^{virt}, \hat{p}_{base})
\\]

dabei:

\\[
    p_{base}^{virt} = - p(t) - p_{peak}^{request}(e_{peak})
\\]
\\[
    p_{peak}^{request} = \hat{p}_{peak} \cdot (e_{peak} > 0)
\\]

Löse ODE von \\(0..T/2\\)

\\[
    \hat{e}_{peak} = max(e_{peak}) \qquad \hat{e}_{base} = max(e_{base}) - \hat{e}_{peak}
\\]


### Betriebsstrategie mit Umladen

\\[
    \frac{d}{dt}\begin{pmatrix}e_{base}\\e_{peak}\end{pmatrix} = 
    \begin{pmatrix} -p_{base}(t, p(t), e_{base}, e_{peak})\\
                    -p_{peak}(t, p(t), e_{base}, e_{peak})\end{pmatrix}
\\]

mit

\\[
    \begin{pmatrix}p_{base}\\p_{peak}\end{pmatrix} = 
        StdMode() \cdot (\tau_{peak} \low \tau_{base}) + 
        SyncMode() \cdot (\tau_{peak} \geq \tau_{base})
\\]


#### Standard/Reload Mode
\\[
    e_{peak}^{aim} = 0 \cdot (t >= T/2) + \hat{e}_{peak} \cdot (t >= T/2)
\\]
\\[
    p_{peak}^{request} = \hat{p}_{peak} \cdot sign(e_{peak} - e_{peak}^{aim})
\\]

\\[
    p_{base}^{virt} = -p(t) - p_{peak}^{request}
\\]
\\[
    p_{base} = Sat(p_{base}^{virt}, \hat{p}_{base})
\\]

\\[
    p_{peak}^{virt} = -p(t) - p_{base}
\\]
\\[
    p_{peak} = Sat(p_{peak}^{virt}, \hat{p}_{peak})
\\]

#### Synchronized Mode
\\[
    p_{base} = -\chi p(t)
\\]
\\[
    p_{peak} = -(1 - \chi) p(t)
\\]


<!--
% \\[
%     p_{base}^{virt} = -p(t) - p_{peak}^{request}
% \\]
% \\[
%     p_{base} = min(p_{base}^{virt}, \hat{p}_{base}) \cdot (p_{base}^{virt} > 0
%     \land e_{base} > 0) + min(p_{base}^{virt}, -\hat{p}_{base}) \cdot (p_{base}^{virt} \lower 0
%     \land e_{base} \lower \hat{e}_{base})
% \\]
% 
% \\[
%     p_{peak}^{virt} = -p(t) - p_{base}
% \\]
% \\[
%     p_{peak} = min(p_{peak}^{virt}, \hat{p}_{peak}) \cdot (p_{peak}^{virt} > 0
%     \land e_{peak} > 0) + min(p_{peak}^{virt}, -\hat{p}_{peak}) \cdot (p_{peak}^{virt} \lower 0
%     \land e_{peak} \lower \hat{e}_{peak})
% \\]
-->


Zusammenfassung punktsym. Signale ohne Vorzeichenwechsel
--------------------------------------------------------

- Annahmen: 
    - punktsymmetrische Signale ohne Vorzeichenwechsel (innerhalb
      halber Periode)
    - Integral des Signals (entspricht Energie) am Anfang und Ende gleich Null

\\[
    e_{single} = e_{base} + e_{peak} \qquad p_{single} = p_{base} + p_{peak}
\\]

- Gleichung durch Peak/Base Trennung immer erfüllt
- Gleichung trivial wenn \\(e/p\\) der beiden Speicher gleich
- Trennung von Signalanalyse und Auslegung nicht optimal
- Durch Berücksichtigung des Signals können Punkte im Ragone Diagramm erreicht
  werden, die durch Addition nicht möglich sind
- Trennung Peak/Base geht für Rechtecksignale in Ragone Auslegung über
- Strategie benötigt kein Umladen und keine Prädiktion
- Umladen kann Spread zwischen \\( \left( \frac{e}{p}} \right)_{peak, base} \\)
  vergrößern
- Leaf stellt minimal mögliche Peak-Speichergröße bei gegebener Leistung dar.
  Keine Strategie schafft weniger.


Mathematische Formulierung allg. Signale
----------------------------------------

### Switched Decay ODE

\\[
    \frac{dy}{dt} = f_{build}(t) \cdot c_{build} + f_{decay} \cdot c_{decay}
\\]

mit allgemein

\\[
    c_{build} = f_{build} > 0
\\]
\\[
    c_{decay} = f_{build} \leq 0 \land f_{decay} \low 0 \land y > 0
\\]

und speziell für Speicherproblem

\\[
    f_{build} = ResSat(p(t), \hat{p}_{base})
\\]
\\[
    f_{decay} = max(p^{request}, p^{limit})
\\]

wobei

\\[
    p^{request} = -\hat{p}_{peak}
\\]

Mit Umladen: \\( p(t) - \hat{p}_{base} \\)
Ohne Umladen: \\( p(t) \\)

### Dimensionierung: sdode anwenden

\\[
    \frac{d}{dt} e_{FW} = sdode(p(t))
\\]
\\[
    \frac{d}{dt} e_{BW} = sdode(p^\ast(t))
\\]

mit

\\[
p^{ast}(t) = mirror\left( reverse(p(t), T) \right)
\\]

wobei
\\[
    mirror: x \mapsto -x
\\]
\\[
    reverse: (x(t),T) \mapsto x(T-t)
\\]

ODEs von \\( 0..T \\) lösen

\\[
    \hat{e}_{peak} = max(max(e_{FW}), max(e_{BW}))
\\]
\\[
    \hat{e}_[base} = \hat{e} - \hat{e}_{peak}
\\]

### Betriebsstrategie

Wie vorher, wobei

\\[
    e_{peak}^{aim} = \hat{e}_{peak} \cdot \left( e_{peak} \low mirror \left(reverse(e_{BW}) \right) \right)
\\]



Zusammenfassung allg. Signale
-----------------------------

- Ohne Prädiktor ist eine ausfallsichere primitive Betriebsführung für bel.
  Signale nicht möglich (da ein Speicher ausfallen kann durch "voll/leer
  laufen")
- Dimensionierung und SOC Prädiktion über Switched Decay ODE

- Berechnungsdauer für Leaf je Signal: 0.1 - 10 Min; Geschätzer
  Optimierungsfaktor: 10 - 1000


Vorschlag: Hybridisierungs- und Umlademaß
-----------------------------------------

### Hybridisierungsmaß

\\[ 
    H = \frac{1}{\hat{e}\hat{p}} \left( \int_0^{\hat{e}} p_{peak}(e) \text{d}e - 
        \int_0^{\hat{e}} p_{peak}(e) \text{d}e \right)
\\]

- normierte Fläche im Leaf Diagram
- zwischen 0 und 1
    - 0  keine Hybridisierung, entspricht gerader Linie, wie bei Square-Function
    - 1  maximale Hybridisierung,, entspricht Rechteck im Leaf-Diagram, bei
      Impulsartigen Signal mit infinitesimalen base Grundanteil
- Separate Betrachtung für Umladen/kein Umladen möglich

### Umladefähigkeit

Für ein bestimmtes Verhältnis \\( \chi \\):

\\[
    R = \frac{\hat{e}_{peak,~Umladen}}{\hat{e}_{peak,~kein~Umladen}} - 1
\\]

Integral für alle \\( \chi \\):

\\[
    R =  \int_0^1 \left( \frac{\hat{e}_{p,U}(\chi)}{\hat{e}_{p,kU}(\chi)} - 
         1 \right) \text{d}  \chi
\\]


- Integral bildet Durchschnitt aus allen Verhältnissen
- zwischen 0 und \\( \infty \\)
    - 0 kein Umladen möglich
    - n Peak Speicher speichert in einen Zyklus n mal seine eigene Energie
      durch


Ausblick, nicht untersucht, offene Fragen
-----------------------------------------

- Bleibt Zentrale These _peak + base = single_ für Energie und Leistung
  erhalten, sobald \\( \eta \neq 1 \\)?
- Möglicherweise durch Umrechnen der Verluste: Beim Hybridsystem dürfen
  insgesamt nur soviel Verluste entstehen wie beim Einspeichersystem
- Leaf Diagramm sinnvoll, wenn _peak + base_ \\(\neq\\) _single_?

Weiterhin zu betrachten:

- Kosten, Auswahlprozess, der auf reale Speicher mapped
- Unsicherheit im untersuchten Signal
- Betriebsführungsoptimierung für weniger unnötiges Umladen, oder erfüllen von
  Sekundäranforderungen, Bsp: Schonung des Base-Speichers
- Wirkungsgrade, Stand-By Verluste
- Zyklenbeanspruchung
- Anlaufzeiten, Transienten, Dynamik der Einzelspeicher
- Unterschiedliche \\(\chi_{charge} \\), \\( \chi_{discharge} \\)
- Kurzzeitige Überlastbarkeit von Speichern berücksichtigen
