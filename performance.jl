### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ f4b3ab20-5c8f-11ee-22f7-b3466c0a577e
begin
	import BenchmarkTools
	using PlutoUI
	using PlutoTeachingTools
	import ProfileCanvas
	import ProgressLogging
	import Test
end

# ╔═╡ 99466829-a9d9-4f1e-b35e-0a6a0d26b0a2
TableOfContents()

# ╔═╡ ca563363-6ae9-42a1-bb42-596e7471e69c
begin
	struct TwoColumnSplit{L, R}
	    left::L
	    right::R
	end
	
	function Base.show(io, mime::MIME"text/html", tc::TwoColumnSplit)
	    write(io, """<div style="display: flex;"><div style="flex: 45%;">""")
	    show(io, mime, tc.left)
		write(io, """</div><div style="flex: 10%;">""")
	    write(io, """</div><div style="flex: 45%;">""")
	    show(io, mime, tc.right)
	    write(io, """</div></div>""")
	end
end

# ╔═╡ e49d8681-e1eb-4c5e-91f2-605b4d1a91b7
md"""
# Writing fast Julia

_It's easy but not obvious_

Guillaume Dalle (EPFL)
"""

# ╔═╡ 74767c9a-4ed8-42cc-b7e2-1c31064f505c
present_button()

# ╔═╡ 00d45907-0cc0-4504-83f2-c009e0755a33
md"""
## Getting started
"""

# ╔═╡ c76df784-c4fb-47a9-bcdf-b652c8ecacfb
TwoColumnSplit(
	Resource("https://i.imgur.com/cfaAMIj.png"),
	md"""
!!! info "Link to this notebook"
	<https://gdalle.github.io/JuliaOptimizationDays2023/performance.html>

To launch it:
```julia$
using Pkg
Pkg.add("Pluto")
using Pluto
Pluto.run()
```
"""
)

# ╔═╡ 83d59131-2638-4e28-9daf-cbe8a14116c6
md"""
# Step 1: get it working
"""

# ╔═╡ 78ba6f3a-7d59-47e5-835e-e7a5b46a435c
md"""
## Toy example: gradient descent for linear regression
"""

# ╔═╡ 26d0faea-286e-44a4-a6a0-330f6f202926
md"""
The optimization problem is
```math
\min_x f(x) = \lVert Ax - b \rVert^2
```
The gradient is given by
```math
\nabla f(x) = 2A'(Ax-b)
```
"""

# ╔═╡ 80ef0e3e-bf19-47f2-bb40-e7bdc0ecb8f7
begin
	n, p = 10, 20;
	A, b = randn(n, p), randn(n);
	x0 = zeros(p)
end;

# ╔═╡ 7a6138a1-2878-42db-a6b6-af3acc49a24a
function matvec(M, v)
	n, p = size(M)
	res = []
	for i in 1:n
		y = sum(M[i, :] .* v)
		push!(res, y)
	end
	return res
end

