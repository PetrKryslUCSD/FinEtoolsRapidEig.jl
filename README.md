# FinEtoolsRapidEig.jl: Using Coherent Node Cluster model reduction to calculate free vibration frequencies and mode shapes.

Paper accepted for publication as NME-Jul-19-0522.R1 - Rapid Free-vibration analysis with Model Reduction based on Coherent Nodal Clusters, in the International Journal for Numerical Methods in Engineering, 03/03/2020. Authors: Krysl, Petr, and Sivapuram, Raghavendra; both of University of California, San Diego , Jacobs School of Engineering Department of Structural Engineering; and
Abawi, Ahmad, of Heat, Light, and Sound Research, Inc.

Abstract: Modal expansion is a workhorse used in
many engineering analysis algorithms. One example is the
coupled boundary element-finite element computation of the
backscattering target strength of underwater elastic
objects. To obtain the modal basis, a free-vibration
(generalized eigenvalue) problem needs to be solved, which tends to be expensive when there are many basis vectors to
compute. In the above mentioned backscattering example it
could be many hundreds or thousands. Excellent algorithms
exist to solve the free-vibration problem, and most use
some form of the Rayleigh-Ritz (RR) procedure. The key to
an efficient RR application is a low-cost transformation
into a reduced basis. In this work a novel, inexpensive a
priori transformation is constructed for
solid-mechanics finite element models based on the notion
of coherent nodal clusters. The inexpensive RR procedure
then leads to significant speedups of the computation of an
approximate solution to the free vibration problem.

## Installation

Use the Git
```
git clone https://gitlab.com/PetrKrysl/FinEtoolsRapidEig.git
```
to clone the repository into some suitable folder. This will create the folder `FinEtoolsRapidEig`.

The Julia environment needs to be initialized. This first part is best done by running Julia _without starting up multiple workers_. Change the current folder to be `FinEtoolsRapidEig`. Start Julia and run
```
using Pkg; Pkg.activate("."); Pkg.instantiate()
```
When prompted, provide the username and the password.

```
import Pkg; Pkg.add("https://gitlab.com/PetrKrysl/CoNCMOR.jl.git")
```

## Usage

