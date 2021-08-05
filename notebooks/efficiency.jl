### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ bca07932-eb86-40e3-9b47-aace0efda5d0
using PlutoUI

# ╔═╡ a3e741c1-6943-4b3d-bf7f-1c1f879f14ee
using BenchmarkTools

# ╔═╡ 27ecdb42-627e-4361-9e30-855e193b26f6
using Profile, ProfileSVG

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
function seq_rec1(w, y, n)
	d = length(w)
	if n <= d
		return y[n]
	else
		return sum([w[k] * seq_rec1(w, y, n-k) for k = 1:d])
	end
end

# ╔═╡ 75010618-78e8-4490-83bb-158c781afa30
function seq_rec2(w, y, n)
	d = length(w)
	if n <= d
		return y[n]
	else
		return sum(w[k] * seq_rec2(w, y, n-k) for k = 1:d)
	end
end

# ╔═╡ f49d49f1-685e-470e-9f3d-2262c4916be5
function seq_loop(w, y, n)
    x = similar(y, n)
    d = length(w)
    x[1:min(d, n)] .= y[1:min(d, n)]
    for k = d+1:n
        x[k] = sum(w[i] * x[k-i] for i = 1:d)
    end
    return x[n]
end

# ╔═╡ 602b6bd3-7108-4ed8-a054-9f728d060b47
w, y = [1, 1], [1, 1]

# ╔═╡ b2c57bd3-f957-4747-904d-b473810b9339
seq_rec1(w, y, 10), seq_rec2(w, y, 10), seq_loop(w, y, 10)

# ╔═╡ f7b1b44f-2aa6-4c5c-97a2-ac7037fb48ce
md"""
## Benchmarking

The package [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) is well-suited to compare functions based on their time and space complexity by running them repeatedly and returning the CPU time (with the `@belapsed` macro) or memory use (with the `@ballocated` macro). The general macro`@benchmark` does both of these things and much more, but doesn't work in Pluto notebooks since it prints in the original REPL.
"""

# ╔═╡ a0f3b8a4-a0c6-43b4-b55c-641b14d4f05a
@belapsed seq_rec1(w, y, 20)

# ╔═╡ 63a87cc9-e078-4390-bfb9-eab65e251a30
@belapsed seq_rec2(w, y, 20)

# ╔═╡ 2fb62e6a-c94c-4604-9520-7896b560b7b2
@belapsed seq_loop(w, y, 20)

# ╔═╡ 1d0af35c-0cee-4f70-9346-014ab294a614
md"""
Unsurprisingly, the non-recursive versions are much faster since they memoize computations instead of repeating them. The difference in performance between `seq_rec1` and `sec_req2` is mainly due to excessive allocations in the first one: on line 6, it is not necessary to create an array before computing the sum!
"""

# ╔═╡ 73616875-3e9c-481f-9902-534b367ca791
@ballocated seq_rec1(w, y, 20)

# ╔═╡ a4c47df1-e479-4c66-94b4-61de82fa7fbb
@ballocated seq_rec2(w, y, 20)

# ╔═╡ 7fa4ff99-b224-4083-9454-26ac7b0ea826
@ballocated seq_loop(w, y, 20)

# ╔═╡ 94c78148-c651-4a59-9e62-5c7e9576d1e8
md"""
## Profiling

Sometimes it is not enough to measure the time taken by the whole program: you have to dig in and separate the influence of each subfunction. This is what [profiling](https://docs.julialang.org/en/v1/manual/profile/) is about. To facilitate visualization of the call stack, we will use [ProfileSVG.jl](https://github.com/kimikage/ProfileSVG.jl).
"""

# ╔═╡ 96abb429-a0ca-41a2-8bbb-ec15e195d48f
@profview seq_loop(w, y, 10^8)

