### A Pluto.jl notebook ###
# v0.19.19

#> [frontmatter]
#> title = "IntroJulia - package dev"

using Markdown
using InteractiveUtils

# ╔═╡ c35189d5-fbe8-4637-b004-2d15b7399af5
using PlutoUI; TableOfContents()

# ╔═╡ 69f4feb4-a170-4a79-a316-8697021770c9
md"""
!!! danger "Introduction to Julia - package development"
	🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ b42f7153-eb3b-41cf-8447-99b1157f03b9
md"""
# Packages and environments
"""

# ╔═╡ 54de1183-d384-4034-a404-6ea2c9d9745f
md"""
## Pkg.jl
"""

# ╔═╡ 672ad497-a309-4a56-959e-ba6a5af1dc80
md"""
One of the main assets of Julia is a built-in package manager called [Pkg.jl](https://docs.julialang.org/en/v1/stdlib/Pkg/), which handles installation and updates of every library you may need. It also makes it possible to use separate environments for each one of your projects. The [full documentation](https://pkgdocs.julialang.org/v1/) of this library is a must-read.
"""

# ╔═╡ 96f9dcad-579a-411f-a066-f7541f44f0a3
md"""
## Default environment
"""

# ╔═╡ fa4decaa-e06d-413c-aa59-1cec097cdac7
md"""
One thing to keep in mind is that packages installed into your default environment (called `@v1.8` and located at `~/.julia/environments/v1.8`) are accessible in every other environment.
That is why `@v1.8` be curated carefully, filled only with lightweight packages that are often useful.
Here is a good starting selection:
- [Aqua.jl](https://github.com/JuliaTesting/Aqua.jl): check code quality
- [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl): measure time and memory performance
- [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl): generate documentation
- [JET.jl](https://github.com/aviatesk/JET.jl): advanced debugger and performance diagnosis tool
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl): clean up source code in a configurable way
- [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl): put some color in your REPL
- [PackageCompatUI.jl](https://github.com/GunnarFarneback/PackageCompatUI.jl): browse and define compatibility requirements
- [Revise.jl](https://github.com/timholy/Revise.jl): incorporate source changes without restarting the REPL
- [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl): activate the test environment of a package

You probably want to add the following lines to your `.julia/config/startup.jl` file, to load these packages whenever Julia starts:
```julia
using Revise
using OhMyREPL
```
"""

# ╔═╡ 29e4f7e5-56cd-4c61-8a6f-02d148648848
md"""
# Your first Julia package
"""

# ╔═╡ dd1e7c1a-131e-4690-b4ac-275772bec2af
md"""
## Code storage

To write a complete Julia package, version control is essential.
When developing ambitious projects, you want to be able to reverse some changes or go back to an earlier idea that worked well.

[Git](https://git-scm.com/) is a cross-platform software that allows you to save various versions of your code.
[GitHub](https://github.com/) is a website that allows you to store and collaborate on your code.
If you're unfamiliar with these tools, the following [tutorial for beginners](https://product.hubspot.com/blog/git-and-github-tutorial-for-beginners) tells you all you need to know.
This [quick recap](https://up1.github.io/git-guide/index.html) is also very handy.
As a student, you are entitled to the [GitHub Student Developer pack](https://education.github.com/pack), which boasts lots of benefits for computer science courses.
"""

# ╔═╡ aa04c9c4-ba66-4e48-b429-9e5f248b8ded
md"""
## Repository setup
"""

# ╔═╡ 9e33fe5c-8bf3-4757-9d3a-b086f6a157d2
md"""
For the rest of this section, we assume that you have created a GitHub account, and gone through the following very short GitHub tutorials:
1. [Hello World](https://docs.github.com/en/get-started/quickstart/hello-world)
2. [Set up Git](https://docs.github.com/en/get-started/quickstart/set-up-git)

To get started on a Julia package, create a public repository on your GitHub account.
The following instructions are given with my own GitHub user name (`gdalle`) and an arbitrary repository name (`MyJuliaPackage.jl`).
"""

# ╔═╡ b653e7a8-8c25-45c8-81c6-5b891af955d3
md"""
## Package structure
"""

# ╔═╡ 88de7f95-c91a-4249-b11c-beaacb07eaca
md"""
[PkgTemplates.jl](https://github.com/JuliaCI/PkgTemplates.jl) enables you to initialize packages in a standardized way.
Open a Julia REPL in the parent folder where you want your package to appear, then run these commands.
```julia
julia> using PkgTemplates

julia> template = Template(interactive = true)
```
You will be presented with several questions.
Here is our recommendation of boxes to tick (check out the [PkgTemplates.jl documentation](https://juliaci.github.io/PkgTemplates.jl/stable/) for details on each plugin).
The three dots `...` mean that you shouldn't customize anything (leave the boxes blank).
"""

# ╔═╡ 8793592f-7b63-4b3a-b9ca-a9de48e42c14
md"""
```
Template keywords to customize:
[press: d=done, a=all, n=none]
 > [X] user
   [X] authors
   [X] dir
   [X] host
   [X] julia
   [X] plugins
Enter value for 'user' (required): gdalle
Enter value for 'authors' (comma-delimited, default: Guillaume Dalle <99999999+gdalle@users.noreply.github.com> and contributors): 
Enter value for 'dir' (default: ~/.julia/dev): .
Select Git repository hosting service:
 > github.com
Select minimum Julia version:
 > 1.8
Select plugins:
[press: d=done, a=all, n=none]
   [ ] CompatHelper
   [X] ProjectFile
   [X] SrcDir
   [X] Git
   [X] License
   [X] Readme
   [X] Tests
   [ ] TagBot
   [ ] AppVeyor
   [ ] BlueStyleBadge
   [ ] CirrusCI
   [X] Citation
   [X] Codecov
   [ ] ColPracBadge
   [ ] Coveralls
   [ ] Develop
   [X] Documenter
   [ ] DroneCI
   [X] GitHubActions
   [ ] GitLabCI
   [ ] PkgEvalBadge
   [ ] RegisterAction
 > [ ] TravisCI
...
Documenter deploy style:
 > GitHubActions
...
```
"""

# ╔═╡ b39fdb39-2666-4c3d-a2c9-3502aa9b53e6
md"""
Then, all you need to do is run
```julia
julia> template("MyJuliaPackage")
```
and a folder called `MyJuliaPackage` will appear in the current directory (which we decided by setting `dir` to `.` above).
If you did the setup correctly, it should automatically be linked to your GitHub repository `gdalle/MyJuliaPackage.jl`, and all you have to do is publish the new branch `main` to see everything appear online.
"""

# ╔═╡ 415b700e-c856-4ed2-ae5c-32cc7a5d5688
md"""
# Continuous integration
"""

# ╔═╡ 91884a2f-3665-4731-8475-acb85d16606e
md"""
PkgTemplates.jl is especially useful because it interfaces with [GitHub Actions](https://docs.github.com/en/actions) to set up continuous integration (CI).
Basically, every time you push your code to the remote repository, a series of workflows will run automatically on the GitHub servers.
The results will be visible on the repository page, in the Actions tab.
Computation budget for CI workflows is unlimited for public repositories, but limited for private repositories.

Each workflow is defined by a YAML file located in the `.github/workflows` subfolder.
The most important ones are tests and documentation (see more below), both specified in `.github/workflows/CI.yml`.
"""

# ╔═╡ 0c44d611-a84a-4fc8-ab93-bba9a3fbf704
md"""
## Code style
"""

# ╔═╡ 574daa2f-cbd4-4e03-b743-639122289d6e
md"""
Julia has no universally agreed-upon style guide like Python.
A few official guidelines can be found [here](https://docs.julialang.org/en/v1/manual/style-guide/).
For an exhaustive style reference, have a look at the [BlueStyle](https://github.com/invenia/BlueStyle) by Invenia, or the new [SciMLStyle](https://github.com/SciML/SciMLStyle).

If you want to (partially) enforce a given style in your code, [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) can do that for you.
Just add a file called `.JuliaFormatter.toml` at the root of your package, and put a single line in it, for example
```
style = "blue"
```
Then JuliaFormatter.jl will be able to format all your files in the style that you chose, and the integrated formatting of VSCode will fall back on it for Julia files.
"""

# ╔═╡ 36de2131-e5c3-408d-9a07-f52420360fe2
md"""
## Documentation
"""

# ╔═╡ a4500dc6-4107-4f25-8b6a-7b79cf3949ff
md"""
Julia also has built-in support for [documentation](https://docs.julialang.org/en/v1/manual/documentation/), as you might have noticed when querying docstrings in the REPL.
Writing docstrings for your own functions is a good idea, not only for other users but also for yourself.

If you want to create a nice documentation website, [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) is the way to go.
The configuration is given by the `docs/make.jl` file, and the page sources are stored in the folder `docs/src/`.
When you run `docs/make.jl`, the folder `docs/build` will be populated with the HTML files of the website (which are ignored by Git).
Check their [guide](https://documenter.juliadocs.org/stable/man/guide/) for details.

With our PkgTemplates.jl setup, a Documenter.jl website will be automatically generated and updated after every push.
It is stored on a separate branch to avoid cluttering your workspace with HTML files.
To make it accessible, all you need to do is activate GitHub pages (for the repository settings) and select the `gh-pages` branch as a build source.

[Literate.jl](https://github.com/fredrikekre/Literate.jl) is also useful for long examples and tutorials.
"""

# ╔═╡ 5f2154aa-5520-47e0-ac41-3fd59d7b0ebd
md"""
## Tests
"""

# ╔═╡ eee57762-c550-413e-9874-75c360152dc1
md"""
Julia has built-in support for [unit testing](https://docs.julialang.org/en/v1/stdlib/Test/), which allows you to check that your code behaves in the way you expect.
Package tests are located in the `test/runtests.jl` file.

With our PkgTemplates.jl setup, tests are run automatically on each push.
"""

# ╔═╡ 7790bc94-5652-4f62-a889-2cb488e94e3f
md"""
Here is a typical `test/runtests.jl` file which performs a few automated checks in addition to your own handwritten ones.
It uses Aqua.jl, Documenter.jl and JuliaFormatter.jl in addition to the base module Test, which means all of these must be specified as [test dependencies](https://pkgdocs.julialang.org/v1/creating-packages/#Test-specific-dependencies-in-Julia-1.2-and-above).
"""

# ╔═╡ c5dc0fec-e6e3-4987-ac06-cc85420b8d1c
md"""
```julia
using Aqua
using Documenter
using MyJuliaPackage
using JuliaFormatter
using Test

DocMeta.setdocmeta!(
	MyJuliaPackage,
	:DocTestSetup,
	:(using MyJuliaPackage);
	recursive=true
)

@testset verbose = true "MyJuliaPackage.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(MyJuliaPackage; ambiguities=false)
    end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(MyJuliaPackage; verbose=true, overwrite=false)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(MyJuliaPackage)
    end

	@testset verbose = true "My own tests" begin
		@test 1 + 1 == 2
	end
end
```
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

julia_version = "1.8.5"
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
version = "1.0.1+0"

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
version = "1.10.1"

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
# ╟─b42f7153-eb3b-41cf-8447-99b1157f03b9
# ╟─54de1183-d384-4034-a404-6ea2c9d9745f
# ╟─672ad497-a309-4a56-959e-ba6a5af1dc80
# ╟─96f9dcad-579a-411f-a066-f7541f44f0a3
# ╟─fa4decaa-e06d-413c-aa59-1cec097cdac7
# ╟─29e4f7e5-56cd-4c61-8a6f-02d148648848
# ╟─dd1e7c1a-131e-4690-b4ac-275772bec2af
# ╟─aa04c9c4-ba66-4e48-b429-9e5f248b8ded
# ╟─9e33fe5c-8bf3-4757-9d3a-b086f6a157d2
# ╟─b653e7a8-8c25-45c8-81c6-5b891af955d3
# ╟─88de7f95-c91a-4249-b11c-beaacb07eaca
# ╟─8793592f-7b63-4b3a-b9ca-a9de48e42c14
# ╟─b39fdb39-2666-4c3d-a2c9-3502aa9b53e6
# ╟─415b700e-c856-4ed2-ae5c-32cc7a5d5688
# ╟─91884a2f-3665-4731-8475-acb85d16606e
# ╟─0c44d611-a84a-4fc8-ab93-bba9a3fbf704
# ╟─574daa2f-cbd4-4e03-b743-639122289d6e
# ╟─36de2131-e5c3-408d-9a07-f52420360fe2
# ╟─a4500dc6-4107-4f25-8b6a-7b79cf3949ff
# ╟─5f2154aa-5520-47e0-ac41-3fd59d7b0ebd
# ╟─eee57762-c550-413e-9874-75c360152dc1
# ╟─7790bc94-5652-4f62-a889-2cb488e94e3f
# ╟─c5dc0fec-e6e3-4987-ac06-cc85420b8d1c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
