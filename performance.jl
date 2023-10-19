### A Pluto.jl notebook ###
# v0.19.29

#> [frontmatter]
#> title = "IntroJulia - Performance"
#> 
#>     [[frontmatter.author]]
#>     name = "Guillaume Dalle"
#>     url = "https://gdalle.github.io/"

using Markdown
using InteractiveUtils

# ╔═╡ f4b3ab20-5c8f-11ee-22f7-b3466c0a577e
begin
	import BenchmarkTools
	using JET
	using LinearAlgebra
	using Pluto
	using PlutoUI
	using PlutoTeachingTools
	import ProfileCanvas
	import ProgressLogging
	import Test
end

# ╔═╡ 99466829-a9d9-4f1e-b35e-0a6a0d26b0a2
TableOfContents()

# ╔═╡ 46d7f0d8-cf41-4fcf-a5c2-baa85e8afcb1
struct SplitTwoColumn{L, R}
	left::L
	right::R
end

# ╔═╡ b2a160c0-2c38-4484-afd4-a917d6065eaa
function Base.show(io, mime::MIME"text/html", tc::SplitTwoColumn)
	write(io, """<div style="display: flex;"><div style="flex: 47%;">""")
	show(io, mime, tc.left)
	write(io, """</div><div style="flex: 6%;">""")
	write(io, """</div><div style="flex: 47%;">""")
	show(io, mime, tc.right)
	write(io, """</div></div>""")
end

# ╔═╡ e49d8681-e1eb-4c5e-91f2-605b4d1a91b7
md"""
# Performance

_Writing fast Julia_
"""

# ╔═╡ 72c0f5c8-fc2b-4b50-9c05-ea8c79990f2a
SplitTwoColumn(
	md"""
> Poll: [Wooclap link](https://app.wooclap.com/JULIAPERF)
!!! tip "Primary sources"
	[Performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/) in the Julia manual
	""",
	md"""
!!! tip "Secondary sources"
	[How to optimise Julia code: A practical guide](https://viralinstruction.com/posts/optimise/)
	by Jakob Nybo Nissen
"""
)

# ╔═╡ 6299891d-a628-4056-955b-e490d937c591
md"""
# 1. The theory
"""

# ╔═╡ 552a3098-1cb7-49b9-b322-1c0888bd80d7
md"""
## Remember these two principles
"""

# ╔═╡ 03b9e227-7079-43be-b78e-f4d587b24f37
SplitTwoColumn(md"""
!!! danger "Enable type inference"
	The type of every variable must be inferrable using only the type of the inputs.
""",
md"""
!!! danger "Reduce memory allocations"
	Memory must be pre-allocated and reused whenever possible.
"""
)

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

# ╔═╡ 5ddc8911-1e27-49ca-a719-d04f376f7bfe
md"""
## Generic programming
"""

# ╔═╡ 1df4995a-d572-4ad6-a7c2-94c1d72fc085
md"""
- Don't over-specialize types
- Let other people find new ways to use your code
"""

# ╔═╡ f00b2d65-0a60-464e-9daa-28b8a8fea1f1
md"""
## What you shouldn't do (usually)
"""

# ╔═╡ ada53d3e-00d8-45eb-8d79-c1cfe08f8832
md"""
- Go straight for parallelism
- Use magic macros like `@simd` or `@inbounds`
"""

# ╔═╡ 75b55303-3c1a-4ce0-8529-a906a32963e7
md"""
# 2. The toolbox
"""

# ╔═╡ 1c91ee42-84a4-421f-a0e3-9a2179f3a9df
md"""
## Diagnose first, fix later
"""

# ╔═╡ fe960fd5-973b-4f34-80bc-691b035ebbc4
blockquote("Premature optimization is the root of all evil. (Donald Knuth)")

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
	@time x .= x .+ y
end;

# ╔═╡ c364957f-2335-4c6d-823e-c36f0dd2290d
let
	x, y = rand(3), rand(3)
	BenchmarkTools.@btime $x .= $x .+ $y
end;

# ╔═╡ d90bf5e7-e9b7-4d63-ac68-bab207df658c
bench = BenchmarkTools.@benchmark x .= x .+ y setup=(x=rand(3); y=rand(3))

# ╔═╡ 231673bb-a6e9-4578-bb86-3a58aa61374e
md"""
## Profiling
"""

# ╔═╡ 26ac30ea-c14b-415f-827b-9577eb8fe11e
TwoColumn(
md"""
Main tools:

- [VSCode profiler](https://www.julia-vscode.org/docs/stable/userguide/profiler/)
- [ProfileView.jl](https://github.com/timholy/ProfileView.jl)
""",
md"""
Also relevant:

- [ProfileCanvas.jl](https://github.com/pfitzseb/ProfileCanvas.jl)
- [ProfileSVG.jl](https://github.com/kimikage/ProfileSVG.jl)
- [PProf.jl](https://github.com/JuliaPerf/PProf.jl)
- [Profile standard library](https://docs.julialang.org/en/v1/stdlib/Profile/)
"""
)

