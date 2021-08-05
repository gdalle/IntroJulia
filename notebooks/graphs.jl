### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 8bdec579-fe07-4bb2-8695-282a03ced00a
using PlutoUI

# ╔═╡ 0e53b094-5bcb-4347-8ff0-f974f795b08f
TableOfContents()

# ╔═╡ f99e8f0e-f3a7-11eb-0e54-1bba7efa83a5
md"""
# Graph interface

Here we will try to reproduce the basic graph interface of [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl), the reference package for graph algorithms in Julia. It contains many graph algorithms that can be applied to any graph structure as long as a few basic methods exist.
"""

# ╔═╡ b68db3fe-f47f-484d-a25d-84ebdcb4ad21
md"""
## Structure

Start by defining an undirected graph data structure called `MyGraph`, in which vertices are labelled from $1$ to $n$ and edges are stored in an adjacency list.
"""

# ╔═╡ 7cf0fe1f-3dce-46c6-bc56-7cbfcf06511f
struct MyGraph
	adj::Vector{Vector{Int}}
end

# ╔═╡ 1525c6ac-bf8d-4147-bd21-72fd400f3bed
md"""
## Analysis
"""

# ╔═╡ c87c006e-47b3-4c97-82f3-12ebf129bec0
md"""
Implement two functions `nv(g)` and `ne(g)` that count the number of vertices and edges in a graph of type `MyGraph`.
"""

# ╔═╡ 99eac054-f0de-4a22-ad9e-22d9badfe955
nv(g::MyGraph) = length(g.adj)

# ╔═╡ 9ee9559c-231a-4c1c-be81-d16ff8722033
ne(g::MyGraph) = sum(length(g.adj[v] for v in 1:nv(g)))

# ╔═╡ 274b9907-b828-475a-832c-68add3ca9e1c
md"""
Implement two functions `Base.eltype(g)` and `edgetype(g)` defining the types of vertices and edges for a graph.
"""

# ╔═╡ 849dcfc6-c4e1-4223-b045-8c0106cfa384
Base.eltype(g::MyGraph) = Int

# ╔═╡ bcc1ec10-5d4a-4d29-8c91-83b0f4131e4c
edgetype(g::MyGraph) = Tuple{Int, Int}

# ╔═╡ 30fa8b36-976a-4d5b-be5f-d2f992b60c4a
md"""
Implement a function `vertices(g)` that returns a list of the vertices of a graph.
"""

# ╔═╡ 59ccdb8c-a6dc-47de-b81c-8f2cb9e78e39
vertices(g::MyGraph) = 1:nv(g)

# ╔═╡ 6058a115-df7c-4692-a9fe-1d98e946388e
md"""
Implement two functions `outneighbors(g, v)` and `inneighbors(g, v)` that list the children and parents of a node.
"""

# ╔═╡ fe47de49-80bb-4a3e-a2e2-b348399cce03
outneighbors(g::MyGraph, v) = @view g.adj[v]

# ╔═╡ 126997ec-0e69-450b-8bfa-0586fd392811
inneighbors(g::MyGraph, v) = [u for u in vertices(g) if v in outneighbors(u)]

# ╔═╡ d8193931-4486-4fd4-b62d-e8054af72466
md"""
Implement a function `edges(g)` that enumerates the edges of a graph.
"""

# ╔═╡ a8a2c5ac-9854-4de0-bef3-394c9092f51f
edges(g::MyGraph) = [(u, v) for u in vertices(g), v in outneighbors(g, u)]

# ╔═╡ f900c9f1-cc7e-4ed8-a47e-9c1f161d0819
md"""
Implement two functions `has_vertex(g, v)` and `has_edge(g, u, v)` to check the existence of a vertex or an edge.
"""

# ╔═╡ 6d575c0a-d51f-44c4-b277-fc99f48c4386
has_vertex(g::MyGraph, v) = nv(g) <= v

# ╔═╡ f2b89bf5-2dea-409f-b817-4130c534c984
has_edge(g::MyGraph, u, v) = has_vertex(g, u) && has_vertex(g, v) && v in outneighbors(g, u)

# ╔═╡ 3e3e936b-d163-4979-9711-5311f392e8c2
md"""
## Modification
"""

