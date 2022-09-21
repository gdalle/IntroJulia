### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ d0202e1e-7ca2-4310-abd5-8ed3320a1c2a
using PlutoUI

# ╔═╡ 2b3e4c4d-22c4-4d7c-8f81-98daffcd47d5
TableOfContents()

# ╔═╡ 2b51f4ba-f4bf-4bd2-9f6a-67860ecca4a3
md"""
# HW2 - Automatic differentiation
"""

# ╔═╡ efe3c3db-a2f9-421f-8259-345b616d664a
md"""
# 1. Neural networks by hand
"""

# ╔═╡ af24f6ca-b82b-4221-95ce-9bfd2efdecd1
md"""
## Utilities
"""

# ╔═╡ da1a18a7-0306-4948-8cc6-5be15ee3f883
relu(x::R) where {R} = max(zero(R), x)

# ╔═╡ b14a3787-4761-42d2-9c8a-e052ad5fd076
relu_derivative(x::R) where {R} = x > zero(R) ? one(R) : zero(R)

# ╔═╡ 4136c073-8ec6-498f-9516-deb9424cf2fc
D = 5  # input dimension

# ╔═╡ e33ad1ed-5b2c-4ea6-8c2a-2442d1b66a3d
U1, U2 = 3, 1  # layer widths

# ╔═╡ 32ec0962-0a6e-4aed-ae27-6096fc61dca0
md"""
## Structures
"""

# ╔═╡ e7a50285-fc3e-44f3-8bf4-ed4224c6fd9b
md"""
A single neuron unit computes the function

$$x \longmapsto \sigma(w^\top x + b)$$
"""

# ╔═╡ 37756e8e-39a6-11ed-09de-a9921f9f40f1
struct Unit{R}
	weights::Vector{R}
	bias::R
end

# ╔═╡ 06f7c347-7ccc-4d40-97c7-ca1a9627aec9
md"""
A layer is a collection of neurons applied in parallel.
"""

# ╔═╡ 1f4c6e3e-01b2-4ec7-a2e0-889c503745bf
struct Layer{R}
	units::Vector{Unit{R}}
end

# ╔═╡ 168ea208-e1bf-43cd-ae88-4e8219d0111a
function apply(l::Layer, x::Vector)
	return [apply(u, x) for u in l.units]
end

# ╔═╡ 7f4f9e37-fe39-4c44-a14b-b0d8a3a243cf
md"""
A network is a collection of layers applied in sequence.
"""

# ╔═╡ 60052063-048d-454f-b5c5-c14a5ff31f51
struct Network{R}
	layers::Vector{Layer{R}}
end

# ╔═╡ d3043462-960e-4669-9acf-bc448a19f65e
function apply(n::Network, x::Vector)
	y = x
	for l in n.layers
		y = apply(l, y)
	end
	return y
end

# ╔═╡ 8c9f922b-7f0f-42d9-abfe-61f32d4af161
md"""
## Building a vector space
"""

# ╔═╡ aa6c0da4-4f6c-4235-b3fc-825c7c4bc66a
function Base.:*(a::Number, u::Unit)
	return Unit(a .* u.weights, a * u.bias)
end

# ╔═╡ 14a8844a-e100-4cb7-bf4a-fa93275bff49
function Base.:+(u1::Unit, u2::Unit)
	return Unit(u1.weights .+ u2.weights, u1.bias + u2.bias)
end

# ╔═╡ 409fffc1-d6fd-4534-a9bc-1b89a34e73cc
function Base.:*(a::Number, l::Layer)
	return Layer(a .* l.units)
end

# ╔═╡ f4068a17-3241-4c83-974a-9fae3958522b
function Base.:+(l1::Layer, l2::Layer)
	return Layer(l1.units .+ l2.units)
end

# ╔═╡ 2c753d5a-9cf5-4787-9a1e-223e1920799c
function Base.:*(a::Number, n::Network)
	return Network(a .* n.layers)
end

# ╔═╡ 67e90f04-6119-41e4-8f1b-e6fa016f78bf
function Base.:+(n1::Network, n2::Network)
	return Network(n1.layers .+ n2.layers)
end

# ╔═╡ 33481a73-123a-4852-b420-42d5ad3967db
sigmoid(x::R) where {R} = one(R) / (one(R) + exp(-x))

# ╔═╡ 8db7c7b8-b450-4459-bb8b-938dc379b7f5
sigmoid_derivative(x::R) where {R} = sigmoid(x) * (one(R) - sigmoid(x))

