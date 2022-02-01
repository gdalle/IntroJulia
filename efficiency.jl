### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ bca07932-eb86-40e3-9b47-aace0efda5d0
using PlutoUI, Profile, ProfileSVG, BenchmarkTools, ProgressMeter

# ╔═╡ 0212b449-3bdc-4a8f-81b3-38432ff39785
md"""
> 🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 5de2a556-f3af-4a64-a5c6-32d30f758be3
TableOfContents()

# ╔═╡ 9331fad2-f29e-11eb-0349-477bd2e7e412
md"""
# Monitoring code performance

Before trying to improve the efficiency of our code, it is essential to analyze it and see where the "bottlenecks" are.
"""

# ╔═╡ 62eeeb90-8bdf-4a70-bcef-ab31136c264c
md"""
## Running example: linear recursions

Here we will compare several ways to compute sequences ``(x_n)`` given by initial values ``x_i = y_i`` for ``i \in [d]`` and the following recursive definition:
```math
    x_n = w_1 x_{n-1} + ... + w_d x_{n-d}
```
"""

# ╔═╡ 781a7cdd-d36e-40b4-9de1-f832cba41377
function seq_rec(w, y, n)
	d = length(w)
	if n <= d
		return y[n]
	else
		return sum([w[i] * seq_rec(w, y, n-i) for i = 1:d])
	end
end

# ╔═╡ 75010618-78e8-4490-83bb-158c781afa30
function seq_loop1(w, y, n)
	d = length(w)
	x = similar(y, n)
	for k = 1:n
		if k <= d
			x[k] = y[k]
		else
			x[k] = sum([w[i] * x[k-i] for i = 1:d])
		end
	end
	return x[n]
end

# ╔═╡ 8fd4bbea-6c88-4302-b8b6-128aff82db48
function seq_loop2(w, y, n)
	d = length(w)
	x = similar(y, n)
	for k = 1:n
		if k <= d
			x[k] = y[k]
		else
			x[k] = sum(w[i] * x[k-i] for i = 1:d)
		end
	end
	return x[n]
end

# ╔═╡ f9b8eed6-c289-4b41-828d-fd469fd3a321
wfib, yfib = [1, 1], [1, 1]

# ╔═╡ 2b7a5cdb-8154-4009-ac63-57749b6cc5d3
seq_rec(wfib, yfib, 10)

# ╔═╡ a0e1699d-4a2b-42dc-9c65-8f91d7a352a7
seq_loop1(wfib, yfib, 10)

# ╔═╡ 504f229e-5d35-41c9-af8e-3463ed29c9c9
seq_loop2(wfib, yfib, 10)

# ╔═╡ 3d98e7db-c643-4500-987d-4a225e55b2a5
md"""
### Tracking loops

In long-running code, the best way to track loops is not a periodic `println(i)`. There are packages designed for this purpose, such as [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl). However, they do not work in Pluto notebooks since all cells are computed "simultaneously". Here's an example of what it looks like in the REPL.
"""

# ╔═╡ b4f2a99e-de45-49d2-be86-9f2d03357462
with_terminal() do
	@showprogress 1 "Computing..." for i in 1:50
    	sleep(0.1)
	end
end

# ╔═╡ f7b1b44f-2aa6-4c5c-97a2-ac7037fb48ce
md"""
## Benchmarking

To evaluate the efficiency of a function, we need to know how long it takes and how much memory it uses. Base Julia includes macros for these things:
- `@elapsed` returns the computation time (in seconds)
- `@allocated` returns the allocated memory (in bytes)
- `@time` prints both (in the REPL!) and returns the function result
"""

# ╔═╡ 299e7754-b4e9-4c53-83d6-6f30e130ed01
f1(n) = inv(rand(n, n))

# ╔═╡ 1fb43343-083b-4b1a-b622-d88c9aa0808c
@elapsed f1(100)

# ╔═╡ a28f7911-3dbb-45fb-a82d-2834d3c8502c
@allocated f1(100)

# ╔═╡ 4da8a7ca-3cea-4629-a66d-44f3b907af09
with_terminal() do
	@time f1(100)
end

# ╔═╡ c0a7c1fe-457f-4e52-b0ea-2821e40817ea
md"""
Since we have small functions here, we would get a more accurate evaluation by running them repeatedly. This is what package [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) does with the following macros:
- `@belapsed` for time
- `@ballocated` for space
- `@benchmark` for both
"""

# ╔═╡ 64189969-f5b2-49cf-a2e9-d837e76ed79d
w, y = randn(5), randn(5)

# ╔═╡ 834f6172-15bc-4e7d-ae22-e18ef2e8e22b
@benchmark $seq_rec($w, $y, 20)

# ╔═╡ a0f3b8a4-a0c6-43b4-b55c-641b14d4f05a
@benchmark $seq_loop1($w, $y, 1000)

# ╔═╡ 63a87cc9-e078-4390-bfb9-eab65e251a30
@benchmark $seq_loop2($w, $y, 1000)

# ╔═╡ 1d0af35c-0cee-4f70-9346-014ab294a614
md"""
Unsurprisingly, `seq_rec` is much slower than the loop-based functions, because the same values are computed multiple times in the recursion tree. The difference in performance between `seq_loop1` and `sec_loop2` is due to excessive allocations in the first one: on line 8, it is not necessary to create an array before computing the sum!
"""

# ╔═╡ 94c78148-c651-4a59-9e62-5c7e9576d1e8
md"""
## Profiling

