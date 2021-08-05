# IntroJulia

*By [Guillaume Dalle](https://gdalle.github.io)*

This website contains a series of notebooks illustrating the use of the Julia programming language. It was originally designed as teaching material for students of École des Ponts ParisTech, but it is accessible to a much wider audience.

All of these notebooks can be visualized in your browser without any prerequisites. To edit or run a notebook, click on `Edit or run this notebook` and follow the instructions given there. You will need to [install Julia](https://julialang.org/downloads/) and add the [Pluto package](https://github.com/fonsp/Pluto.jl).

## Contents

- Getting started:
  - [Introduction](notebooks/introduction.jl.html)
  - [Basics of Julia](notebooks/basics.jl.html)

- [Graph theory](notebooks/graphs.jl.html)

- Continuous optimization:
  - Convex optimization (with [Convex.jl](https://github.com/jump-dev/Convex.jl))
  - General nonlinear optimization and gradient algorithms (with [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl))

- Linear optimization:
  - Polyhedra (with [Polyhedra.jl](https://github.com/JuliaPolyhedra/Polyhedra.jl))
  - Linear optimization (with [JuMP.jl](https://github.com/jump-dev/JuMP.jl))
  - Integer linear optimization (with [JuMP.jl](https://github.com/jump-dev/JuMP.jl))

- Constraint programming (with [ConstraintSolver.jl](https://github.com/Wikunia/ConstraintSolver.jl))

- Heuristics:
  - Simple heuristics
  - Metaheuristics

- Specific problems:
  - Bin packing
  - Routing
  - Scheduling

- To go further:
  - [Writing efficient code](notebooks/efficiency.jl.html)
  - Parallel computing