# ╔═╡ 9e9c7ea3-9dd2-4c40-b16b-d6dbcd8c3dd2
md"""
Color code:
- blue $\implies$ everything is fine
- red $\implies$ "runtime dispatch", a sign of bad type inference
- yellow $\implies$ "garbage collection", a sign of excessive allocations
- gray $\implies$ compilation overhead
"""

# ╔═╡ 19783972-7674-48ef-b6f9-887dbac379ce
begin
	struct MatrixMultiplier
		A
	end
	
	function (mm::MatrixMultiplier)(b::Vector)
		return mm.A * b
	end
end

# ╔═╡ a5060ea2-7001-43ab-9201-e7d1cda33dbd
begin
	function testfunction(A)
		matmul = MatrixMultiplier(A)
		n, m = length(A[:, 1]), length(A[1, :])
		b = rand(m)
		c = matmul(b)
		l = sum(abs2(c[i]) for i in 1:n)
		return sqrt(l)
	end

	testfunction(rand(2, 2))
end;

# ╔═╡ 24f39e1f-da52-4df8-b70d-b11eb58a04fe
let
	A = rand(100, 50)
	ProfileCanvas.@profview for k in 1:10_000; testfunction(A); end
end

# ╔═╡ fbe7b77e-56b2-4839-9f57-42746a6d2c2c
let
	A = rand(100, 50)
	ProfileCanvas.@profview_allocs for k in 1:10_000; testfunction(A); end
end

# ╔═╡ dbb15720-af54-4d12-8f51-414fd58e1bfb
md"""
## Descending
"""

# ╔═╡ f91e3455-5fa4-46c9-aeaa-12d73638beaf
TwoColumn(
md"""
Main tools:

- `Test.@inferred`
- [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl)
- [JET.jl](https://github.com/aviatesk/JET.jl)
""",
md"""
Also relevant:

- [InteractiveUtils standard library](https://docs.julialang.org/en/v1/stdlib/InteractiveUtils/)
- Debugger
"""
)

# ╔═╡ 8d63d676-19f5-47b1-a5d6-20576f03de3b
let
	A = rand(10, 20)
	Test.@inferred testfunction(A)
end

# ╔═╡ f29f7200-a70b-4713-bd92-4d6e1717aea1
with_terminal() do
	A = rand(10, 20)
	InteractiveUtils.@code_warntype testfunction(A)
end

# ╔═╡ 1f68d003-a2c3-4f30-901d-831ff656a101
md"""
Unfortunately, `@inferred` and `@code_warntype` only go one level down: they're blind to what happens deeper in the call stack.
"""

# ╔═╡ 9f052683-c12a-4439-b1ee-7e5d380656db
function testfunctionwrapper(A)
	testfunction(A)
	return true
end

# ╔═╡ fb48aea6-0d44-4efb-8412-7c1aad5bc70a
let
	A = rand(10, 20)
	Test.@inferred testfunctionwrapper(A)
end

# ╔═╡ e13f7d0c-dc6a-493e-8fe8-4507ca60f192
with_terminal() do
	A = rand(10, 20)
	InteractiveUtils.@code_warntype testfunctionwrapper(A)
end

# ╔═╡ e3990f5a-a5e9-492f-8892-c3a531acf680
md"""
On the other hand, JET.jl and Cthulhu.jl inspect the full call stack for type inference issues.
"""

# ╔═╡ 6c84678c-5d21-4e8e-ad88-c75dd9969d4e
let
	A = rand(10, 20)
	JET.@report_opt testfunctionwrapper(A)
end

# ╔═╡ 4f101b1e-4932-481f-889f-bf42104a278d
md"""
The latest version of Cthulhu.jl is best used in VSCode, cue live demo.
"""

# ╔═╡ 83d59131-2638-4e28-9daf-cbe8a14116c6
md"""
# 3. The practice
"""

# ╔═╡ 8df3e36b-942d-49a3-bdf8-a75db1877e34
md"""
Linear regression is an optimization problem
```math
\min_x f(x) = \lVert Ax - b \rVert^2
```
whose objective has gradient
```math
\nabla f(x) = 2A^\top (Ax - b)
```
"""