# ╔═╡ 0397d025-dcf2-41dd-a1d1-9cc8820fd02d
md"""
This flame graph tells us that even in our "efficient" version, we still spend most of the time storing stuff in the `x` array (that is what the function `setindex!` does). Maybe there is a more clever implementation? Try to find one using the exponents of a matrix.
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

# ╔═╡ bd85c4eb-ce5c-414d-aad7-b16db10ea8c0
norm(p::Point) = sqrt(p.x^2 + p.y^2)

# ╔═╡ 262f7aa1-5072-4376-92db-4241370ec303
begin
	p_stupid = StupidPoint(1., 2.)
	p_clever = CleverPoint(1., 2.)
	p_genius = GeniusPoint(1., 2.)
end

# ╔═╡ f352b77a-4e83-4c84-bdcb-9d024b25673f
@belapsed norm($p_stupid)

# ╔═╡ 9ce1abc9-5377-4fba-a059-3596cbdd3bcd
@belapsed norm($p_clever)

# ╔═╡ 44967cf2-8aff-4b85-aa4a-5833b9b29ab5
@belapsed norm($p_genius)

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
@belapsed unstable_sum($array_to_sum)

# ╔═╡ 5283a72d-30d2-41d7-afa7-b5df4ee15194
@belapsed stable_sum($array_to_sum)

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

[compat]
BenchmarkTools = "~1.1.1"
PlutoUI = "~0.7.9"
ProfileSVG = "~0.2.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "c31ebabde28d102b602bada60ce8922c266d205b"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.1"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "256d8e6188f3f1ebfa1a5d17e072a0efafa8c5bf"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.10.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[FlameGraphs]]
deps = ["AbstractTrees", "Colors", "FileIO", "FixedPointNumbers", "IndirectArrays", "LeftChildRightSiblingTrees", "Profile"]
git-tree-sha1 = "99c43a8765095efa6ef76233d44a89e68073bd10"
uuid = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"
version = "0.2.5"

[[IndirectArrays]]
git-tree-sha1 = "c2a145a145dc03a7620af1444e0264ef907bd44f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "0.5.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "71be1eb5ad19cb4f61fa8c73395c0338fd092ae0"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.1.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[ProfileSVG]]
deps = ["Colors", "FlameGraphs", "Profile", "UUIDs"]
git-tree-sha1 = "e4df82a5dadc26736f106f8d7fc97c42cc6c91ae"
uuid = "132c30aa-f267-4189-9183-c8a63c7e05e6"
version = "0.2.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═bca07932-eb86-40e3-9b47-aace0efda5d0
# ╠═5de2a556-f3af-4a64-a5c6-32d30f758be3
# ╟─9331fad2-f29e-11eb-0349-477bd2e7e412
# ╟─62eeeb90-8bdf-4a70-bcef-ab31136c264c
# ╠═781a7cdd-d36e-40b4-9de1-f832cba41377
# ╠═75010618-78e8-4490-83bb-158c781afa30
# ╠═f49d49f1-685e-470e-9f3d-2262c4916be5
# ╠═602b6bd3-7108-4ed8-a054-9f728d060b47
# ╠═b2c57bd3-f957-4747-904d-b473810b9339
# ╟─f7b1b44f-2aa6-4c5c-97a2-ac7037fb48ce
# ╠═a3e741c1-6943-4b3d-bf7f-1c1f879f14ee
# ╠═a0f3b8a4-a0c6-43b4-b55c-641b14d4f05a
# ╠═63a87cc9-e078-4390-bfb9-eab65e251a30
# ╠═2fb62e6a-c94c-4604-9520-7896b560b7b2
# ╟─1d0af35c-0cee-4f70-9346-014ab294a614
# ╠═73616875-3e9c-481f-9902-534b367ca791
# ╠═a4c47df1-e479-4c66-94b4-61de82fa7fbb
# ╠═7fa4ff99-b224-4083-9454-26ac7b0ea826
# ╟─94c78148-c651-4a59-9e62-5c7e9576d1e8
# ╠═27ecdb42-627e-4361-9e30-855e193b26f6
# ╠═96abb429-a0ca-41a2-8bbb-ec15e195d48f
# ╟─0397d025-dcf2-41dd-a1d1-9cc8820fd02d
# ╟─0fb6ed33-601c-4392-b7d9-32230c979d39
# ╟─a6e9da76-1ff0-4b54-9b55-4856ca32b251
# ╟─fa483fea-bf9f-4764-8d4f-c6d33e3336fb
# ╟─d3c1a86c-8c8f-4ad6-ac3c-2ba0f838d139
# ╟─1067868e-2ca8-463f-bc55-c444aaf3b37c
# ╠═dacdb662-f46d-4032-a8b8-cdfbaf5317fc
# ╠═22b04135-f762-4331-8091-c8c3fa46655f
# ╠═40d777cc-7cf0-44f7-b179-fe3abbf4e030
# ╠═bb734c3b-d981-4473-aa04-9262206ee746
# ╠═bd85c4eb-ce5c-414d-aad7-b16db10ea8c0
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
