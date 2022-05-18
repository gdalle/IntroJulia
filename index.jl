### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ c35189d5-fbe8-4637-b004-2d15b7399af5
using PlutoUI; TableOfContents()

# ╔═╡ 69f4feb4-a170-4a79-a316-8697021770c9
md"""
# Introduction to Julia
"""

# ╔═╡ 7c628ff7-ebfb-420d-a1ee-96214f093630
md"""
*By [Guillaume Dalle](https://gdalle.github.io)*
"""

# ╔═╡ 7a69d685-dbb7-4387-a7b8-68c6527bfa3a
md"""
This website is an introduction to the Julia programming language. It was originally designed as teaching material for students of École des Ponts (France), but it is accessible to a much wider audience.
"""

# ╔═╡ 2ffec8d3-6168-4261-8846-e8269125077d
md"""
## What is Julia?

Maybe the solution to the two-language problem (see this [Nature article](https://www.nature.com/articles/d41586-019-02310-3)):

- User-friendly syntax for high-level programming
- C-level speed (when done right) for high-performance computing
"""

# ╔═╡ a5430a82-913f-439b-966d-73bad7f17283
md"""
## Installation

To install the latest version of Julia, follow the [platform-specific instructions](https://julialang.org/downloads/platform/).
If you need multiple versions of Julia to coexist on your system, or if you don't want to bother with manual updates, take a look at [juliaup](https://github.com/JuliaLang/juliaup), [jill](https://github.com/abelsiqueira/jill) or (my personal favorite) [jill.py](https://github.com/johnnychen94/jill.py).

If you want to run the notebooks of this course yourself, you will also need to install the [Pluto.jl](https://github.com/fonsp/Pluto.jl) package.
"""

# ╔═╡ 79c1ea6e-112c-47e2-a676-437f24298664
md"""
# Learning
"""

# ╔═╡ cf6f6e8e-dc13-4473-9cdd-fa8604b6a9e2
md"""
## Starting your journey
"""

# ╔═╡ 7183b4db-8779-4750-bb96-433414774c5d
md"""
The Julia website has a great list of [resources for beginners](https://julialang.org/learning/), as well as free [MOOCs](https://juliaacademy.com/) contributed by the community.
The official [Julia YouTube channel](https://www.youtube.com/c/TheJuliaLanguage/playlists) also boasts lots of introductory content.
"""

# ╔═╡ eec99565-4d72-401d-bdb0-c6a2c7fc815c
md"""
If you just need a quick refresher about syntax, this [cheat sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/) is the place to go.
For more involved questions, the primary source of knowledge is the [Julia manual](https://docs.julialang.org/en/v1/).
And for the ultimate list of Julia resources, go to [Julia.jl](https://svaksha.github.io/Julia.jl/).
"""

# ╔═╡ c6bfaf1e-61a6-4d48-a169-58359ac8229d
md"""
## Getting help
"""

# ╔═╡ 81191fe3-039e-4e0a-a551-79751f1894eb
md"""
The Julia [community](https://julialang.org/community/) is very active and welcoming, so don't hesitate to lask for help!

Here is a great list of places where you can find what you need: [New to Julia?](https://julialang.org/about/help/).
"""

# ╔═╡ e617f9ff-d54e-4cab-9e13-89db72c4628f
md"""
## Going further
"""

# ╔═╡ 9c3ec61e-3987-435c-b076-5efca1e205fd
md"""
Since Julia originated at MIT, it is no wonder that MIT researchers are teaching it well.
Check out [Introduction to Computational Thinking](https://computationalthinking.mit.edu/Spring21/) for your first steps, and the [SciML book](https://book.sciml.ai/) when you feel more confident.
"""

# ╔═╡ 67cff2eb-1636-448c-b99f-a93c76571b73
md"""
Here are some other high-quality resources:

- [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia) (WikiBooks)
- [ThinkJulia: How to think like a computer scientist](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html) (Ben Lauwens)
- [Quantitative economics with Julia](https://julia.quantecon.org/intro.html) (Jesse Perla, Thomas J. Sargent and John Stachurski)
- [From Zero to Julia](https://techytok.com/from-zero-to-julia/) (Aurelio Amerio)
- [A Deep Introduction to Julia for Data Science and Scientific Computing](https://ucidatascienceinitiative.github.io/IntroToJulia/) (Chris Rackauckas)
- [Introduction to the Julia programming language](https://github.com/mfherbst/2022-rwth-julia-workshop) (Michael Herbst)

If I forgot something, it is probably in this [big list of tutorials](https://julialang.org/learning/tutorials/).
"""

# ╔═╡ d3a8ac9b-213d-4c57-a423-c29a3bd7f29b
md"""
The following projects use Julia for their code examples:

- [Algorithms for Optimization & Algorithms for Decision-Making](Algorithms for Optimization) (Mykel J. Kochenderfer)
- [BeautifulAlgorithms.jl](https://github.com/mossr/BeautifulAlgorithms.jl#newtons-method) (Robert Moss)
- [TheAlgorithms](https://github.com/TheAlgorithms/Julia) (GitHub community)
"""