# ╔═╡ bfc0b87c-6c05-43ae-88d5-40e10c2a6374
md"""
We study the following gradient descent algorithm:

1. Initialize $x = x_0$
2. For $n$ iterations, update $x = x - \gamma \nabla f(x)$

We use these values for the parameters: $x_0 = 0$, $n = 100$ and $\gamma = 10^{-3}$.
"""

# ╔═╡ 3b9abb50-72c8-48e7-b815-d8f086c44792
md"""
## Implementation
"""

# ╔═╡ fe38657c-fa30-4575-ad33-0d1571d26a9e
SplitTwoColumn(
	md"""
!!! warning "Group 1"
	Write the slowest reasonable implementation of gradient descent for linear regression that you can think of.
	""",
	md"""
!!! warning "Group 2"
	Write the slowest reasonable implementation of gradient descent for linear regression that you can think of.
	"""
)

# ╔═╡ dd888356-90ae-4bf0-8548-3994462af5ef
md"""
**Constraints:**

- The structure should be the same: initialization, update loop, return
- No cheating with functions like `sleep`
- Built-in linear algebra is forbidden: reimplement multiplications yourself
- The end results should be equal up to numerical accuracy
"""

# ╔═╡ add1e0fe-6655-4a57-9baa-658b010aa154
md"""
## Discussion
"""

# ╔═╡ 0dd724ac-72c2-466d-a5ed-c40e5bc10a79
md"""
# 4. The rabbit hole
"""

# ╔═╡ 745d023f-6487-4aab-b9cd-381aedaaf305
md"""
## Hardware
"""

# ╔═╡ 58e0cc49-bed7-48ad-a6f1-e32047a00e96
md"""
!!! tip "Secondary source"
	[What scientists must know about hardware to write fast code](https://viralinstruction.com/posts/hardware/) by Jakob Nybo Nissen
"""

# ╔═╡ 14d088d5-aa2d-4b6e-a0bc-7a4a24e60231
md"""
## Parallelism
"""

