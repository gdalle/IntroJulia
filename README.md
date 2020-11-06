# Introduction to Julia

The present repository contains an introduction to the programming language Julia, designed for an optimization class.

## Prerequisites

This introduction comes in the form of a Jupyter notebook, which you cannot use until you go through the following steps.

### 1. Install Julia

Go to https://julialang.org/downloads/ and download the version of Julia corresponding to your OS. Then, visit the page https://julialang.org/downloads/platform/ and follow the instructions given there to install it.

Remark: adding Julia to your `PATH` is not necessary if you don't want to. As long as you have something named Julia in your list of programs, you're good to go for now.

### 2. Clone the project repository

Go to https://github.com/gdalle/IntroJulia, click on the green button `Code` and then `Download ZIP`. Extract the downloaded archive wherever you want.

### 3. Install and configure Jupyter

Open a terminal and run Julia using the command `julia`. What you see is called a Read-Eval-Print Loop (REPL), it is very similar to a Python interactive session. Copy-paste the following commands into the REPL to install Jupyter (and a few extensions) using Julia's package manager `Pkg`:

```julia
using Pkg
Pkg.add("IJulia")
```

### 4. Launch Jupyter and open the notebook

In the Julia REPL, copy-paste the following commands:

```julia
using IJulia
notebook()
```

This should open your default internet browser and display a local page called Jupyter. Within Jupyter, navigate to the folder where you extracted `IntroJulia` and open the file named `Introduction to Julia.ipynb`.

## Useful tips

### Development

If you are looking to start a project that doesn't fit inside a Jupyter notebook, take a look at the Juno IDE (https://junolab.org/).

### Documentation

If you are looking for a command or function you don't know, start with https://juliadocs.github.io/Julia-Cheat-Sheet/.

If you want to know more about Julia syntax and functionalities, check out the tutorials at https://julialang.org/learning/, then the official documentation at https://docs.julialang.org/en/v1/ or the course https://en.wikibooks.org/wiki/Introducing_Julia. A more in-depth coverage is given by https://benlauwens.github.io/ThinkJulia.jl/latest/book.html.

### Useful libraries

- Graphs: https://juliagraphs.org/
- Optimization: https://www.juliaopt.org/
- Statistics: https://juliastats.org/
- Plotting: https://github.com/JuliaPy/PyPlot.jl or https://github.com/JuliaPlots
- Utilities: https://github.com/timholy/ProgressMeter.jl
- Anything else: https://juliaobserver.com/packages or https://juliahub.com/ui/Packages

### Debugging

Here is a four-step debugging procedure that works 99\% of the time:

1. Try to understand the bug by tracking its origin.
2. If this doesn't work, copy-paste the bug message into Google and read the first three forum answers about it.
3. If that doesn't work, sleep on it and try again tomorrow.
4. If none of the previous methods work, email your teaching assistant.