# ╔═╡ 46dc9487-212f-4d57-aded-141ec72ffec5
md"""
## Coding environment
"""

# ╔═╡ 50d7a8f0-afe5-4f34-b48b-7f95f56a61e7
md"""
When developing in Julia, you need to select a comfortable [Integrated Develoment Environment](https://en.wikipedia.org/wiki/Integrated_development_environment).
I strongly recommend using [Visual Studio Code](https://code.visualstudio.com/) with the [Julia for VSCode extension](https://www.julia-vscode.org/), but other IDEs also have [Julia support](https://github.com/JuliaEditorSupport).
"""

# ╔═╡ 0def1275-d89d-49c1-97bf-2181ff351e52
md"""
If you want something a bit lighter, here are two browser-based options:
- [Pluto.jl](https://github.com/fonsp/Pluto.jl) is a Julia-based reactive notebook server (which we are using right now)
- [IJulia.jl](https://github.com/JuliaLang/IJulia.jl) allows you to harness the power of [Jupyter](https://jupyter.org/). By the way, did you know that the "Ju" in "Jupyter" stands for Julia?
"""

# ╔═╡ 2311a578-c36b-4327-917a-dbe231e85b32
md"""
# Developing
"""

# ╔═╡ 35c3b938-b7d6-44e3-8323-e592b2044be8
md"""
## Discovering packages
"""

# ╔═╡ 9440458f-a7ce-4293-a42b-89d45e34f51c
md"""
Before coding something, you want to make sure that someone else hasn't already coded it. For that, you may need to search for packages on a dedicated database: that's what [JuliaObserver](https://juliaobserver.com/) and [JuliaHub](https://juliahub.com/ui/Home) are here for.

In addition, Julia packages with a common theme are often gathered into GitHub "groups" or organizations. Those are listed [here](https://julialang.org/community/organizations/).
"""

# ╔═╡ 93c169dd-37e3-4ac1-971f-2bbec5071ca2
md"""
Sometimes, the functions you need are only available in other languages. But don't worry, because Julia plays nice with many of its friends:
- C and Fortran thanks to the [built-in callers](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)
- Python thanks to [PyCall.jl](https://github.com/JuliaPy/PyCall.jl), or better yet [PythonCall.jl](https://github.com/cjdoris/PythonCall.jl)
- R thanks to [RCall.jl](https://github.com/JuliaInterop/RCall.jl)
"""

# ╔═╡ c5edcb1d-7b7d-414a-ae8e-be836459bcbf
md"""
## Workflow
"""

# ╔═╡ fa4decaa-e06d-413c-aa59-1cec097cdac7
md"""
Some workflow tips can be found [in the manual](https://docs.julialang.org/en/v1/manual/workflow-tips/). In particular, you should check out the following packages and add them to your base environment. Some of them are integrated in the VSCode extension mentioned above:

- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate changes without restarting the REPL
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl): clean up source code
- [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl): put some color in your REPL
- [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl): automatically activate the test environment of a package
- [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl): dynamically debug source code
- [JET.jl](https://github.com/aviatesk/JET.jl): statically debug source code
"""

# ╔═╡ 33047fa5-f5fa-419a-956d-c432b069b571
md"""
## Package manager
"""

# ╔═╡ 672ad497-a309-4a56-959e-ba6a5af1dc80
md"""
One of the main assets of Julia is a built-in package manager called [Pkg.jl](https://docs.julialang.org/en/v1/stdlib/Pkg/), which handles installation and updates of every library you may need. It also makes it possible to create separate environments for each one of your projects. The [full documentation](https://pkgdocs.julialang.org/v1/) of this utility is a must-read.
"""

# ╔═╡ 2a3fe571-c7c5-4015-ac36-369e8cb5b704
md"""
## Style
"""

# ╔═╡ 952e1ffe-a1e1-497e-96d9-76e2251e5b27
md"""
Julia has no universally agreed-upon style guide like Python. The main official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).
For an exhaustive style reference, have a look at the unofficial (but widely used) [BlueStyle](https://github.com/invenia/BlueStyle) by Invenia.
"""

# ╔═╡ 28d21757-09a9-440d-95dd-9a7499833c8a
md"""
## Testing
"""

# ╔═╡ c8a6e3e8-f951-4b26-92b4-195176518b7c
md"""
Julia has built-in support for [unit testing](https://docs.julialang.org/en/v1/stdlib/Test/). This allows you to check that recent modifications did not modify the expected behavior of your code.
"""

# ╔═╡ 03a94df6-6927-40d0-ad6e-ff2c9179eea6
md"""
## Documentation
"""

# ╔═╡ dd8f6789-2663-4bfb-ad6b-9c1a2d1e5119
md"""
To help future users (including yourself), it is a good idea to document your code in the `.jl` files themselves. This can be done with docstrings written in Markdown, see [this reference](https://docs.julialang.org/en/v1/manual/documentation/) for general guidelines.

If you want to automatically generate a nice HTML documentation website, [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.
"""