# ╔═╡ 1a5b0766-8017-4647-8f15-ae6657dfac5e
md"""
Implement a function `add_vertex!(g)` that adds vertex $n+1$ to a graph.
"""

# ╔═╡ 9331959a-2bc9-4cdd-ae1b-ecd153568925
add_vertex!(g::MyGraph) = push!(g.adj, Int[])

# ╔═╡ b7698513-08b5-4d5b-b5b2-e339ae15d888
md"""
Implement a function `add_edge!(g, u, v)` that checks whether such an edge exists before inserting it.
"""

# ╔═╡ 71811c6d-38c5-4023-8f18-89b42082c40c
function add_edge!(g, u, v)
	if !has_edge(g, u, v)
		push!(v, g.adj[u])
	end
end

# ╔═╡ 9a6df825-c091-43c5-8e50-a71be0ea0bab
md"""
## Plotting
"""

# ╔═╡ 70e5e7a0-4885-4635-b7cf-724991912c27
md"""
# Graph algorithms
"""

# ╔═╡ 95481a6a-87f3-49de-a621-dadb08b24416
md"""
## Shortest paths
"""

# ╔═╡ 6efea986-f8d1-4d66-936c-cb0036504da7
md"""
## Flows
"""

# ╔═╡ 1c9c3efc-c06b-4cf5-81e6-c90aa9668409
md"""
## Matchings
"""

# ╔═╡ ecf32bbb-7a84-47f8-a8a4-f702601a6a0d
md"""
## Spanning tree
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
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
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

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
# ╠═8bdec579-fe07-4bb2-8695-282a03ced00a
# ╠═0e53b094-5bcb-4347-8ff0-f974f795b08f
# ╟─f99e8f0e-f3a7-11eb-0e54-1bba7efa83a5
# ╟─b68db3fe-f47f-484d-a25d-84ebdcb4ad21
# ╠═7cf0fe1f-3dce-46c6-bc56-7cbfcf06511f
# ╟─1525c6ac-bf8d-4147-bd21-72fd400f3bed
# ╟─c87c006e-47b3-4c97-82f3-12ebf129bec0
# ╠═99eac054-f0de-4a22-ad9e-22d9badfe955
# ╠═9ee9559c-231a-4c1c-be81-d16ff8722033
# ╟─274b9907-b828-475a-832c-68add3ca9e1c
# ╠═849dcfc6-c4e1-4223-b045-8c0106cfa384
# ╠═bcc1ec10-5d4a-4d29-8c91-83b0f4131e4c
# ╟─30fa8b36-976a-4d5b-be5f-d2f992b60c4a
# ╠═59ccdb8c-a6dc-47de-b81c-8f2cb9e78e39
# ╟─6058a115-df7c-4692-a9fe-1d98e946388e
# ╠═fe47de49-80bb-4a3e-a2e2-b348399cce03
# ╠═126997ec-0e69-450b-8bfa-0586fd392811
# ╟─d8193931-4486-4fd4-b62d-e8054af72466
# ╠═a8a2c5ac-9854-4de0-bef3-394c9092f51f
# ╟─f900c9f1-cc7e-4ed8-a47e-9c1f161d0819
# ╠═6d575c0a-d51f-44c4-b277-fc99f48c4386
# ╠═f2b89bf5-2dea-409f-b817-4130c534c984
# ╟─3e3e936b-d163-4979-9711-5311f392e8c2
# ╟─1a5b0766-8017-4647-8f15-ae6657dfac5e
# ╠═9331959a-2bc9-4cdd-ae1b-ecd153568925
# ╟─b7698513-08b5-4d5b-b5b2-e339ae15d888
# ╠═71811c6d-38c5-4023-8f18-89b42082c40c
# ╟─9a6df825-c091-43c5-8e50-a71be0ea0bab
# ╟─70e5e7a0-4885-4635-b7cf-724991912c27
# ╟─95481a6a-87f3-49de-a621-dadb08b24416
# ╟─6efea986-f8d1-4d66-936c-cb0036504da7
# ╟─1c9c3efc-c06b-4cf5-81e6-c90aa9668409
# ╟─ecf32bbb-7a84-47f8-a8a4-f702601a6a0d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