# ╔═╡ 5d21b43b-3ad0-4db6-b6f6-3907882c39ca
function apply(u::Unit, x::Vector)
	return sigmoid(u.weights'x + u.bias)
end

# ╔═╡ c8288f70-fb75-46ff-9c39-024136e6d1cb
let
	x = rand(D)
	u = Unit(rand(D), rand())
	apply(u, x)
end

# ╔═╡ 732e0ac5-a555-44e7-967d-c380328c5670
let
	x = rand(D)
	l = Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	apply(l, x)
end

# ╔═╡ b2481260-cba5-45e0-8a0e-63795b781237
let
	x = rand(D)
	l1 = Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	l2 = Layer([Unit(rand(U1), rand()) for n in 1:U2]) 
	n = Network([l1, l2])
	apply(n, x)
end

# ╔═╡ a8dffea4-5185-491a-bd71-9d91265a4246
md"""
## Differentiation
"""

# ╔═╡ e6aa9033-fcbf-4bd1-9843-63c82525b55a
md"""
Let's start with the differential of a single neuron unit:

$$\begin{aligned}
\texttt{apply}(u + du, x)
&= \sigma\left[(w + dw)^\top x + (b + db)\right] \\
&= \sigma\left[(w^\top x + b) + (dw^\top x + db)\right] \\
&= \sigma(w^\top x + b) + \sigma'(w^\top x + b)(dw^\top x + db) + o(du)\\
&= \texttt{apply}(u, x) + \frac{\partial \texttt{apply}(u, x)}{\partial u} (du) + o(du)
\end{aligned}$$
"""

# ╔═╡ c07ed9c6-30ca-4608-bdb8-35d78761090a
function compute_differential(u::Unit, x::Vector)
	slope = sigmoid_derivative(u.weights'x + u.bias)
	function differential(du::Unit)
		return slope * (du.weights'x + du.bias)
	end
	return differential
end

# ╔═╡ 96f3a66e-85a7-476d-8cb9-1f627bdb5309
md"""
We continue with the differential of a layer:

$$\begin{aligned}
\texttt{apply}(\ell + d\ell, x)
&= \begin{pmatrix} \texttt{apply}(u_1 + du_1, x) \\ \vdots \\ \texttt{apply}(u_U + du_U, x) \end{pmatrix} \\
&= \begin{pmatrix} \texttt{apply}(u_1, x) + \frac{\partial\texttt{apply}(u_1, x)}{\partial u} (du_1) + o(du_1) \\ \vdots \\ \texttt{apply}(u_U, x) + \frac{\partial \texttt{apply}(u_U, x)}{\partial u} (du_U) + o(du_U) \end{pmatrix} \\
&= \begin{pmatrix} \texttt{apply}(u_1, x) \\ \vdots \\ \texttt{apply}(u_U, x)\end{pmatrix} + \begin{pmatrix} \frac{\partial\texttt{apply}(u_1, x)}{\partial u} (du_1) \\ \vdots \\ \frac{\partial \texttt{apply}(u_U, x)}{\partial u} (du_U) \end{pmatrix} + o(d\ell) \\
&= \texttt{apply}(\ell, x) + \frac{\partial \texttt{apply}(\ell, x)}{\partial \ell} (d\ell) + o(d\ell)
\end{aligned}$$
"""

# ╔═╡ 49117b28-e352-4564-a449-06d31f4eaa9f
function compute_differential(l::Layer, x::Vector)
	unit_differentials = [compute_differential(u, x) for u in l.units]
	function differential(dl::Layer)
		return [diff(du) for (diff, du) in zip(unit_differentials, dl.units)]
	end
	return differential
end

# ╔═╡ 1d211c2e-4b42-4db8-9823-439044b20566
md"""
We finish with the differential of a network, which is a bit more tricky.
Let us consider only two layers $\ell_1$ and $\ell_2$, so that $n = \ell_2 \circ \ell_1$ :

$$\begin{aligned}
\texttt{apply}(n + dn, x)
&= \texttt{apply}\left[ (\ell_2 + d\ell_2) \circ (\ell_1 + d\ell_1), x \right] \\
&= \texttt{apply}\left[ \ell_2 + d\ell_2, \texttt{apply}(\ell_1 + d\ell_1, x) \right] \\
&= \texttt{apply}\left[ \ell_2 + d\ell_2, \texttt{apply}(\ell_1, x) + \frac{\partial \texttt{apply}(\ell_1, x)}{\partial \ell}(d\ell_1) + o(d\ell_1) \right] \\
&= \texttt{apply}\left[\ell_2, \texttt{apply}(\ell_1, x)\right] \\
& \phantom{=} + \frac{\partial \texttt{apply}(\ell_2, \texttt{apply}(\ell_1, x))}{\partial \ell} (d\ell_2) \\
& \phantom{=} + \frac{\partial \texttt{apply}(\ell_2, \texttt{apply}(\ell_1, x))}{\partial x} \left(\frac{\partial \texttt{apply}(\ell_1, x)}{\partial \ell}(d\ell_1)\right) \\
& \phantom{=} + o(d\ell_1) + o(d\ell_2)
\end{aligned}$$
"""

# ╔═╡ c817fa60-9e43-433d-8100-9787a54afb59
function compute_differential(n::Network, x::Vector)
	error("Not implemented")
end

# ╔═╡ 00b4a4c0-d864-4066-88d0-fcea1952d99f
let
	x = rand(D)
	n = Unit(rand(D), rand())
	dn = 0.001 * Unit(rand(D), rand())
	differential = compute_differential(n, x)
	differential(dn), apply(n + dn, x) - apply(n, x)
end

# ╔═╡ 0b3aedef-573e-465d-8788-c8bb87b49dd0
let
	x = rand(D)
	l = Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	dl = 0.001 * Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	differential = compute_differential(l, x)
	differential(dl), apply(l + dl, x) - apply(l, x)
end

# ╔═╡ 0338f0d7-1178-4722-a464-3ca9a711f707
let
	x = rand(D)
	l1 = Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	l2 = Layer([Unit(rand(U1), rand()) for n in 1:U2]) 
	n = Network([l1, l2])

	dl1 = 0.001 * Layer([Unit(rand(D), rand()) for n in 1:U1]) 
	dl2 = 0.001 * Layer([Unit(rand(U1), rand()) for n in 1:U2]) 
	dn = Network([dl1, dl2])
	
	differential = compute_differential(n, x)
	differential(dn), apply(n + dn, x) - apply(n, x)
end

# ╔═╡ 58d84644-5666-4cb5-8cd2-ebc6af266518
md"""
# 2. Implicit differentiation
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "502a5e5263da26fcd619b7b7033f402a42a81ffc"

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
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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
# ╠═d0202e1e-7ca2-4310-abd5-8ed3320a1c2a
# ╠═2b3e4c4d-22c4-4d7c-8f81-98daffcd47d5
# ╟─2b51f4ba-f4bf-4bd2-9f6a-67860ecca4a3
# ╟─efe3c3db-a2f9-421f-8259-345b616d664a
# ╟─af24f6ca-b82b-4221-95ce-9bfd2efdecd1
# ╠═da1a18a7-0306-4948-8cc6-5be15ee3f883
# ╠═b14a3787-4761-42d2-9c8a-e052ad5fd076
# ╠═33481a73-123a-4852-b420-42d5ad3967db
# ╠═8db7c7b8-b450-4459-bb8b-938dc379b7f5
# ╠═4136c073-8ec6-498f-9516-deb9424cf2fc
# ╠═e33ad1ed-5b2c-4ea6-8c2a-2442d1b66a3d
# ╟─32ec0962-0a6e-4aed-ae27-6096fc61dca0
# ╟─e7a50285-fc3e-44f3-8bf4-ed4224c6fd9b
# ╠═37756e8e-39a6-11ed-09de-a9921f9f40f1
# ╠═5d21b43b-3ad0-4db6-b6f6-3907882c39ca
# ╠═c8288f70-fb75-46ff-9c39-024136e6d1cb
# ╟─06f7c347-7ccc-4d40-97c7-ca1a9627aec9
# ╠═1f4c6e3e-01b2-4ec7-a2e0-889c503745bf
# ╠═168ea208-e1bf-43cd-ae88-4e8219d0111a
# ╠═732e0ac5-a555-44e7-967d-c380328c5670
# ╟─7f4f9e37-fe39-4c44-a14b-b0d8a3a243cf
# ╠═60052063-048d-454f-b5c5-c14a5ff31f51
# ╠═d3043462-960e-4669-9acf-bc448a19f65e
# ╠═b2481260-cba5-45e0-8a0e-63795b781237
# ╟─8c9f922b-7f0f-42d9-abfe-61f32d4af161
# ╠═aa6c0da4-4f6c-4235-b3fc-825c7c4bc66a
# ╠═14a8844a-e100-4cb7-bf4a-fa93275bff49
# ╠═409fffc1-d6fd-4534-a9bc-1b89a34e73cc
# ╠═f4068a17-3241-4c83-974a-9fae3958522b
# ╠═2c753d5a-9cf5-4787-9a1e-223e1920799c
# ╠═67e90f04-6119-41e4-8f1b-e6fa016f78bf
# ╟─a8dffea4-5185-491a-bd71-9d91265a4246
# ╟─e6aa9033-fcbf-4bd1-9843-63c82525b55a
# ╠═c07ed9c6-30ca-4608-bdb8-35d78761090a
# ╠═00b4a4c0-d864-4066-88d0-fcea1952d99f
# ╟─96f3a66e-85a7-476d-8cb9-1f627bdb5309
# ╠═49117b28-e352-4564-a449-06d31f4eaa9f
# ╠═0b3aedef-573e-465d-8788-c8bb87b49dd0
# ╟─1d211c2e-4b42-4db8-9823-439044b20566
# ╠═c817fa60-9e43-433d-8100-9787a54afb59
# ╠═0338f0d7-1178-4722-a464-3ca9a711f707
# ╟─58d84644-5666-4cb5-8cd2-ebc6af266518
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