# ╔═╡ c3946ee3-6f6b-489a-bc6b-6b66f0649028
md"""
## Structure
"""

# ╔═╡ b653e7a8-8c25-45c8-81c6-5b891af955d3
md"""
The [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl) package enables you to create packages in a standardized way. It takes care of the file structure for you, and even integrates with [GitHub Actions](https://docs.github.com/en/actions) or Travis CI to set up a continuous integration workflow (including tests and documentation build).
"""

# ╔═╡ b293430c-8ebf-4c0e-9408-18c0bfdf8353
md"""
# Course contents
"""

# ╔═╡ b8667519-5a04-48da-ae79-cb2efc51f56d
md"""
All the links below point to notebooks that can be visualized in your browser without any prerequisites. To edit or run a notebook, click on `Edit or run this notebook` and follow the instructions given there.All the links below point to notebooks that can be visualized in your browser without any prerequisites. To edit or run a notebook, click on `Edit or run this notebook` and follow the instructions given there.
"""

# ╔═╡ 87ddbc70-5e7d-4359-8638-4c60a8fcdb2c
md"""
## General stuff
"""

# ╔═╡ 6160429a-6b98-4bfc-ab85-2f8109e99182
md"""
1. [Basics of Julia](basics.html)
2. [Writing efficient code](https://gdalle.github.io/JuliaPerf-CERMICS)
"""

# ╔═╡ 36a2cf6c-7ca4-4b8c-94db-0d59a2624102
md"""
## Optimization (work in progress)
"""

# ╔═╡ 813cd7f7-85e1-4cdf-bde3-af259d9aa429
md"""
1. [Graph theory](graphs.html)
2. [Polyhedra](polyhedra.html)
3. [Linear Programming](jump.html)
4. [Branch & Bound](branch_bound.html)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.32"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─c35189d5-fbe8-4637-b004-2d15b7399af5
# ╟─69f4feb4-a170-4a79-a316-8697021770c9
# ╟─7c628ff7-ebfb-420d-a1ee-96214f093630
# ╟─7a69d685-dbb7-4387-a7b8-68c6527bfa3a
# ╟─2ffec8d3-6168-4261-8846-e8269125077d
# ╟─a5430a82-913f-439b-966d-73bad7f17283
# ╟─79c1ea6e-112c-47e2-a676-437f24298664
# ╟─cf6f6e8e-dc13-4473-9cdd-fa8604b6a9e2
# ╟─7183b4db-8779-4750-bb96-433414774c5d
# ╟─eec99565-4d72-401d-bdb0-c6a2c7fc815c
# ╟─c6bfaf1e-61a6-4d48-a169-58359ac8229d
# ╟─81191fe3-039e-4e0a-a551-79751f1894eb
# ╟─e617f9ff-d54e-4cab-9e13-89db72c4628f
# ╟─9c3ec61e-3987-435c-b076-5efca1e205fd
# ╟─67cff2eb-1636-448c-b99f-a93c76571b73
# ╟─d3a8ac9b-213d-4c57-a423-c29a3bd7f29b
# ╟─46dc9487-212f-4d57-aded-141ec72ffec5
# ╟─50d7a8f0-afe5-4f34-b48b-7f95f56a61e7
# ╟─0def1275-d89d-49c1-97bf-2181ff351e52
# ╟─2311a578-c36b-4327-917a-dbe231e85b32
# ╟─35c3b938-b7d6-44e3-8323-e592b2044be8
# ╟─9440458f-a7ce-4293-a42b-89d45e34f51c
# ╟─93c169dd-37e3-4ac1-971f-2bbec5071ca2
# ╟─c5edcb1d-7b7d-414a-ae8e-be836459bcbf
# ╟─fa4decaa-e06d-413c-aa59-1cec097cdac7
# ╟─33047fa5-f5fa-419a-956d-c432b069b571
# ╟─672ad497-a309-4a56-959e-ba6a5af1dc80
# ╟─2a3fe571-c7c5-4015-ac36-369e8cb5b704
# ╟─952e1ffe-a1e1-497e-96d9-76e2251e5b27
# ╟─28d21757-09a9-440d-95dd-9a7499833c8a
# ╟─c8a6e3e8-f951-4b26-92b4-195176518b7c
# ╟─03a94df6-6927-40d0-ad6e-ff2c9179eea6
# ╟─dd8f6789-2663-4bfb-ad6b-9c1a2d1e5119
# ╟─c3946ee3-6f6b-489a-bc6b-6b66f0649028
# ╟─b653e7a8-8c25-45c8-81c6-5b891af955d3
# ╟─b293430c-8ebf-4c0e-9408-18c0bfdf8353
# ╟─b8667519-5a04-48da-ae79-cb2efc51f56d
# ╟─87ddbc70-5e7d-4359-8638-4c60a8fcdb2c
# ╟─6160429a-6b98-4bfc-ab85-2f8109e99182
# ╟─36a2cf6c-7ca4-4b8c-94db-0d59a2624102
# ╟─813cd7f7-85e1-4cdf-bde3-af259d9aa429
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
