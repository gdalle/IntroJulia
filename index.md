---
title: Introduction to Julia
layout: single
toc: true
sidebar:
  nav: notebooks
---
*By [Guillaume Dalle](https://gdalle.github.io)*

This website contains a series of notebooks illustrating the use of the Julia programming language. It was originally designed as teaching material for students of École des Ponts ParisTech, but it is accessible to a much wider audience.

All of the links in the menu point to notebooks that can be visualized in your browser without any prerequisites. To edit or run a notebook, click on `Edit or run this notebook` and follow the instructions given there. You will need to [install Julia](https://julialang.org/downloads/) and the [Pluto package](https://github.com/fonsp/Pluto.jl). I sometimes had issues with Pluto in Firefox, so you may want to try Google Chrome / Chromium instead.

While these notebooks are great for interactive exploration of short code snippets, they have serious downsides when it comes to larger tasks. We strongly advise you to choose another tool for more ambitious projects, ideally an IDE such as VSCode (more on this below).

## The basics

### What is Julia?

Maybe the solution to the two-language problem (see this [Nature article](https://www.nature.com/articles/d41586-019-02310-3)):

- User-friendly syntax for high-level programming
- C-level speed (when done right) for high-performance computing

### Learning Julia

The Julia website has a great list of [resources for beginners](https://julialang.org/learning/), as well as many free [tutorials](https://juliaacademy.com/) contributed by the community. The MIT course [Introduction to Computational Thinking](https://computationalthinking.mit.edu/Spring21/) is also very beginner-friendly.

If you just need a quick refresher about syntax, this [cheat sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/) is the place to go. For more involved questions, the primary source of knowledge is the [Julia manual](https://docs.julialang.org/en/v1/).

If you want to go further, here is a list of quality books and tutorials:

- [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia)
- [ThinkJulia](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html)
- [From Zero to Julia](https://techytok.com/from-zero-to-julia/)
- [IntroToJulia](https://ucidatascienceinitiative.github.io/IntroToJulia/)

And for the ultimate list of Julia resources, go to [Julia.jl](https://svaksha.github.io/Julia.jl/).

### Coding environment

When developing in Julia, you want to select a comfortable [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment). Here are a few good choices:

- [VSCode](https://code.visualstudio.com/) with the [Julia for VSCode extension](https://www.julia-vscode.org/)
- [Atom](https://atom.io/) with the [Juno package](https://junolab.org/)
- Any other IDE with the relevant [Julia support](https://github.com/JuliaEditorSupport)

If you want something a bit lighter, here are two browser-based options:
- [Jupyter Lab](http://jupyterlab.io) is a browser-based IDE and notebook for Julia, Python and R
- [Pluto](https://github.com/fonsp/Pluto.jl) is a Julia-based reactive notebook server

### Getting help

The Julia [community](https://julialang.org/community/) is very active and welcoming, so don't hesitate to ask for help in the following venues:

- a quick Google search
- a specific package's GitHub repository, which includes documentation (often signalled by a ![](https://img.shields.io/badge/docs-stable-blue.svg) badge) and issues
- the [Julia discourse forum](https://discourse.julialang.org/)
- the [Julia Slack](https://julialang.org/slack/)
- the [Humans of Julia Discord](https://discord.gg/mm2kYjB)

## Creating a package

### Discovering packages

Before coding something, you want to make sure that someone else hasn't already coded it better and faster than you. For that, you may need to search for packages on a dedicated database: that's what [JuliaObserver](https://juliaobserver.com/) and [JuliaHub](https://juliahub.com/ui/Home) are here for.

In addition, Julia packages are often gathered into GitHub "groups" or organizations, which are listed [here](https://julialang.org/community/organizations/).

If a Julia package doesn't exist:

- Look for it in C and use the [built-in C callers](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)
- Look for it in Python and use [PyCall.jl](https://github.com/JuliaPy/PyCall.jl)
- (you get the idea)

...or code / wrap it yourself in Julia and contribute to the community!

### Package manager

One of the main assets of Julia is a built-in package manager called `Pkg`, which handles installation and updates of every library you may need. `Pkg` also makes it possible to create separate environments for each one of your projects. The [full documentation](https://pkgdocs.julialang.org/v1/) of this utility is a must-read.

### Getting started

The [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl) package enables you to create packages in a standardized way. It takes care of the file structure for you, and even integerates with GitHub Actions or Travis CI to set up a continuous integration workflow.

### Workflow

Some workflow tips can be found [in the manual](https://docs.julialang.org/en/v1/manual/workflow-tips/). In particular, you should check out the following packages:

- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) and its [VSCode extension](https://marketplace.visualstudio.com/items?itemName=singularitti.vscode-julia-formatter): format source code
- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate changes without restarting the REPL
- [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl): dynamically debug source code (much easier to use from within VSCode)
- [JET.jl](https://github.com/aviatesk/JET.jl): statically debug source code

### Style

Julia has no universally agreed-upon style guide like Python. The main official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).

For an exhaustive style reference, have a look at the unofficial (but widely used) [BlueStyle](https://github.com/invenia/BlueStyle) by Invenia.

### Unit testing

Julia has built-in support for [unit testing](https://docs.julialang.org/en/v1/stdlib/Test/). This allows you to check that recent modifications did not modify the expected behavior of your code.

### Documentation

Non-documented code is useless code. You should write documentation as you code (not after), and the best place to put it is in your `.jl` files using docstrings. Julia docstrings are written in Markdown, see [this reference](https://docs.julialang.org/en/v1/manual/documentation/) for general guidelines.

If you want to automatically generate a nice HTML documentation website, harnessing the power of
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.
This pakcage also enables testing from within the documentation itself. Inside a docstring, you can put examples of REPL input and expected output, which will be run again and checked for correctness every time the documentation is updated. These code examples are called doctests.