# ╔═╡ 5fabe80b-42af-4ef4-b4ec-3975e6c8a375
∇f(x) = matvec(2A', (matvec(A, x) - b))

# ╔═╡ 87c68c4b-6f52-4987-aa0a-d491f20f9a98
function gradient_descent(∇f, x0; step=1e-3, iterations=100)
	x = copy(x0)
	for t in 1:iterations
		x -= step * ∇f(x)
	end
	return x
end

# ╔═╡ 8fa9d282-92ab-4dc1-a0fe-284a200fc384
md"""
## Test results
"""

# ╔═╡ 5c659445-3d2a-4aaf-8787-b07835b3c119
gradient_descent(∇f, x0)

# ╔═╡ da3a3d5d-0a46-4fab-9cd2-148723005775
let
	x_init = gradient_descent(∇f, x0; iterations=0)
	x_final = gradient_descent(∇f, x0)
	Test.@test sum(abs2, A * x_final - b) < sum(abs2, A * x_init - b)
end

# ╔═╡ 75b55303-3c1a-4ce0-8529-a906a32963e7
md"""
# Step 2: measure performance
"""

# ╔═╡ 0b4ac025-a4c9-41aa-b659-136e1dcd4cab
md"""
## Logging
"""

# ╔═╡ e88aa63f-0496-4daf-a1a6-9280d5507d8a
TwoColumn(
md"""
Main tools:

- [Logging standard library](https://docs.julialang.org/en/v1/stdlib/Logging/)
- [ProgressLogging.jl](https://github.com/JuliaLogging/ProgressLogging.jl)
""",
md"""
Also relevant:

- [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl)
"""
)

# ╔═╡ 67a3469f-a119-4e30-bbaa-a5ff30b7acfe
let
	x = 3
	@debug "For internal use" x
	@info "It's all good" x - 1
	@warn "Be careful" x - 2
	@error "Something went wrong" x - 3
end

# ╔═╡ 01d7fbbd-5956-4090-b42f-fdfbce05752f
ProgressLogging.@progress name="My loop" for i in 1:100
	sleep(0.01)
end

# ╔═╡ f44fffde-86ce-462a-9a3c-8723321cbe80
md"""
## Benchmarking
"""

# ╔═╡ cda8439a-9e7b-4391-8402-6591001029f7
TwoColumn(
md"""
Main tools:

- [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl)
""",
md"""
Also relevant:

- [TimerOutputs.jl](https://github.com/KristofferC/TimerOutputs.jl)
"""
)

# ╔═╡ d5cbf68c-8e89-4449-b053-e5d762139419
let
	x, y = rand(3), rand(3)
	@time x .= x .+ y
end;

# ╔═╡ c364957f-2335-4c6d-823e-c36f0dd2290d
let
	x, y = rand(3), rand(3)
	BenchmarkTools.@btime $x .= $x .+ $y
end;

# ╔═╡ d90bf5e7-e9b7-4d63-ac68-bab207df658c
bench = BenchmarkTools.@benchmark x .= x .+ y setup=(x=rand(3); y=rand(3))

# ╔═╡ 6299891d-a628-4056-955b-e490d937c591
md"""
# Step 3: remember the rules
"""

# ╔═╡ 03b9e227-7079-43be-b78e-f4d587b24f37
md"""
!!! info "Enable type inference"
	The type of all variables must be inferrable from the _type_ of the inputs (and not their _value_).
"""

# ╔═╡ 49f452c5-e8fc-4f8d-a2ea-046ab3e0dbba
md"""
!!! info "Reduce memory allocations"
	Memory must be _pre-allocated_ and _reused_ whenever possible.
"""

# ╔═╡ 25e594c6-e15b-40c2-a3ad-42beea24ef12
md"""
## General advice
"""

# ╔═╡ a9294b70-d032-45d7-8549-180d50e8add6
md"""
- Avoid [global variables](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-global-variables)
- Put critical code [inside functions](https://docs.julialang.org/en/v1/manual/performance-tips/#Performance-critical-code-should-be-inside-a-function)
- If a built-in function or a good package exists, use it
- Beware of [closures](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured) (i.e. functions that return functions)
"""

# ╔═╡ 8908fa2a-95f7-4564-9c44-9febeb614b9d
md"""
## Enable type inference
"""

# ╔═╡ 2d88e638-d64b-4411-85f6-87d26b10814c
md"""
- Functions should [not change variable types](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-changing-the-type-of-a-variable) and [always output the same type](https://docs.julialang.org/en/v1/manual/performance-tips/#Write-%22type-stable%22-functions)
- No abstract types in [container initializations](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-abstract-container), [`struct` fields](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-fields-with-abstract-type) and [`struct` field containers](https://docs.julialang.org/en/v1/manual/performance-tips/#Avoid-fields-with-abstract-containers)
- Leverage [multiple definitions](https://docs.julialang.org/en/v1/manual/performance-tips/#Break-functions-into-multiple-definitions) and [function barriers](https://docs.julialang.org/en/v1/manual/performance-tips/#kernel-functions)
- [Force specialization](https://docs.julialang.org/en/v1/manual/performance-tips/#Be-aware-of-when-Julia-avoids-specializing) if needed
"""

# ╔═╡ e6b33b6b-569d-4ad4-a1a3-70fe2e8acb9d
md"""
## Reduce memory allocations
"""

# ╔═╡ 81ebe951-6952-4911-9ed1-95de188f4744
md"""
- Fix type inference issues first
- Prefer mutating functions ([with a `!`](https://docs.julialang.org/en/v1/manual/style-guide/#bang-convention)) and [pre-allocate](https://docs.julialang.org/en/v1/manual/performance-tips/#Pre-allocating-outputs) outputs
- Use [views instead of slices](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-views) when you don't need copies: `view(A, :, 1)` instead of `A[:, 1]`
- [Fuse vectorized operations](https://docs.julialang.org/en/v1/manual/performance-tips/#More-dots:-Fuse-vectorized-operations)
"""

# ╔═╡ f00b2d65-0a60-464e-9daa-28b8a8fea1f1
md"""
## What you shouldn't do (usually)
"""

# ╔═╡ ada53d3e-00d8-45eb-8d79-c1cfe08f8832
md"""
- Over-specialize types
- Use magic macros like `@simd` or `@inbounds`
- Go straight for parallelism
"""

# ╔═╡ a7f2b6eb-e67e-43fd-b886-4bb788d3d0e9
md"""
# Step 4: diagnose the problems
"""

# ╔═╡ 231673bb-a6e9-4578-bb86-3a58aa61374e
md"""
## Profiling
"""

# ╔═╡ 26ac30ea-c14b-415f-827b-9577eb8fe11e
TwoColumn(
md"""
Main tools

- [Profile standard library](https://docs.julialang.org/en/v1/stdlib/Profile/)
- [VSCode profiler](https://www.julia-vscode.org/docs/stable/userguide/profiler/)
""",
md"""
Also relevant:

- [ProfileCanvas.jl](https://github.com/pfitzseb/ProfileCanvas.jl)
- [ProfileView.jl](https://github.com/timholy/ProfileView.jl)
- [ProfileSVG.jl](https://github.com/kimikage/ProfileSVG.jl)
- [PProf.jl](https://github.com/JuliaPerf/PProf.jl)
"""
)

# ╔═╡ 24f39e1f-da52-4df8-b70d-b11eb58a04fe
ProfileCanvas.@profview gradient_descent(∇f, x0; iterations=10000)

# ╔═╡ 9e9c7ea3-9dd2-4c40-b16b-d6dbcd8c3dd2
md"""
- blue $\implies$ everything is fine
- red $\implies$ "runtime dispatch", a sign of bad type inference
- yellow $\implies$ "garbage collection", a sign of excessive allocations
- gray $\implies$ compilation overhead
"""

# ╔═╡ fbe7b77e-56b2-4839-9f57-42746a6d2c2c
ProfileCanvas.@profview_allocs gradient_descent(∇f, x0; iterations=10000)

# ╔═╡ dbb15720-af54-4d12-8f51-414fd58e1bfb
md"""
## Descending
"""

# ╔═╡ f91e3455-5fa4-46c9-aeaa-12d73638beaf
TwoColumn(
md"""
Main tools

- `Test.@inferred`
- [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl)
- [JET.jl](https://github.com/aviatesk/JET.jl)
""",
md"""
Also relevant:

- [InteractiveUtils standard library](https://docs.julialang.org/en/v1/stdlib/InteractiveUtils/)
"""
)

# ╔═╡ 3b4815e6-2172-454a-8ab2-195b57339573
Test.@inferred matvec(A, x0);

# ╔═╡ e431e92b-1ca1-4e07-a448-9ef6c56bdd3b
Test.@inferred matvec(A, x0)[1];

# ╔═╡ 483ad10f-8e49-4e9a-9bab-4d5b9479b0f6
Test.@inferred gradient_descent(∇f, x0);

# ╔═╡ cf9cd2af-c23d-42e7-bc20-6031f746d2be
md"""
`@code_warntype` is insufficient and hard to read: live demo of Cthulhu.jl and JET.jl in VSCode
"""

# ╔═╡ cf4e22d2-8bdf-434e-879a-49c4b04addfb
md"""
# Step 5: fix the problems
"""

# ╔═╡ 43229e98-3e34-4039-a5b0-86f98a443d8d
md"""
## Write a new function
"""

# ╔═╡ d07c6e96-6707-4a95-93d1-a13af52abff5
function matvec_fast!(res, M, v)
	T = eltype(res)
	n, p = size(M)
	for i in 1:n
		y = zero(T)
		for j in 1:p
			y += M[i, j] * v[j]
		end
		res[i] = y
	end
	return nothing
end

# ╔═╡ 3ed4106d-1ab1-494d-889b-49cd83a29292
function ∇f!(e, g, x, A, b)
	matvec_fast!(e, A, x)
	e .-= b
	matvec_fast!(g, A', e)
	g .*= 2
	return nothing
end

# ╔═╡ db46cde5-3ba5-41a1-93a6-a08e4f169b66
function gradient_descent_fast(∇f!::F, x0, A, b; step=1e-3, iterations=100) where F
	e = similar(b)
	g = similar(x0)
	x = copy(x0)
	for t in 1:iterations
		∇f!(e, g, x, A, b)
		x .-= step .* g
	end
	return x
end

# ╔═╡ d22768d5-357e-49c6-99af-895d7cafc13f
md"""
## Compare with the old
"""

# ╔═╡ 9efc0250-5f0c-4702-a341-49b579d98614
let
	x1 = gradient_descent(∇f, x0)
	x2 = gradient_descent_fast(∇f!, x0, A, b)
	Test.@test isapprox(x1, x2)
end

# ╔═╡ fb0ec3bd-fbf5-4a36-aea8-3c06fbdeb614
BenchmarkTools.@benchmark gradient_descent($∇f, $x0)

# ╔═╡ 17cdf6f2-b0a6-4372-8834-670ec94ae7bf
BenchmarkTools.@benchmark gradient_descent_fast($∇f!, $x0, $A, $b)

# ╔═╡ 37531096-2296-42ad-a128-fbe0ecbd681e
ProfileCanvas.@profview gradient_descent_fast(∇f!, x0, A, b; iterations=100000)

# ╔═╡ ae181427-276d-469c-aacd-7a1cbba5fde4
Test.@inferred gradient_descent_fast(∇f!, x0, A, b; iterations=100);

# ╔═╡ 0dd724ac-72c2-466d-a5ed-c40e5bc10a79
md"""
# Step 6: go further
"""

# ╔═╡ f1260d7a-135f-41d8-8cac-6a59a6270d26
md"""
## Hardware
"""

# ╔═╡ 0b9f8bc6-fd03-410c-84d0-53a4f99948bf
md"""
> What scientists must know about hardware to write fast code
>
> <https://viralinstruction.com/posts/hardware/>
"""

# ╔═╡ 3b163c22-7f66-495d-b77b-6f7138d17f66
md"""
## Magic macros
"""

# ╔═╡ 0ddf7e30-678c-4a25-b7dd-082ab2ec3f0a
TwoColumn(
md"""
Main tools

- [Performance annotations](https://docs.julialang.org/en/v1.9/manual/performance-tips/#man-performance-annotations)
""",
md"""
Also relevant:

- [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl)
"""
)

# ╔═╡ 14d088d5-aa2d-4b6e-a0bc-7a4a24e60231
md"""
## Parallelism
"""

# ╔═╡ 294a64e8-d8fa-4cc5-a514-b82ceb06196e
TwoColumn(
md"""
Main tools

- [Multithreading](https://docs.julialang.org/en/v1/manual/multi-threading/) (shared memory)
- [Multiprocessing](https://docs.julialang.org/en/v1/manual/distributed-computing/) (separate memory)
""",
md"""
Also relevant:

- [FLoops.jl](https://github.com/JuliaFolds/FLoops.jl)
- [ThreadsX.jl](https://github.com/tkf/ThreadsX.jl)
- [JuliaGPU](https://juliagpu.org/)
"""
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ProfileCanvas = "efd6af41-a80b-495e-886c-e51b0c7d77a3"
ProgressLogging = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
BenchmarkTools = "~1.3.2"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
ProfileCanvas = "~0.1.6"
ProgressLogging = "~0.1.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "be66cd1e8ea3e9d884a9df0b6210410bcec059c1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

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
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProfileCanvas]]
deps = ["Base64", "JSON", "Pkg", "Profile", "REPL"]
git-tree-sha1 = "e42571ce9a614c2fbebcaa8aab23bbf8865c624e"
uuid = "efd6af41-a80b-495e-886c-e51b0c7d77a3"
version = "0.1.6"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

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
# ╠═f4b3ab20-5c8f-11ee-22f7-b3466c0a577e
# ╠═99466829-a9d9-4f1e-b35e-0a6a0d26b0a2
# ╟─ca563363-6ae9-42a1-bb42-596e7471e69c
# ╟─e49d8681-e1eb-4c5e-91f2-605b4d1a91b7
# ╟─74767c9a-4ed8-42cc-b7e2-1c31064f505c
# ╟─00d45907-0cc0-4504-83f2-c009e0755a33
# ╟─c76df784-c4fb-47a9-bcdf-b652c8ecacfb
# ╟─83d59131-2638-4e28-9daf-cbe8a14116c6
# ╟─78ba6f3a-7d59-47e5-835e-e7a5b46a435c
# ╟─26d0faea-286e-44a4-a6a0-330f6f202926
# ╠═80ef0e3e-bf19-47f2-bb40-e7bdc0ecb8f7
# ╠═7a6138a1-2878-42db-a6b6-af3acc49a24a
# ╠═5fabe80b-42af-4ef4-b4ec-3975e6c8a375
# ╠═87c68c4b-6f52-4987-aa0a-d491f20f9a98
# ╟─8fa9d282-92ab-4dc1-a0fe-284a200fc384
# ╠═5c659445-3d2a-4aaf-8787-b07835b3c119
# ╠═da3a3d5d-0a46-4fab-9cd2-148723005775
# ╟─75b55303-3c1a-4ce0-8529-a906a32963e7
# ╟─0b4ac025-a4c9-41aa-b659-136e1dcd4cab
# ╟─e88aa63f-0496-4daf-a1a6-9280d5507d8a
# ╠═67a3469f-a119-4e30-bbaa-a5ff30b7acfe
# ╠═01d7fbbd-5956-4090-b42f-fdfbce05752f
# ╟─f44fffde-86ce-462a-9a3c-8723321cbe80
# ╟─cda8439a-9e7b-4391-8402-6591001029f7
# ╠═d5cbf68c-8e89-4449-b053-e5d762139419
# ╠═c364957f-2335-4c6d-823e-c36f0dd2290d
# ╠═d90bf5e7-e9b7-4d63-ac68-bab207df658c
# ╟─6299891d-a628-4056-955b-e490d937c591
# ╟─03b9e227-7079-43be-b78e-f4d587b24f37
# ╟─49f452c5-e8fc-4f8d-a2ea-046ab3e0dbba
# ╟─25e594c6-e15b-40c2-a3ad-42beea24ef12
# ╟─a9294b70-d032-45d7-8549-180d50e8add6
# ╟─8908fa2a-95f7-4564-9c44-9febeb614b9d
# ╟─2d88e638-d64b-4411-85f6-87d26b10814c
# ╟─e6b33b6b-569d-4ad4-a1a3-70fe2e8acb9d
# ╟─81ebe951-6952-4911-9ed1-95de188f4744
# ╟─f00b2d65-0a60-464e-9daa-28b8a8fea1f1
# ╟─ada53d3e-00d8-45eb-8d79-c1cfe08f8832
# ╟─a7f2b6eb-e67e-43fd-b886-4bb788d3d0e9
# ╟─231673bb-a6e9-4578-bb86-3a58aa61374e
# ╟─26ac30ea-c14b-415f-827b-9577eb8fe11e
# ╠═24f39e1f-da52-4df8-b70d-b11eb58a04fe
# ╟─9e9c7ea3-9dd2-4c40-b16b-d6dbcd8c3dd2
# ╠═fbe7b77e-56b2-4839-9f57-42746a6d2c2c
# ╟─dbb15720-af54-4d12-8f51-414fd58e1bfb
# ╟─f91e3455-5fa4-46c9-aeaa-12d73638beaf
# ╠═3b4815e6-2172-454a-8ab2-195b57339573
# ╠═e431e92b-1ca1-4e07-a448-9ef6c56bdd3b
# ╠═483ad10f-8e49-4e9a-9bab-4d5b9479b0f6
# ╟─cf9cd2af-c23d-42e7-bc20-6031f746d2be
# ╟─cf4e22d2-8bdf-434e-879a-49c4b04addfb
# ╟─43229e98-3e34-4039-a5b0-86f98a443d8d
# ╠═d07c6e96-6707-4a95-93d1-a13af52abff5
# ╠═3ed4106d-1ab1-494d-889b-49cd83a29292
# ╠═db46cde5-3ba5-41a1-93a6-a08e4f169b66
# ╟─d22768d5-357e-49c6-99af-895d7cafc13f
# ╠═9efc0250-5f0c-4702-a341-49b579d98614
# ╠═fb0ec3bd-fbf5-4a36-aea8-3c06fbdeb614
# ╠═17cdf6f2-b0a6-4372-8834-670ec94ae7bf
# ╠═37531096-2296-42ad-a128-fbe0ecbd681e
# ╠═ae181427-276d-469c-aacd-7a1cbba5fde4
# ╟─0dd724ac-72c2-466d-a5ed-c40e5bc10a79
# ╟─f1260d7a-135f-41d8-8cac-6a59a6270d26
# ╟─0b9f8bc6-fd03-410c-84d0-53a4f99948bf
# ╟─3b163c22-7f66-495d-b77b-6f7138d17f66
# ╟─0ddf7e30-678c-4a25-b7dd-082ab2ec3f0a
# ╟─14d088d5-aa2d-4b6e-a0bc-7a4a24e60231
# ╟─294a64e8-d8fa-4cc5-a514-b82ceb06196e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
