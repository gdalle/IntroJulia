### A Pluto.jl notebook ###
# v0.19.11

#> [frontmatter]
#> title = "IntroJulia - package dev"

using Markdown
using InteractiveUtils

# ╔═╡ c35189d5-fbe8-4637-b004-2d15b7399af5
using PlutoUI; TableOfContents()

# ╔═╡ 69f4feb4-a170-4a79-a316-8697021770c9
md"""
!!! danger "Introduction to Julia - developing a package"
	🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 2cb3c53a-71d0-43b1-81e5-4d348e8f6c09
md"""
# Package creation
"""

# ╔═╡ 9440458f-a7ce-4293-a42b-89d45e34f51c
md"""
## Discovering what's out there

Before coding something, you want to make sure that someone else hasn't already coded it. For that, you may need to search for packages on a dedicated database: that's what [JuliaObserver](https://juliaobserver.com/) and [JuliaHub](https://juliahub.com/ui/Home) are here for.

In addition, Julia packages with a common theme are often gathered into GitHub "groups" or organizations. Those are listed [here](https://julialang.org/community/organizations/).
"""

# ╔═╡ 93c169dd-37e3-4ac1-971f-2bbec5071ca2
md"""
## Interfacing with other languages

Sometimes, the functions you need are only available in other languages. But don't worry, because Julia plays nice with many of its friends:
- C and Fortran thanks to the [built-in callers](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)
- Python thanks to [PyCall.jl](https://github.com/JuliaPy/PyCall.jl), or better yet [PythonCall.jl](https://github.com/cjdoris/PythonCall.jl)
- R thanks to [RCall.jl](https://github.com/JuliaInterop/RCall.jl)
"""

# ╔═╡ b653e7a8-8c25-45c8-81c6-5b891af955d3
md"""
## Setting up the package structure

The [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl) package enables you to create packages in a standardized way. It takes care of the file structure for you, and even integrates with [GitHub Actions](https://docs.github.com/en/actions) or Travis CI to set up a continuous integration workflow (including tests and documentation build, see below).
"""

# ╔═╡ b42f7153-eb3b-41cf-8447-99b1157f03b9
md"""
# Development workflow

The Julia manual contains some [workflow tips](https://docs.julialang.org/en/v1/manual/workflow-tips/), but it is just the beginning.
"""

# ╔═╡ 672ad497-a309-4a56-959e-ba6a5af1dc80
md"""
## Package manager

One of the main assets of Julia is a built-in package manager called [Pkg.jl](https://docs.julialang.org/en/v1/stdlib/Pkg/), which handles installation and updates of every library you may need. It also makes it possible to use separate environments for each one of your projects. The [full documentation](https://pkgdocs.julialang.org/v1/) of this library is a must-read.
"""

# ╔═╡ fa4decaa-e06d-413c-aa59-1cec097cdac7
md"""
## Useful packages

If you add packages to your base Julia environment (which is called something like `@v1.7`), they will also be available in every project environment. This means you should keep your base environment very light to avoid conflicts.
Still, here are some essential tools that deserve to be there (in alphabetical order):

- [AbbreviatedStackTraces.jl](https://github.com/BioTurboNick/AbbreviatedStackTraces.jl): display more readable error messages (not in the general registry)
- [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl): measure time and memory performance
- [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl): analyze type inference
- [JET.jl](https://github.com/aviatesk/JET.jl): statically debug source code
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl): clean up source code in a configurable way
- [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl): put some color in your REPL
- [PackageCompatUI.jl](https://github.com/GunnarFarneback/PackageCompatUI.jl): browse and define compatibility requirements
- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate source changes without restarting the REPL
- [Term.jl](https://github.com/FedeClaudi/Term.jl): customize REPL outputs
- [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl): activate the test environment of a package

Some of these tools also play nice with the [Julia for VSCode extension](https://www.julia-vscode.org/).
"""

# ╔═╡ 952e1ffe-a1e1-497e-96d9-76e2251e5b27
md"""
## Coding style

Julia has no universally agreed-upon style guide like Python. A few official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).
For an exhaustive style reference, have a look at the unofficial (but widely used) [BlueStyle](https://github.com/invenia/BlueStyle) by Invenia, or the new [SciMLStyle](https://github.com/SciML/SciMLStyle)
"""

# ╔═╡ c8a6e3e8-f951-4b26-92b4-195176518b7c
md"""
## Testing

Julia has built-in support for [unit testing](https://docs.julialang.org/en/v1/stdlib/Test/). This allows you to check that your code behaves in the way you expect.
As part of testing, you can use the [Aqua.jl](https://github.com/JuliaTesting/Aqua.jl) package to assess code quality.
"""

# ╔═╡ dd8f6789-2663-4bfb-ad6b-9c1a2d1e5119
md"""
## Documentation

To help future users (including yourself), it is a good idea to document your code in the `.jl` files themselves. This can be done with docstrings written in Markdown, see [this reference](https://docs.julialang.org/en/v1/manual/documentation/) for general guidelines.

If you want to automatically generate a nice HTML documentation website, [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.
[Literate.jl](https://github.com/fredrikekre/Literate.jl) is also useful for long examples and tutorials.
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

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "843496cd44fbdabc30a5724f73519a3ea6a74f55"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

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
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

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
version = "0.7.0"

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
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

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
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─c35189d5-fbe8-4637-b004-2d15b7399af5
# ╟─69f4feb4-a170-4a79-a316-8697021770c9
# ╟─2cb3c53a-71d0-43b1-81e5-4d348e8f6c09
# ╟─9440458f-a7ce-4293-a42b-89d45e34f51c
# ╟─93c169dd-37e3-4ac1-971f-2bbec5071ca2
# ╟─b653e7a8-8c25-45c8-81c6-5b891af955d3
# ╟─b42f7153-eb3b-41cf-8447-99b1157f03b9
# ╟─672ad497-a309-4a56-959e-ba6a5af1dc80
# ╟─fa4decaa-e06d-413c-aa59-1cec097cdac7
# ╟─952e1ffe-a1e1-497e-96d9-76e2251e5b27
# ╟─c8a6e3e8-f951-4b26-92b4-195176518b7c
# ╟─dd8f6789-2663-4bfb-ad6b-9c1a2d1e5119
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