Sometimes it is not enough to measure the time taken by the whole program: you have to dig in and separate the influence of each subfunction. This is what [profiling](https://docs.julialang.org/en/v1/manual/profile/) is about. What the basic `@profile` macro does is run your function and ping it periodically to figure out in which subroutine it currently is. The ping count in each nested call gives a good approximation of the computation time, and can help you detect bottlenecks. 

Note that you should always run the function once to compile it before profiling it, otherwise the compilation time will bias your analysis.
"""

# ╔═╡ 4df3ba6b-49d4-4d65-8839-bb8976ab8b8c
with_terminal() do
	@profile seq_loop2(w, y, 10^7)
	Profile.print(sortedby=:count, format=:tree)
end

# ╔═╡ 46422b77-ae0a-4174-9c73-4f6399b63b5d
md"""
As you can see, this is not very pleasant to work with. Profiling results are much easier to analyze with the help of a flame graph. To generate one, we will use [ProfileSVG.jl](https://github.com/kimikage/ProfileSVG.jl).
"""

# ╔═╡ 7c57439e-77c6-4e3f-bace-d7ebc428cac9
@profview seq_loop2(w, y, 10^7)

# ╔═╡ 091d3e08-9ae3-4b33-be00-de62a5998c80
md"""
Each layer of the flame graph represents one level of the call stack (the nested sequence of functions that are called by your code). The width of a tile is proportional to its execution time.
Let's disregard the right-hand part (which is caused by Pluto using multiprocessing) and focus on the left-hand part. This tells us that most of the computation is spent in the sum, more specifically in the iteration part.

Maybe there is a more efficient version, for instance one that uses matrix powers? Try to code it and compare it with the previous ones.
"""

# ╔═╡ 0fb6ed33-601c-4392-b7d9-32230c979d39
md"""
# Improving code performance

Once we know what parts of our code take the most time, we can try to optimize them. The primary source for this section is the Julia language manual, more specifically its [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/), but I also used some other inspirations [1](www.stochasticlifestyle.com/7-julia-gotchas-handle/) [2](https://www.juliafordatascience.com/performance-tips/).
"""

# ╔═╡ a6e9da76-1ff0-4b54-9b55-4856ca32b251
md"""
## General advice

- Loops are often faster than vectorized operations, unlike in Python and R
- Avoid global variables (or turn them into constants with the keyword const)
"""

# ╔═╡ fa483fea-bf9f-4764-8d4f-c6d33e3336fb
md"""
## Memory allocations

- Prefer in-place operations
- Pre-allocate output memory
- Use views (`@view a[:, 1]`) instead of array slices when you don't need to modify them
"""

# ╔═╡ d3c1a86c-8c8f-4ad6-ac3c-2ba0f838d139
md"""
## Typing

Julia is fast when it can infer the type of each variable at compiletime (i.e. before runtime): we must help type inference when we can:
- Avoid using abstract types in strategic places: container initializations, field declarations
- Write type-stable code (make sure variable types do not change, even though they are allowed to)
- Use `@code_warntype` or [JET.jl](https://github.com/aviatesk/JET.jl) to debug type instabilities

"""

# ╔═╡ 1067868e-2ca8-463f-bc55-c444aaf3b37c
md"""
We now illustrate the impact of abstract types within a struct.
"""

# ╔═╡ dacdb662-f46d-4032-a8b8-cdfbaf5317fc
abstract type Point end

# ╔═╡ 22b04135-f762-4331-8091-c8c3fa46655f
struct StupidPoint <: Point
    x::Real
    y::Real
end

# ╔═╡ 40d777cc-7cf0-44f7-b179-fe3abbf4e030
struct CleverPoint <: Point
    x::Float64
    y::Float64
end

# ╔═╡ bb734c3b-d981-4473-aa04-9262206ee746
struct GeniusPoint{CoordType <: Real} <: Point
    x::CoordType
    y::CoordType
end

# ╔═╡ 758b6eb0-f61d-4772-a270-f55fac65d56a
norm(p::Point) = sqrt(p.x^2 + p.y^2)

# ╔═╡ 262f7aa1-5072-4376-92db-4241370ec303
begin
	p_stupid = StupidPoint(1., 2.)
	p_clever = CleverPoint(1., 2.)
	p_genius = GeniusPoint(1., 2.)
end

# ╔═╡ f352b77a-4e83-4c84-bdcb-9d024b25673f
@benchmark $norm($p_stupid)

# ╔═╡ 9ce1abc9-5377-4fba-a059-3596cbdd3bcd
@benchmark $norm($p_clever)

# ╔═╡ 44967cf2-8aff-4b85-aa4a-5833b9b29ab5
@benchmark $norm($p_genius)

# ╔═╡ c1310939-87c2-405f-94d6-c7d1310ff700
md"""
We see that the last two implementations are almost two orders of magnitude faster, because they tell the compiler what to expect in terms of attribute types. Note that a `GeniusPoint` can have coordinates of any `Real` type, just like a `StupidPoint`, but the parametric typing makes inference easier.
"""

# ╔═╡ 99df78f5-61ac-49b3-b5ad-5fe5cdeffec5
@code_typed norm(p_stupid)

# ╔═╡ 1500ca48-f99c-4ea0-beb7-bcadedf11d23
@code_typed norm(p_genius)

# ╔═╡ e7c68548-a654-40dd-9b3a-10ce24b6cd5c
md"""
We now demonstrate the impact of type instabilities in functions.
"""

# ╔═╡ 1730eb08-7cbb-46e5-90fc-f216b9d0d17d
function unstable_sum(x)
    s = 0
    for val in x
        s += val
    end
    return s
end

# ╔═╡ c51f5a0c-7ee0-419c-b0e4-1bdf5fb2f075
function stable_sum(x)
    s = zero(eltype(x))
    for val in x
        s += val
    end
    return s
end

# ╔═╡ dfb1dd6f-3d4d-40f4-b8a7-fc24c719b73d
array_to_sum = rand(Float64, 100)

# ╔═╡ 69d3196a-3a5c-4b60-9d61-04b79c438991
@benchmark $unstable_sum($array_to_sum)

# ╔═╡ 5283a72d-30d2-41d7-afa7-b5df4ee15194
@benchmark $stable_sum($array_to_sum)

# ╔═╡ fdf97758-26c1-4157-a5d1-af89578f6277
md"""
## Generic programming

The key feature of Julia is multiple dispatch, which allows the right method to be chosen based on argument types. This is what allows multiple packages to work together seamlessly, but to do that we must remain as generic as possible:
- Do not overspecify input types
- Write smaller dispatchable functions instead of `if - else` blocks
See this [blog post](https://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/) for more details.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Profile = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
ProfileSVG = "132c30aa-f267-4189-9183-c8a63c7e05e6"
ProgressMeter = "92933f4c-e287-5a05-a399-4b506db050ca"

[compat]
BenchmarkTools = "~1.1.3"
PlutoUI = "~0.7.9"
ProfileSVG = "~0.2.1"
ProgressMeter = "~1.7.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "42ac5e523869a84eac9669eaceed9e4aa0e1587b"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "67551df041955cc6ee2ed098718c8fcd7fc7aebe"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.12.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.FlameGraphs]]
deps = ["AbstractTrees", "Colors", "FileIO", "FixedPointNumbers", "IndirectArrays", "LeftChildRightSiblingTrees", "Profile"]
git-tree-sha1 = "d9eee53657f6a13ee51120337f98684c9c702264"
uuid = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"
version = "0.2.10"

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

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "b864cb409e8e445688bc478ef87c0afe4f6d1f8d"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.1.3"

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
git-tree-sha1 = "0b5cfbb704034b5b4c1869e36634438a047df065"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "ae6145ca68947569058866e443df69587acc1806"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.32"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProfileSVG]]
deps = ["Colors", "FlameGraphs", "Profile", "UUIDs"]
git-tree-sha1 = "e4df82a5dadc26736f106f8d7fc97c42cc6c91ae"
uuid = "132c30aa-f267-4189-9183-c8a63c7e05e6"
version = "0.2.1"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

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
# ╟─0212b449-3bdc-4a8f-81b3-38432ff39785
# ╠═bca07932-eb86-40e3-9b47-aace0efda5d0
# ╠═5de2a556-f3af-4a64-a5c6-32d30f758be3
# ╟─9331fad2-f29e-11eb-0349-477bd2e7e412
# ╟─62eeeb90-8bdf-4a70-bcef-ab31136c264c
# ╠═781a7cdd-d36e-40b4-9de1-f832cba41377
# ╠═75010618-78e8-4490-83bb-158c781afa30
# ╠═8fd4bbea-6c88-4302-b8b6-128aff82db48
# ╠═f9b8eed6-c289-4b41-828d-fd469fd3a321
# ╠═2b7a5cdb-8154-4009-ac63-57749b6cc5d3
# ╠═a0e1699d-4a2b-42dc-9c65-8f91d7a352a7
# ╠═504f229e-5d35-41c9-af8e-3463ed29c9c9
# ╟─3d98e7db-c643-4500-987d-4a225e55b2a5
# ╠═b4f2a99e-de45-49d2-be86-9f2d03357462
# ╟─f7b1b44f-2aa6-4c5c-97a2-ac7037fb48ce
# ╠═299e7754-b4e9-4c53-83d6-6f30e130ed01
# ╠═1fb43343-083b-4b1a-b622-d88c9aa0808c
# ╠═a28f7911-3dbb-45fb-a82d-2834d3c8502c
# ╠═4da8a7ca-3cea-4629-a66d-44f3b907af09
# ╟─c0a7c1fe-457f-4e52-b0ea-2821e40817ea
# ╠═64189969-f5b2-49cf-a2e9-d837e76ed79d
# ╠═834f6172-15bc-4e7d-ae22-e18ef2e8e22b
# ╠═a0f3b8a4-a0c6-43b4-b55c-641b14d4f05a
# ╠═63a87cc9-e078-4390-bfb9-eab65e251a30
# ╟─1d0af35c-0cee-4f70-9346-014ab294a614
# ╟─94c78148-c651-4a59-9e62-5c7e9576d1e8
# ╠═4df3ba6b-49d4-4d65-8839-bb8976ab8b8c
# ╟─46422b77-ae0a-4174-9c73-4f6399b63b5d
# ╠═7c57439e-77c6-4e3f-bace-d7ebc428cac9
# ╟─091d3e08-9ae3-4b33-be00-de62a5998c80
# ╟─0fb6ed33-601c-4392-b7d9-32230c979d39
# ╟─a6e9da76-1ff0-4b54-9b55-4856ca32b251
# ╟─fa483fea-bf9f-4764-8d4f-c6d33e3336fb
# ╟─d3c1a86c-8c8f-4ad6-ac3c-2ba0f838d139
# ╟─1067868e-2ca8-463f-bc55-c444aaf3b37c
# ╠═dacdb662-f46d-4032-a8b8-cdfbaf5317fc
# ╠═22b04135-f762-4331-8091-c8c3fa46655f
# ╠═40d777cc-7cf0-44f7-b179-fe3abbf4e030
# ╠═bb734c3b-d981-4473-aa04-9262206ee746
# ╠═758b6eb0-f61d-4772-a270-f55fac65d56a
# ╠═262f7aa1-5072-4376-92db-4241370ec303
# ╠═f352b77a-4e83-4c84-bdcb-9d024b25673f
# ╠═9ce1abc9-5377-4fba-a059-3596cbdd3bcd
# ╠═44967cf2-8aff-4b85-aa4a-5833b9b29ab5
# ╟─c1310939-87c2-405f-94d6-c7d1310ff700
# ╠═99df78f5-61ac-49b3-b5ad-5fe5cdeffec5
# ╠═1500ca48-f99c-4ea0-beb7-bcadedf11d23
# ╟─e7c68548-a654-40dd-9b3a-10ce24b6cd5c
# ╠═1730eb08-7cbb-46e5-90fc-f216b9d0d17d
# ╠═c51f5a0c-7ee0-419c-b0e4-1bdf5fb2f075
# ╠═dfb1dd6f-3d4d-40f4-b8a7-fc24c719b73d
# ╠═69d3196a-3a5c-4b60-9d61-04b79c438991
# ╠═5283a72d-30d2-41d7-afa7-b5df4ee15194
# ╟─fdf97758-26c1-4157-a5d1-af89578f6277
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
