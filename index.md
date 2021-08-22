---
title: Introduction to Julia
layout: single
toc: true
sidebar:
  nav: notebooks
---
*By [Guillaume Dalle](https://gdalle.github.io)*

This website contains a series of notebooks illustrating the use of the Julia programming language. It was originally designed as teaching material for students of École des Ponts ParisTech, but it is accessible to a much wider audience.

All of the links in the menu point to notebooks that can be visualized in your browser without any prerequisites. To edit or run a notebook, click on `Edit or run this notebook` and follow the instructions given there. You will need to [install Julia](https://julialang.org/downloads/) and add the [Pluto package](https://github.com/fonsp/Pluto.jl). I sometimes had issues with Pluto in Firefox, so you may want to try Google Chrome.

## The basics

### What is Julia?

Maybe the solution to the two-language problem (see this [Nature article](https://www.nature.com/articles/d41586-019-02310-3)):

- User-friendly syntax for high-level programming
- C-level speed (when done right) for high-performance computing

### Learning Julia

The Julia website has a great list of [resources for beginners](https://julialang.org/learning/). Naturally, the primary source of knowledge is the [Julia manual](https://docs.julialang.org/en/v1/).

If you just need a quick refresher about syntax, this [cheat sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/) is the place to go.

In addition, here are two handmade tutorials prepared by students from my lab: [IntroJulia](https://github.com/gdalle/IntroJulia) and [Julia Day course](https://github.com/mfherbst/course_julia_day). We also have a working group on [high-performance computation in Julia](https://github.com/adrien-le-franc/JuliaHPC-Cermics).

If you want to go further, here is a list of quality books and tutorials:

- [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia)
- [ThinkJulia](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html)
- [From Zero to Julia](https://techytok.com/from-zero-to-julia/)
- [IntroToJulia](https://ucidatascienceinitiative.github.io/IntroToJulia/)

### Development environment

When coding in Julia, you want to select a comfortable IDE. Here are a few good choices:

- [VSCode](https://code.visualstudio.com/) with the [Julia for VSCode extension](https://www.julia-vscode.org/)
- [Atom](https://atom.io/) with the [Juno package](https://junolab.org/)
- Any other IDE with the relevant [Julia support](https://github.com/JuliaEditorSupport)
- [Jupyter Lab](http://jupyterlab.io) is a browser-based IDE for Julia, Python and R
- [Pluto](https://github.com/fonsp/Pluto.jl) is a Julia-based reactive notebook server, and the one we use for this course

### Getting help

The Julia [community](https://julialang.org/community/) is very active and welcoming, so don't hesitate to ask for help in the following venues:

- a quick Google search
- the [Humans of Julia Discord](https://discord.gg/mm2kYjB)
- the [Julia Slack](https://julialang.org/slack/)
- the [Julia discourse forum](https://discourse.julialang.org/)
- a specific package's GitHub repository, which includes documentation and issues

## Creating a package

### Discovering packages

Before coding something, you want to make sure that someone else hasn't already coded it better and faster than you. Since Julia package names are sometimes obscure, you may need to search for packages on a dedicated database: that's what [JuliaObserver](https://juliaobserver.com/) and [JuliaHub](https://juliahub.com/ui/Home) are here for.

In addition, Julia packages are often gathered into GitHub "groups" or organizations, which are listed [here](https://julialang.org/community/organizations/).

If a Julia package doesn't exist:

- Look for it in C and use the [built-in C callers](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)
- Look for it in Python and use [PyCall.jl](https://github.com/JuliaPy/PyCall.jl)
- (you get the idea)
...or code / wrap it yourself in Julia and contribute to the community!

### Workflow

Some workflow tips can be found [in the manual](https://docs.julialang.org/en/v1/manual/workflow-tips/). In particular, you should check out the following packages:

- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate changes without restarting the REPL
- [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl): dynamically debug source code (much easier to use from within VSCode)
- [JET.jl](https://github.com/aviatesk/JET.jl): statically debug source code
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) and its [VSCode extension](https://marketplace.visualstudio.com/items?itemName=singularitti.vscode-julia-formatter): format source code

### Style

Julia has no universally agreed-upon style guide like Python. The main official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).

For an exhaustive style reference, have a look at the unofficial (but widely used) [BlueStyle](https://github.com/invenia/BlueStyle) by Invenia.

### Documentation

If you are courageous enough to write documentation (which you should be), the best place to put it is next to your code using docstrings. Julia docstrings are basically Markdown, see [this reference](https://docs.julialang.org/en/v1/manual/documentation/) to know how to write them.

If you want to automatically generate a nice HTML documentation website, harnessing the power of
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.

### Unit testing

Julia has built-in support for [unit testing](https://docs.julialang.org/en/v1/stdlib/Test/).

The nice thing about `Documenter.jl` is that is also enables testing from within the documentation itself. Inside a docstring, you can put examples of REPL input and expected output, which will be run again and checked for correctness every time the documentation is updated. These code examples are called doctests.