# ╔═╡ 294a64e8-d8fa-4cc5-a514-b82ceb06196e
TwoColumn(
md"""
Main tools:

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

# ╔═╡ 3b163c22-7f66-495d-b77b-6f7138d17f66
md"""
## Magic macros
"""

# ╔═╡ 0ddf7e30-678c-4a25-b7dd-082ab2ec3f0a
TwoColumn(
md"""
Main tools:

- [Performance annotations](https://docs.julialang.org/en/v1.9/manual/performance-tips/#man-performance-annotations)
""",
md"""
Also relevant:

- [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl)
"""
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
JET = "c3a54625-cd67-489e-a8e7-0a5a0ff4e31b"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ProfileCanvas = "efd6af41-a80b-495e-886c-e51b0c7d77a3"
ProgressLogging = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
BenchmarkTools = "~1.3.2"
JET = "~0.8.15"
Pluto = "~0.19.29"
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
project_hash = "afdd2b6617fe2e57e340ff30c9d016784e71c8ab"

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

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "4358750bb58a3caefd5f37a4a0c5bfdbbf075252"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.6"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

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

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.ExproniconLite]]
git-tree-sha1 = "637309d52dd9034af79c9df9b5f07a824e30ca2f"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.4"

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

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "001bd0eefc8c532660676725bed56b696321dfd2"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.5.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

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

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JET]]
deps = ["InteractiveUtils", "JuliaInterpreter", "LoweredCodeUtils", "MacroTools", "Pkg", "PrecompileTools", "Preferences", "Revise", "Test"]
git-tree-sha1 = "cafbe8e8452ecbb5187101347db682a3b9466164"
uuid = "c3a54625-cd67-489e-a8e7-0a5a0ff4e31b"
version = "0.8.15"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

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

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "410fe4739a4b092f2ffe36fcb0dcc3ab12648ce1"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.2.1"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

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

[[deps.Malt]]
deps = ["Distributed", "Logging", "RelocatableFolders", "Serialization", "Sockets"]
git-tree-sha1 = "5333200b6a2c49c2de68310cede765ebafa255ea"
uuid = "36869731-bdee-424d-aa32-cab38c994e3b"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "fc8c15ca848b902015bd4a745d350f02cf791c2a"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.2.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

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

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "FileWatching", "FuzzyCompletions", "HTTP", "HypertextLiteral", "InteractiveUtils", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PrecompileSignatures", "PrecompileTools", "REPL", "RegistryInstances", "RelocatableFolders", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "5d03fac7fb58345c186431e55ddd3aa8d828c1a5"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.19.29"

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

[[deps.PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

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

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

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

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

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
# ╟─46d7f0d8-cf41-4fcf-a5c2-baa85e8afcb1
# ╟─b2a160c0-2c38-4484-afd4-a917d6065eaa
# ╟─e49d8681-e1eb-4c5e-91f2-605b4d1a91b7
# ╟─72c0f5c8-fc2b-4b50-9c05-ea8c79990f2a
# ╟─6299891d-a628-4056-955b-e490d937c591
# ╟─552a3098-1cb7-49b9-b322-1c0888bd80d7
# ╟─03b9e227-7079-43be-b78e-f4d587b24f37
# ╟─25e594c6-e15b-40c2-a3ad-42beea24ef12
# ╟─a9294b70-d032-45d7-8549-180d50e8add6
# ╟─8908fa2a-95f7-4564-9c44-9febeb614b9d
# ╟─2d88e638-d64b-4411-85f6-87d26b10814c
# ╟─e6b33b6b-569d-4ad4-a1a3-70fe2e8acb9d
# ╟─81ebe951-6952-4911-9ed1-95de188f4744
# ╟─5ddc8911-1e27-49ca-a719-d04f376f7bfe
# ╟─1df4995a-d572-4ad6-a7c2-94c1d72fc085
# ╟─f00b2d65-0a60-464e-9daa-28b8a8fea1f1
# ╟─ada53d3e-00d8-45eb-8d79-c1cfe08f8832
# ╟─75b55303-3c1a-4ce0-8529-a906a32963e7
# ╟─1c91ee42-84a4-421f-a0e3-9a2179f3a9df
# ╟─fe960fd5-973b-4f34-80bc-691b035ebbc4
# ╟─0b4ac025-a4c9-41aa-b659-136e1dcd4cab
# ╟─e88aa63f-0496-4daf-a1a6-9280d5507d8a
# ╠═67a3469f-a119-4e30-bbaa-a5ff30b7acfe
# ╠═01d7fbbd-5956-4090-b42f-fdfbce05752f
# ╟─f44fffde-86ce-462a-9a3c-8723321cbe80
# ╟─cda8439a-9e7b-4391-8402-6591001029f7
# ╠═d5cbf68c-8e89-4449-b053-e5d762139419
# ╠═c364957f-2335-4c6d-823e-c36f0dd2290d
# ╠═d90bf5e7-e9b7-4d63-ac68-bab207df658c
# ╟─231673bb-a6e9-4578-bb86-3a58aa61374e
# ╟─26ac30ea-c14b-415f-827b-9577eb8fe11e
# ╟─9e9c7ea3-9dd2-4c40-b16b-d6dbcd8c3dd2
# ╠═19783972-7674-48ef-b6f9-887dbac379ce
# ╠═a5060ea2-7001-43ab-9201-e7d1cda33dbd
# ╠═24f39e1f-da52-4df8-b70d-b11eb58a04fe
# ╠═fbe7b77e-56b2-4839-9f57-42746a6d2c2c
# ╟─dbb15720-af54-4d12-8f51-414fd58e1bfb
# ╟─f91e3455-5fa4-46c9-aeaa-12d73638beaf
# ╠═8d63d676-19f5-47b1-a5d6-20576f03de3b
# ╠═f29f7200-a70b-4713-bd92-4d6e1717aea1
# ╟─1f68d003-a2c3-4f30-901d-831ff656a101
# ╠═9f052683-c12a-4439-b1ee-7e5d380656db
# ╠═fb48aea6-0d44-4efb-8412-7c1aad5bc70a
# ╠═e13f7d0c-dc6a-493e-8fe8-4507ca60f192
# ╟─e3990f5a-a5e9-492f-8892-c3a531acf680
# ╠═6c84678c-5d21-4e8e-ad88-c75dd9969d4e
# ╟─4f101b1e-4932-481f-889f-bf42104a278d
# ╟─83d59131-2638-4e28-9daf-cbe8a14116c6
# ╟─8df3e36b-942d-49a3-bdf8-a75db1877e34
# ╟─bfc0b87c-6c05-43ae-88d5-40e10c2a6374
# ╟─3b9abb50-72c8-48e7-b815-d8f086c44792
# ╟─fe38657c-fa30-4575-ad33-0d1571d26a9e
# ╟─dd888356-90ae-4bf0-8548-3994462af5ef
# ╟─add1e0fe-6655-4a57-9baa-658b010aa154
# ╟─0dd724ac-72c2-466d-a5ed-c40e5bc10a79
# ╟─745d023f-6487-4aab-b9cd-381aedaaf305
# ╟─58e0cc49-bed7-48ad-a6f1-e32047a00e96
# ╟─14d088d5-aa2d-4b6e-a0bc-7a4a24e60231
# ╟─294a64e8-d8fa-4cc5-a514-b82ceb06196e
# ╟─3b163c22-7f66-495d-b77b-6f7138d17f66
# ╟─0ddf7e30-678c-4a25-b7dd-082ab2ec3f0a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
