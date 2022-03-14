### A Pluto.jl notebook ###
# v0.18.2

using Markdown
using InteractiveUtils

# ╔═╡ 8bdec579-fe07-4bb2-8695-282a03ced00a
using PlutoUI, Markdown

# ╔═╡ 6c67cbf3-8223-404e-a44f-08132d3eb0bc
md"""
> 🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 0e53b094-5bcb-4347-8ff0-f974f795b08f
TableOfContents()

# ╔═╡ f99e8f0e-f3a7-11eb-0e54-1bba7efa83a5
md"""
# A simple graph interface

Here we will try to reproduce the basic graph interface of [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl), the reference package for graph algorithms in Julia.

The philosophy of LightGraphs.jl is based on *duck-typing*: "If it walks like a duck and it quacks like a duck, then it must be a duck". In other words, a graph object is not defined by its content but by the methods you can apply to it, and you only need to implement a few basic methods to make all graph algorithms work (see the [developer notes](https://juliagraphs.org/LightGraphs.jl/latest/developing/)). That is what we are doing below.
"""

# ╔═╡ b68db3fe-f47f-484d-a25d-84ebdcb4ad21
md"""
## Structure

We start by defining an undirected graph data structure called `MyGraph`, in which vertices are labelled from $1$ to $n$ and edges are stored in an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list).
"""

# ╔═╡ 7cf0fe1f-3dce-46c6-bc56-7cbfcf06511f
struct MyGraph
	# Fields
	adj::Vector{Set{Int}}
	# Constructors
	MyGraph(n::Integer) = new([Set{Int}() for v in 1:n])
end

# ╔═╡ 50e19a44-ff60-4de6-b3e9-b6da2951f52f
md"""
Every structure comes bundled with a default constructor that takes all of its attributes in order as arguments. However, we want simpler methods to build graphs, so we overrode it with a custom constructor that creates a `MyGraph` with `n` vertices and no edges.
"""

# ╔═╡ 3e3e936b-d163-4979-9711-5311f392e8c2
md"""
## Counting
"""

# ╔═╡ c87c006e-47b3-4c97-82f3-12ebf129bec0
md"""
Implement two methods `nv(g)` and `ne(g)` that count the number of vertices and edges in a graph of type `MyGraph`.
"""

# ╔═╡ 99eac054-f0de-4a22-ad9e-22d9badfe955
nv(g::MyGraph) = length(g.adj)

# ╔═╡ 9ee9559c-231a-4c1c-be81-d16ff8722033
ne(g::MyGraph) = sum(length(g.adj[v] for v in 1:nv(g)))

# ╔═╡ e34d60cc-ba35-4412-8bc2-04fc7b97d94b
md"""
## Checking existence
"""

# ╔═╡ f900c9f1-cc7e-4ed8-a47e-9c1f161d0819
md"""
Implement two methods `has_vertex(g, v)` and `has_edge(g, u, v)` to check the existence of a vertex or an edge.
"""

# ╔═╡ 6d575c0a-d51f-44c4-b277-fc99f48c4386
function has_vertex(g::MyGraph, v)
	return 1 <= v <= nv(g)
end

# ╔═╡ 9dec775d-5a38-4bd3-85fe-bee6498772c6
md"""
## Adding
"""

# ╔═╡ 1a5b0766-8017-4647-8f15-ae6657dfac5e
md"""
Implement a method `add_vertex!(g)` that adds vertex ``n+1`` to ``g``.
"""

# ╔═╡ 9331959a-2bc9-4cdd-ae1b-ecd153568925
function add_vertex!(g::MyGraph)
	push!(g.adj, Set{Int}())
	return nothing
end

# ╔═╡ b7698513-08b5-4d5b-b5b2-e339ae15d888
md"""
Implement a method `add_edge!(g, u, v)` that inserts edge ``(u, v)`` into ``g``.
"""

# ╔═╡ 5fe681bd-9773-4053-b18e-59842d7f8451
md"""
## Neighbors
"""

# ╔═╡ 6058a115-df7c-4692-a9fe-1d98e946388e
md"""
Implement two methods `outneighbors(g, v)` and `inneighbors(g, v)` that list the children and parents of vertex ``v``.
"""

# ╔═╡ fe47de49-80bb-4a3e-a2e2-b348399cce03
function outneighbors(g::MyGraph, v)
	return g.adj[v]
end

# ╔═╡ f2b89bf5-2dea-409f-b817-4130c534c984
function has_edge(g::MyGraph, u, v)
	return has_vertex(g, u) && has_vertex(g, v) && v in outneighbors(g, u)
end

# ╔═╡ 71811c6d-38c5-4023-8f18-89b42082c40c
function add_edge!(g, u, v)
	if !has_edge(g, u, v)
		push!(g.adj[u], v)
		push!(g.adj[v], u)
	end
	return nothing
end

# ╔═╡ 37c583f8-1791-4237-994b-75d3ac3691ab
md"""
## Listing
"""

# ╔═╡ 30fa8b36-976a-4d5b-be5f-d2f992b60c4a
md"""
Implement a methods `vertices(g)` that returns an iterator of the vertices.
"""

# ╔═╡ 59ccdb8c-a6dc-47de-b81c-8f2cb9e78e39
vertices(g::MyGraph) = 1:nv(g)

# ╔═╡ 126997ec-0e69-450b-8bfa-0586fd392811
function inneighbors(g::MyGraph, v)
	return [u for u in vertices(g) if v in outneighbors(u)]
end

# ╔═╡ d8193931-4486-4fd4-b62d-e8054af72466
md"""
Implement a method `edges(g)` that returns an iterator of the edges.
"""

# ╔═╡ a8a2c5ac-9854-4de0-bef3-394c9092f51f
edges(g::MyGraph) = ((u, v) for u in vertices(g) for v in outneighbors(g, u))

# ╔═╡ 8d432763-6662-40f3-b30b-5f83907b78d3
md"""
## Testing
"""

# ╔═╡ 16c5e0b0-ab42-4c07-a00f-56f3246935ad
function erdos_renyi(nv, p)
	g = MyGraph(nv)
	for i = 1:nv
		for j = 1:i-1
			if rand() < p
				add_edge!(g, i, j)
			end
		end
	end
	return g
end

# ╔═╡ 1897cdaf-e10e-4dc5-97ca-2a2b8d5424b6
gtest = erdos_renyi(10, 0.2)

# ╔═╡ 0e92ecb9-d1d2-41e8-89c1-0cde3570c25f
nv(gtest), ne(gtest)

# ╔═╡ 54ac0b84-4fff-478e-97f5-f9bae244d1e7
vertices(gtest)

# ╔═╡ 9ab4bae1-05a5-48a7-87d7-34dc6f750a92
collect(edges(gtest))

# ╔═╡ e72362a8-7b9c-471d-a03e-09b0793c9afd
md"""
# Graph traversal

Now that we are done implementing the basic functions for `MyGraph`, we can demonstrate their utility by using them to write ambitious algorithms.
"""

# ╔═╡ 59616520-34ff-4f1b-ae76-ec2d6fe3c7b1
md"""
## Breadth-first search

Breadth-first search, or BFS, is a common way to compute distances in undirected graphs. It proceeds by exploring neighborhoods of increasing size around the source.
"""

# ╔═╡ 91efdaa6-679c-4048-b21f-aafc94410ed2


# ╔═╡ f6b05eab-0808-473c-a153-33c5a24e436c
md"""
## Depth-first search

Depth-first search, or DFS, is another graph traversal algorithm that dives deep into the graph and then backtracks.
"""

# ╔═╡ 45471799-5881-459c-9a31-3b3f4a6bf83e


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
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
# ╟─6c67cbf3-8223-404e-a44f-08132d3eb0bc
# ╠═8bdec579-fe07-4bb2-8695-282a03ced00a
# ╠═0e53b094-5bcb-4347-8ff0-f974f795b08f
# ╟─f99e8f0e-f3a7-11eb-0e54-1bba7efa83a5
# ╟─b68db3fe-f47f-484d-a25d-84ebdcb4ad21
# ╠═7cf0fe1f-3dce-46c6-bc56-7cbfcf06511f
# ╟─50e19a44-ff60-4de6-b3e9-b6da2951f52f
# ╟─3e3e936b-d163-4979-9711-5311f392e8c2
# ╟─c87c006e-47b3-4c97-82f3-12ebf129bec0
# ╠═99eac054-f0de-4a22-ad9e-22d9badfe955
# ╠═9ee9559c-231a-4c1c-be81-d16ff8722033
# ╟─e34d60cc-ba35-4412-8bc2-04fc7b97d94b
# ╟─f900c9f1-cc7e-4ed8-a47e-9c1f161d0819
# ╠═6d575c0a-d51f-44c4-b277-fc99f48c4386
# ╠═f2b89bf5-2dea-409f-b817-4130c534c984
# ╟─9dec775d-5a38-4bd3-85fe-bee6498772c6
# ╟─1a5b0766-8017-4647-8f15-ae6657dfac5e
# ╠═9331959a-2bc9-4cdd-ae1b-ecd153568925
# ╟─b7698513-08b5-4d5b-b5b2-e339ae15d888
# ╠═71811c6d-38c5-4023-8f18-89b42082c40c
# ╟─5fe681bd-9773-4053-b18e-59842d7f8451
# ╟─6058a115-df7c-4692-a9fe-1d98e946388e
# ╠═fe47de49-80bb-4a3e-a2e2-b348399cce03
# ╠═126997ec-0e69-450b-8bfa-0586fd392811
# ╟─37c583f8-1791-4237-994b-75d3ac3691ab
# ╟─30fa8b36-976a-4d5b-be5f-d2f992b60c4a
# ╠═59ccdb8c-a6dc-47de-b81c-8f2cb9e78e39
# ╟─d8193931-4486-4fd4-b62d-e8054af72466
# ╠═a8a2c5ac-9854-4de0-bef3-394c9092f51f
# ╟─8d432763-6662-40f3-b30b-5f83907b78d3
# ╠═16c5e0b0-ab42-4c07-a00f-56f3246935ad
# ╠═1897cdaf-e10e-4dc5-97ca-2a2b8d5424b6
# ╠═0e92ecb9-d1d2-41e8-89c1-0cde3570c25f
# ╠═54ac0b84-4fff-478e-97f5-f9bae244d1e7
# ╠═9ab4bae1-05a5-48a7-87d7-34dc6f750a92
# ╟─e72362a8-7b9c-471d-a03e-09b0793c9afd
# ╟─59616520-34ff-4f1b-ae76-ec2d6fe3c7b1
# ╠═91efdaa6-679c-4048-b21f-aafc94410ed2
# ╟─f6b05eab-0808-473c-a153-33c5a24e436c
# ╠═45471799-5881-459c-9a31-3b3f4a6bf83e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
