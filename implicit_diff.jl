### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ ddbf8ae6-39b6-11ed-226e-0d38991ed784
begin
	using ChainRulesCore
	using PlutoUI
end

# ╔═╡ f447c167-2bcb-4bf3-86cd-0f40f4e54c97
TableOfContents()

# ╔═╡ a405d214-4348-4692-999e-0e890bd91e5d
md"""
# HW2 - Implicit differentiation
"""

# ╔═╡ e7fa3587-d99d-4a77-b99d-a58b2df8f3c0
md"""
# 1. Calculus and autodiff refresher
"""

# ╔═╡ 4d9d2f52-c406-4a7c-8b0e-ba5af7ebc3d8
md"""
## Differentials, Jacobians

Let $f: \mathcal{A} \longrightarrow \mathcal{B}$ be a function between two normed vector spaces.
When we say that $f$ is differentiable at $x \in \mathcal{A}$, we mean that there is a _linear_ function $df_x: \mathcal{A} \longrightarrow \mathcal{B}$ such that for any perturbation $h$,

$$f(x + h) = f(x) + df_x(h) + o(\lVert h \rVert)$$

In other words, $f$ can be approximated linearly around $x$, and the error is negligible compared with the distance to $x$.

The linear function $df_x$ is called the _differential_ of $f$ at $x$.
When $\mathcal{A} = \mathbb{R}^n$ and $\mathcal{B} = \mathbb{R}^m$ are both Euclidean spaces, we can always find a matrix $Jf_x \in \mathbb{R}^{m \times n}$ that satisfies

$$df_x(h) = Jf_x h$$

Note the change of perspective: the left hand side is the application of a function to a vector, while the right hand side is a matrix-vector product.
The matrix $Jf_x$ is called the _Jacobian_ of $f$ at $x$.

An interesting special case is when $m = 1$, _i.e._ when the function $f$ is real-valued.
Then, the Jacobian matrix has only one row, and it can be seen as the transpose of the gradient: $Jf_x = \nabla f_x^\top$.
Among other things, this applies to loss functions in deep learning, which have many inputs but a single output.
"""

# ╔═╡ 8923a5ad-ddba-4ae2-886e-84526a3521ba
md"""
## JVPs & VJPs

In concrete applications, the dimensions $n$ and $m$ can easily reach $10^6$ or even $10^9$.
This makes it completely impossible to store a full Jacobian (of size $m \times n$) in memory.
As a result, autodiff systems only manipulate Jacobians "lazily" / "implicitly" by computing their products with vectors.
These products come in two flavors:

- _Jacobian-vector products_ (JVPs) of the form $u \in \mathbb{R}^n \longmapsto Jf_x u \in \mathbb{R}^m$. 
- _vector-Jacobian products_ (VJPs) of the form $v \in \mathbb{R}^m \longmapsto v^\top Jf_x \in \mathbb{R}^n$. 

When $n = 1$ (scalar input), we can compute a JVP with $u = 1$ and retrieve the full Jacobian that way, since it has only one column.
When $m = 1$ (scalar output), we can compute a VJP with $v = 1$ and retrieve the full Jacobian that way, since it has only one row.
When $n = m = 1$ (fully scalar function), JVPs and VJPs are one and the same. 

Rules that compute JVPs and VJPs for built-in functions are the first ingredient of autodiff.
They serve as a basic building block for more complex constructs.
In Julia, this is taken care of by the [`ChainRules.jl`](https://github.com/JuliaDiff/ChainRules.jl) ecosystem.
"""

# ╔═╡ f843b77d-8160-4d87-8641-eeb04549af8f
md"""
## Forward & reverse mode

Let us now consider a composite function $f = f^3 \circ f^2 \circ f^1$ with $3$ layers.
The _chain rule_ yields the following differential:

$$df_x = df^3_{(f^2 \circ f^1) (x)} \circ df^2_{f^1(x)} \circ df^1_x$$

Again, in the Euclidean case, we can re-interpret this function composition as a matrix product:

$$\underbrace{Jf_{x}}_J = \underbrace{Jf^3_{(f^2 \circ f^1) (x)}}_{J^3} \underbrace{Jf^2_{f^1(x)}}_{J^2} \underbrace{Jf^1_{x\phantom{)}}}_{J^1}$$

What happens if we want to compute JVPs and VJPs without storing these Jacobian matrices?

- For a JVP, we can accumulate the product from first to last layer (in _forward mode_):

$$J u = J^3 J^2 J^1 u \quad \implies \quad \begin{cases} u^1 = J^1 u \\ u^2 = J^2 u^1 \\ u^3 = J^3 u^2 \end{cases}$$

- For a VJP, we can accumulate the product from last to first layer (in _reverse mode_)

$$v^\top J = v^\top J^3 J^2 J^1 \quad \implies \quad \begin{cases} v^3 = v^\top J^3 \\ v^2 = (v^3)^\top J^2 \\ v^1 = (v^2)^\top J^1 \end{cases}$$

These considerations generalize to more complex computational graphs.

Utilities that combine JVPs (or VJPs) using the chain rule are the second ingredient of autodiff.
In Julia, this is taken care of by various backends, and there is no clear best option: a list is available on the [JuliaDiff](https://juliadiff.org/) website.
Many of these backends compatible with `ChainRules.jl`, which is why we focus on it now.
"""

# ╔═╡ c0964aea-4760-4512-8df7-b0cc88f53eb0
md"""
# 2. Introduction to `ChainRules.jl`
"""

# ╔═╡ 93585262-4d86-48cf-a1c3-6b83615879d6
md"""
# 3. Implicit differentiation
"""

# ╔═╡ 98580356-21c5-472a-aedd-4f47a6799f24
md"""
## The implicit function theorem
"""

# ╔═╡ 60b6952b-d546-4663-9f4f-800b437621f1
md"""
## A useful fixed-point algorithm
"""

# ╔═╡ d6fbb62f-f89a-4737-84fd-736f5af206d6
md"""
## Reverse mode implicit differentiation
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ChainRulesCore = "~1.15.5"
PlutoUI = "~0.7.40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "04ccb34ad2eaeadf9e5482d1ba7a31c7df0a3d21"

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

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "dc4405cee4b2fe9e1108caec2d760b7ea758eca2"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

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

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╠═ddbf8ae6-39b6-11ed-226e-0d38991ed784
# ╠═f447c167-2bcb-4bf3-86cd-0f40f4e54c97
# ╟─a405d214-4348-4692-999e-0e890bd91e5d
# ╟─e7fa3587-d99d-4a77-b99d-a58b2df8f3c0
# ╟─4d9d2f52-c406-4a7c-8b0e-ba5af7ebc3d8
# ╟─8923a5ad-ddba-4ae2-886e-84526a3521ba
# ╟─f843b77d-8160-4d87-8641-eeb04549af8f
# ╠═c0964aea-4760-4512-8df7-b0cc88f53eb0
# ╠═93585262-4d86-48cf-a1c3-6b83615879d6
# ╠═98580356-21c5-472a-aedd-4f47a6799f24
# ╠═60b6952b-d546-4663-9f4f-800b437621f1
# ╠═d6fbb62f-f89a-4737-84fd-736f5af206d6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
