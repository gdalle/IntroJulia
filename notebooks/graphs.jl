### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 8bdec579-fe07-4bb2-8695-282a03ced00a
using PlutoUI

# ╔═╡ e4d30b2f-2e46-4105-9801-f18487ad956e
using Markdown: MD, Admonition, Code

# ╔═╡ 6c67cbf3-8223-404e-a44f-08132d3eb0bc
md"""
> 🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 0e53b094-5bcb-4347-8ff0-f974f795b08f
TableOfContents()

# ╔═╡ 98492ade-615b-4644-abd6-3e53aa8c9f36
begin
	hint(text) = MD(Admonition("hint", "Hint", [text]))
	not_defined(var) = MD(Admonition("info", "Not defined", [md"Make sure you defined **$(Code(string(var)))**"]))
	keep_working(text=md"You're not there yet.") = MD(Admonition("danger", "Keep working!", [text]))
	correct(text=md"Good job.") = MD(Admonition("tip", "Correct!", [text]))
end;

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
Implement a methods `LightGraphs.vertices(g)` that returns an iterator of the vertices.
"""

# ╔═╡ 59ccdb8c-a6dc-47de-b81c-8f2cb9e78e39
vertices(g::MyGraph) = 1:nv(g)

# ╔═╡ 126997ec-0e69-450b-8bfa-0586fd392811
function inneighbors(g::MyGraph, v)
	return [u for u in vertices(g) if v in outneighbors(u)]
end

# ╔═╡ d8193931-4486-4fd4-b62d-e8054af72466
md"""
Implement a method `LightGraphs.edges(g)` that returns an iterator of the edges.
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

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "477bf42b4d1496b454c10cce46645bb5b8a0cf2c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.2"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═6c67cbf3-8223-404e-a44f-08132d3eb0bc
# ╠═8bdec579-fe07-4bb2-8695-282a03ced00a
# ╠═0e53b094-5bcb-4347-8ff0-f974f795b08f
# ╟─e4d30b2f-2e46-4105-9801-f18487ad956e
# ╟─98492ade-615b-4644-abd6-3e53aa8c9f36
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
