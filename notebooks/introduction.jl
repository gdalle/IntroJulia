### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ facc45c8-edd2-4f1e-95a1-e5213ccd5f2b
using PlutoUI

# ╔═╡ b671a975-a321-4497-a75d-4c5ca9f49004
TableOfContents()

# ╔═╡ c98c53e0-f36c-11eb-251a-ab31fc59ce36
md"""
# The basics
"""

# ╔═╡ 6b62648a-1b8a-4329-b0a6-f8ec83d84757
md"""
## What is Julia?

Maybe the solution to the two-language problem (see this [Nature article](https://www.nature.com/articles/d41586-019-02310-3)):

- User-friendly syntax for high-level programming
- C-level speed (when done right) for high-performance computing
"""

# ╔═╡ 77d45cea-0510-4eab-b037-586fabb174b3
md"""
## Learning Julia

The Julia website has a great list of [resources for beginners](https://julialang.org/learning/). Naturally, the primary source of knowledge is the [Julia manual](https://docs.julialang.org/en/v1/).

If you just need a quick refresher about syntax, this [cheat sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/) is the place to go.

In addition, here are two handmade tutorials prepared by students from my lab: [IntroJulia](https://github.com/gdalle/IntroJulia) and [Julia Day course](https://github.com/mfherbst/course_julia_day). We also have a working group on [high-performance computation in Julia](https://github.com/adrien-le-franc/JuliaHPC-Cermics).

If you want to go further, here is a list of quality books and tutorials:

- [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia)
- [ThinkJulia](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html)
- [From Zero to Julia](https://techytok.com/from-zero-to-julia/)
- [IntroToJulia](https://ucidatascienceinitiative.github.io/IntroToJulia/)
"""

# ╔═╡ eefeae31-7ee7-4f02-8efb-29d4b870e7e9
md"""
## Development environment

When coding in Julia, you want to select a comfortable IDE. Here are a few good choices:

- [VSCode](https://code.visualstudio.com/) with the [Julia for VSCode extension](https://www.julia-vscode.org/)
- [Atom](https://atom.io/) with the [Juno package](https://junolab.org/)
- Any other IDE with the relevant [Julia support](https://github.com/JuliaEditorSupport)
- [Jupyter Lab](http://jupyterlab.io) is a browser-based IDE for Julia, Python and R
- [Pluto](https://github.com/fonsp/Pluto.jl) is a Julia-based reactive notebook server, and the one we use for this course

"""

# ╔═╡ 30fb1ba4-2189-4c8b-85cb-17c7e583b3dc
md"""
## Getting help

The Julia [community](https://julialang.org/community/) is very active and welcoming, so don't hesitate to ask for help in the following venues (by order of priority):

- a quick Google search
- the [Humans of Julia Discord](https://discord.gg/mm2kYjB)
- the [Julia Slack](https://julialang.org/slack/)
- the [Julia discourse forum](https://discourse.julialang.org/)
- a specific package's GitHub repository, which includes documentation and issues
"""

# ╔═╡ 1794b111-b746-46d1-9331-73728f5b4d5d
md"""
# Package development
"""

# ╔═╡ 24c874f4-99eb-4439-a8b3-8d5edf9e3262
md"""
## Discovering packages

Before coding something, you want to make sure that someone else hasn't already coded it better and faster than you. Since Julia package names are sometimes obscure, you may need to search for packages on a dedicated database: that's what [JuliaObserver](https://juliaobserver.com/) and [JuliaHub](https://juliahub.com/ui/Home) are here for.

In addition, Julia packages are often gathered into GitHub "groups" or organizations, which are listed [here](https://julialang.org/community/organizations/).

If a Julia package doesn't exist:

- Look for it in C and use [built-in C callers](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)
- Look for it in Python and use [PyCall.jl](https://github.com/JuliaPy/PyCall.jl)
- (you get the idea)
...or code / wrap it yourself in Julia and contribute to the community!
"""

# ╔═╡ 207bf481-b2f7-456b-bf0f-7cc8cf7a77f1
md"""
## Workflow

Some workflow tips can be found [in the manual](https://docs.julialang.org/en/v1/manual/workflow-tips/). In particular, you should check out the following packages:

- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate changes without restarting the REPL
- [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl): dynamically debug source code (much easier to use from within VSCode)
- [JET.jl](https://github.com/aviatesk/JET.jl): statically debug source code
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl): format source code
"""

# ╔═╡ c5d2a1f0-6948-477c-bb29-08d33e93c480
md"""
## Style

Julia has no universally agreed-upon style guide like Python. The main official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).

For an exhaustive style reference, have a look at the unofficial (but widely used) [BlueStyle](https://github.com/invenia/BlueStyle).
"""

# ╔═╡ 897fd787-4156-4909-a1e0-f5dc13f3bacb
md"""
## Documentation

If you are courageous enough to write documentation (which you should be), the best place to put it is next to your code using docstrings. Julia docstrings are basically Markdown, see [this reference](https://docs.julialang.org/en/v1/manual/documentation/) to know how to write them.

If you want to automatically generate a nice HTML documentation website, harnessing the power of
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.
"""

# ╔═╡ e94f458f-4141-4f14-825b-e51a1457255e
md"""
## Unit testing

Julia has [built-in support](https://docs.julialang.org/en/v1/stdlib/Test/) for unit testing.

The nice thing about `Documenter.jl` is that is also enables unit testing from within the documentation itself. Inside a docstring, you can put examples of REPL input and expected output, which will be run again and checked for correctness every time the documentation is updated. These code examples are called doctests.
"""

# ╔═╡ 5cd73516-d4ea-4e31-ba12-06eaea28aa38


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═facc45c8-edd2-4f1e-95a1-e5213ccd5f2b
# ╠═b671a975-a321-4497-a75d-4c5ca9f49004
# ╟─c98c53e0-f36c-11eb-251a-ab31fc59ce36
# ╟─6b62648a-1b8a-4329-b0a6-f8ec83d84757
# ╟─77d45cea-0510-4eab-b037-586fabb174b3
# ╟─eefeae31-7ee7-4f02-8efb-29d4b870e7e9
# ╟─30fb1ba4-2189-4c8b-85cb-17c7e583b3dc
# ╟─1794b111-b746-46d1-9331-73728f5b4d5d
# ╟─24c874f4-99eb-4439-a8b3-8d5edf9e3262
# ╟─207bf481-b2f7-456b-bf0f-7cc8cf7a77f1
# ╟─c5d2a1f0-6948-477c-bb29-08d33e93c480
# ╟─897fd787-4156-4909-a1e0-f5dc13f3bacb
# ╟─e94f458f-4141-4f14-825b-e51a1457255e
# ╠═5cd73516-d4ea-4e31-ba12-06eaea28aa38
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
