### A Pluto.jl notebook ###
# v0.19.30

#> [frontmatter]
#> title = "IntroJulia - graphs"

using Markdown
using InteractiveUtils

# ╔═╡ 510bdffa-6367-11ed-23ca-9d49e3f3543f
begin
	using BenchmarkTools
	using DataStructures
	import GraphPlot
	import Graphs
	using PlutoTeachingTools
	using PlutoUI
	using ProfileCanvas
	using SparseArrays
end

# ╔═╡ 66106324-994f-4751-8a1e-0b307380bd11
TableOfContents()

# ╔═╡ 9eb4b899-4b05-4301-9e65-13029b25cdbb
md"""
# Graphs in Julia
"""

# ╔═╡ b84043ea-bb4d-4527-b31f-76cc90ebc7dc
TwoColumnWideLeft(
	md"""
Goals of the lecture:
- knowing the various graph types and storage modes
- understanding the role of an interface
- exploring performance differences between interface implementations
""",
	md"""
> Poll: [Wooclap link](https://app.wooclap.com/JULIAGRAPHS)
"""
)

# ╔═╡ 683da7e5-2794-4766-a026-cb55bd23690f
html"<button onclick=present()>Present</button>"

# ╔═╡ bf07f944-19a0-4d3a-bdae-4ef1ed2d9f64
md"""
# From theory to implementation
"""

# ╔═╡ 07294a71-73a0-4993-b076-671fcc9c8d93
md"""
## One mathematical object
"""

# ╔═╡ c6310180-499a-4dd1-bda3-8d86f791c1b0
md"""
A graph $G = (\mathcal{V}, \mathcal{E})$ is composed of:

- a set $\mathcal{V}$ of vertices, often called $u$ or $v$, with $|\mathcal{V}|=n$
- a set $\mathcal{E}$ of edges, often denoted by $e = (u, v)$, with $|\mathcal{E}|=m$

A weighted graph $G = (\mathcal{V}, \mathcal{E}, w)$ also has weight values $w_e$ for each edge.
"""

# ╔═╡ f9290e78-f1e9-44d1-90fc-d7c002623cf4
md"""
## Several storage options
"""

# ╔═╡ cc26831a-fab9-4e65-8e4b-4c89371c6970
md"""
- list of edges
- adjacency list: $$v \in L[u] \iff (u, v) \in \mathcal{E}$$
- adjacency matrix: $$A_{u,v} = 1 \iff (u, v) \in \mathcal{E}$$

Visualisation: [here](https://visualgo.net/en/graphds)
"""

# ╔═╡ f4059c54-e68b-4004-b3ee-78a7fca03dcc
md"""
## In real life...
"""

# ╔═╡ f07cd793-3570-4b0d-9f8a-f8835304480b
TwoColumnWideRight(
	md"""
- Directed vs. undirected
- Sparse vs. dense
- Edge weights?
- Other metadata?
	""",
	md"""
- Self-loops (non-simple graphs)?
- Duplicated edges (multigraphs)?
- Edges with more vertices (hypergraphs)?
- Infinite graphs?
"""
)

# ╔═╡ aee9adf7-92ca-483f-a1b3-744b9a07970d
md"""
## Task
"""

# ╔═╡ 5e0e9565-0798-4a92-bafe-e8e69d4ab7f9
md"""
Both graph types need a constructor which accepts a vector of edges (represented as tuples `(u, v)`).
"""

# ╔═╡ e1520e15-839e-4ff4-8b93-023a1b6a78e3
md"""
# The interface abstraction
"""

# ╔═╡ bec05993-17de-4121-af30-2ae15956c6e1
md"""
Most graph algorithms only make use of a few basic functions, which can be implemented in lots of different ways depending on our needs.
That is what allows you to [create your own graph format](https://juliagraphs.org/Graphs.jl/stable/ecosystem/interface/) and make it compatible with the entire ecosystem.

Here we demonstrate this paradigm with a simple example.
"""

# ╔═╡ 5230069e-a2aa-40fe-a2e5-aceefe6b6635
md"""
## Breadth-first search
"""

# ╔═╡ abc30a8b-b728-4936-a9b3-cdbf210a265d
md"""
A simple graph traversal algorithm.

Description: [here](https://en.wikipedia.org/wiki/Breadth-first_search) / Visualization: [here](https://visualgo.net/en/dfsbfs)
"""

# ╔═╡ e9f3585c-0b5b-497a-9a5f-55cb5963d7ac
md"""
## Defining the interface
"""

# ╔═╡ 981d2bc0-3030-4d4a-a2c3-ae6c3819838d
"""
	AbstractGraph

Any subtype must implement the following methods:
- `nb_vertices(g)`
- `outneighbors(g, u)`
"""
abstract type AbstractGraph end

# ╔═╡ 789c7a0a-870d-4fdb-a11d-4ab314cbbce9
md"""
## Defining the functions
"""

# ╔═╡ 1de57dcb-85c0-44c0-b225-f81194ffea06
"""
	nb_vertices(g)

Count the vertices in `g`.
"""
function nb_vertices end

# ╔═╡ c4d83106-f940-4c69-bb95-8effe7e8bd50
"""
	outgoing_neighbors(g, u)

Return an iterable of the vertices `v` such that `(u, v)` is an edge of `g`.
"""
function outgoing_neighbors end

# ╔═╡ 7448ed44-0f65-4d4a-b4f4-20b165a34a44
md"""
Compatibility with Graphs.jl
"""

# ╔═╡ 2abd6312-b4f5-4301-8881-d86ddfce66cd
begin
	nb_vertices(g::Graphs.AbstractGraph) = Graphs.nv(g)
	outgoing_neighbors(g::Graphs.AbstractGraph, u) = Graphs.outneighbors(g, u)
end

# ╔═╡ 3693c497-5420-48cf-ae65-cbed6f60ae36
md"""
## Task
"""

# ╔═╡ 8d31706c-c953-4d96-af97-ff661522f69f
md"""
## An alternate view: graphs as matrices
"""

# ╔═╡ 34cb6e80-43b9-48db-853a-d51ad53164ac
md"""
There are deep connections between linear algebra and graph theory.

The package [SuiteSparseGraphBLAS.jl](https://github.com/JuliaSparse/SuiteSparseGraphBLAS.jl): leverages them for fast algorithms.
"""

# ╔═╡ dbeda7e3-ce02-49c2-93b1-1e2e712c9c09
md"""
# Graph storage types
"""

# ╔═╡ f4fc6854-a44d-4bfd-88bd-a3b9eaf95332
md"""
For simplicity, we assume that the graph vertices are numbered from $1$ to $n$, i.e. that $V = \{1, ..., n\}$.
"""

# ╔═╡ d89807e0-612d-4794-b06f-b4a233ef9abe
md"""
## Test case
"""

# ╔═╡ 055d49e6-8b2e-462d-abe3-bf3c5c97f61c
md"""
Our test graph is a grid of size `(I,J)`.
"""

# ╔═╡ 24722797-ae00-4066-8838-43e9eb4b5ee3
grid_coord_to_index(i, j; I, J) = (j-1) * I + (i-1) + 1

# ╔═╡ 95df5658-24d0-440d-b157-e4cf54c11d1a
grid_index_to_coord(v; I, J) = ((v-1) % I + 1, (v-1) ÷ I + 1)

# ╔═╡ 3931bfba-cb35-487d-a798-923e8ee454d2
function grid_edges(I, J)
	edges = Tuple{Int,Int}[]
	for iᵤ in 1:I, jᵤ in 1:J
		u = grid_coord_to_index(iᵤ, jᵤ; I, J)
		for (iᵥ, jᵥ) in ((iᵤ+1, jᵤ), (iᵤ-1, jᵤ), (iᵤ, jᵤ+1), (iᵤ, jᵤ-1))
			if 1 <= iᵥ <= I && 1 <= jᵥ <= J
				v = grid_coord_to_index(iᵥ, jᵥ; I, J)
				push!(edges, (u, v))
			end
		end
	end
	return edges
end

# ╔═╡ 57f66ed6-b4aa-4ab0-9eaa-02f12983594a
let
	I, J = 2, 3
	edges = grid_edges(I, J)
end

# ╔═╡ de48b3f3-3cba-45b9-b0ef-eb7cfbb2c7aa
md"""
## Edge list
"""

# ╔═╡ 669c587c-c877-4e9e-a934-2850c4208147
struct ListGraph <: AbstractGraph
	edges::Vector{Tuple{Int,Int}}
end

# ╔═╡ 55252064-0f58-44ac-a836-981a6cd8227a
nb_vertices(g::ListGraph) = max(maximum(first, g.edges), maximum(last, g.edges))

# ╔═╡ f775760a-1311-4060-a347-aa2d631be0e4
function outgoing_neighbors(g::ListGraph, u)
	return (v for (u_bis, v) in g.edges if u_bis == u)
end

# ╔═╡ 4d38d5dd-6ee7-4847-b3d4-b139c4e52cfb
md"""
## Adjacency list
"""

# ╔═╡ 182a5805-f90d-4b1b-a874-c5da4aaf7c51
md"""
Copy-paste code from group 1
"""

# ╔═╡ db189e71-79af-48d4-bd94-6c30bef943a3
md"""
## Adjacency matrix
"""

# ╔═╡ 7dc96a58-5490-4046-8882-066ceb3c2932
md"""
Copy-paste code from group 2
"""

# ╔═╡ 778d9984-f09e-4b65-8b6d-07323dc0e39c
md"""
## Sparse transposed adjacency matrix
"""

# ╔═╡ abb0457d-4201-41df-957e-6d1d18fd29a1
md"""
Two ideas to make matrices faster:
- For outgoing neighbors, we want the rows of the adjacency matrix in [contiguous memory slots](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-column-major)
- If the average degree of a vertex is small, the adjacency matrix has many zeros we don't need.

The associated tweaks:
- Store the transpose of the adjacency matrix
- Use a [sparse matrix format](https://docs.julialang.org/en/v1/stdlib/SparseArrays/#man-csc)
"""

# ╔═╡ e35d80c1-043b-4152-b005-c579f2c1557d
begin
	struct TransposedSparseMatrixGraph <: AbstractGraph
		Aᵀ::SparseMatrixCSC{Bool,Int}
	end
	
	function TransposedSparseMatrixGraph(edges)
		n = max(maximum(first, edges), maximum(last, edges))
		U, V = Int[], Int[]
		for (u, v) in edges
			push!(U, u); push!(V, v)
		end
		W = ones(Bool, length(edges))
		Aᵀ = sparse(V, U, W, n, n)
		return TransposedSparseMatrixGraph(Aᵀ)
	end
end

# ╔═╡ 1f8b678c-dbb5-4155-806c-fd072846bf56
nb_vertices(g::TransposedSparseMatrixGraph) = size(g.Aᵀ, 1)

# ╔═╡ 5ca4bfab-13a5-4455-92cf-289ebfbb61a9
function outgoing_neighbors(g::TransposedSparseMatrixGraph, u)
    return @view g.Aᵀ.rowval[nzrange(g.Aᵀ, u)]
end

# ╔═╡ 755b8709-4a86-4b79-a61c-605ba8ecdd8b
"""
	bfs(g, s)

Take an unweighted graph `g` and return the shortest path tree from `s` to all other vertices, represented as a vector of `parents`.
"""
function bfs(g, s)
	# initialize storage
	n = nb_vertices(g)  # here
	explored = fill(false, n)
	parents = fill(0, n)
	q = Queue{Int}()
	# visit source
	explored[s] = true
	parents[s] = s
	enqueue!(q, s)
	# go through the queue
	while !isempty(q)
		u = dequeue!(q)
		for v in outgoing_neighbors(g, u)  # here
			if !explored[v]
				explored[v] = true
				parents[v] = u 
				enqueue!(q, v)
			end
		end
	end
    return parents
end

# ╔═╡ 643c4cd5-6a96-4859-8a91-142946c880e4
let
	g = ListGraph(grid_edges(2, 3))
	bfs(g, 1)
end

# ╔═╡ caba823b-2cb8-4760-9d18-31ab7a065d82
let
	g = ListGraph(grid_edges(100, 100))
	@benchmark bfs($g, 1)
end

# ╔═╡ 4904034d-d259-44f9-b194-95f18f952887
let
	edges = grid_edges(2, 3)
	g = TransposedSparseMatrixGraph(edges)
	@assert bfs(g, 1) ≈ bfs(ListGraph(edges), 1)
end

# ╔═╡ c4c2597b-08a5-4806-aeb2-a083ce6db5be
let
	edges = grid_edges(100, 100)
	g = TransposedSparseMatrixGraph(edges)
	@benchmark bfs($g, 1)
end

# ╔═╡ 79cd1553-4407-49dd-a3d3-be624bf44bee
md"""
# The graphs ecosystem
"""

# ╔═╡ b7208479-cb4d-485e-bbe0-e50b84408beb
md"""
## JuliaGraphs organization
"""

# ╔═╡ 49e7c89e-219a-43eb-ac0f-7ca0c675ed86
md"""
[Group of volunteers](https://juliagraphs.org/) maintaining a set of useful packages, including:

- [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl): interface and algorithms + unweighted graphs
- [SimpleWeightedGraphs.jl](https://github.com/JuliaGraphs/SimpleWeightedGraphs.jl): weighted graphs
- [MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl): graphs with arbitrary metadata
"""

# ╔═╡ d3b6841b-3764-4a39-adf0-f5a4d03f8b15
md"""
## The great census of 2023
"""

# ╔═╡ 2a1814cd-dd77-4b00-8aee-7623ad3f024c
md"""
## An ambitious overhaul
"""

# ╔═╡ 7eda4d40-46e3-4192-b152-135c80495435
md"""
[GraphsBase.jl](https://github.com/JuliaGraphs/GraphsBase.jl) is an attempt to generalize the existing interface:

- contiguous integer vertices $\longrightarrow$ arbitrary vertex types
- edge weights $\longrightarrow$ edge and vertex metadata
- simple edges $\longrightarrow$ multiple edges

Still very much a work in progress
"""

# ╔═╡ 3d2673e1-d1af-44d3-8441-7825504102be
md"""
# References
"""

# ╔═╡ 7eb7606b-2f65-41c8-a510-6e40f4c306cf
md"""
**Books**

- Korte, B., and Vygen, J. (2006), *[Combinatorial Optimization: Theory and Algorithms](https://www.mathematik.uni-muenchen.de/~kpanagio/KombOpt/book.pdf)*
- Cormen, T. H., Leiserson, C. E., Rivest, R. L., and Stein, C. (2009), *[Introduction to Algorithms](https://edutechlearners.com/download/Introduction_to_algorithms-3rd%20Edition.pdf)*
- Cook, W. J. (2012), *[In Pursuit of the Traveling Salesman: Mathematics at the Limits of Computation](https://viterbik12.usc.edu/wp-content/uploads/2017/06/Carlsson-Pages-from-William_Cook_In_pursuit_of_the_traveling_salesman.pdf)*
- Bona, M. (2016), *[A Walk Through Combinatorics: An Introduction To Enumeration And Graph Theory](https://www.microlinkcolleges.net/elib/files/undergraduate/Mathematics/A%20Walk%20Through%20Combinatorics%20An%20Introduction%20to%20Enumeration%20and%20Graph%20Theory.pdf)*

**Other**

- [VisuAlgo](https://visualgo.net/en): Visualize many combinatorial algorithms with pseudocode indications and correctness proofs
- [WilliamFiset](https://www.youtube.com/channel/UCD8yeTczadqdARzQUp29PJw): A YouTube channel with a great series of short videos on graph theory
"""

# ╔═╡ ad2a7440-dc91-43cf-9fa5-ea49cf79f543
begin
	struct SplitTwoColumn{L, R}
		left::L
		right::R
	end
	
	function Base.show(io, mime::MIME"text/html", tc::SplitTwoColumn)
		write(io, """<div style="display: flex;"><div style="flex: 47%;">""")
		show(io, mime, tc.left)
		write(io, """</div><div style="flex: 6%;">""")
		write(io, """</div><div style="flex: 47%;">""")
		show(io, mime, tc.right)
		write(io, """</div></div>""")
	end
end

# ╔═╡ 48b97a84-20c4-4660-949e-047152b374c8
SplitTwoColumn(
	md"""
!!! warning "Group 1"
	Write a `struct` for a directed unweighted graph stored as an **adjacency list**.
	""",
	md"""
!!! warning "Group 2"
	Write a `struct` for a directed unweighted graph stored as an **adjacency matrix**.
	"""
)

# ╔═╡ 984533f4-b473-414d-a240-676c83351814
SplitTwoColumn(
	md"""
!!! warning "Group 1"
	Make your adjacency list graph type a subtype of `AbstractGraph` and implement the required methods.
""",
	md"""
!!! warning "Group 2"
	Make your adjacency matrix graph type a subtype of `AbstractGraph` and implement the required methods.
"""
)

# ╔═╡ 617845d0-993f-4dd7-a640-f5b59f2df452
SplitTwoColumn(
	md"""
[The graphs ecosystem](https://discourse.julialang.org/t/the-graphs-ecosystem/99463) contains

- 3 packages defining a broad interface
- 15 packages for graphs with metadata
- 4 packages for multigraphs and hypergraphs
- 8 packages for graphs with special structure
""",
	Resource("https://i.imgur.com/afI4sp8.jpg", :width => "100%")
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
DataStructures = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ProfileCanvas = "efd6af41-a80b-495e-886c-e51b0c7d77a3"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
BenchmarkTools = "~1.3.2"
DataStructures = "~0.18.15"
GraphPlot = "~0.5.2"
Graphs = "~1.9.0"
PlutoTeachingTools = "~0.2.5"
PlutoUI = "~0.7.48"
ProfileCanvas = "~0.1.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "06c2f076354b7a3f0c1d4d7be79e26c72f521b36"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

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
git-tree-sha1 = "cc4bd91eba9cdbbb4df4746124c22c0832a460d6"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.1.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "bf6570a34c850f99407b494757f5d7ad233a7257"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.5"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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

[[deps.GraphPlot]]
deps = ["ArnoldiMethod", "ColorTypes", "Colors", "Compose", "DelimitedFiles", "Graphs", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "5cd479730a0cb01f880eff119e9803c13f214cab"
uuid = "a2cc645c-3eea-5389-862e-a155d0052231"
version = "0.5.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

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

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IterTools]]
git-tree-sha1 = "4ced6667f9974fc5c5943fa5e2ef1ca43ea9e450"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.8.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "0f960b1404abb0b244c1ece579a0ec78d056a5d1"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.15"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

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
git-tree-sha1 = "dedbebe234e06e1ddad435f5c6f4b85cd8ce55f7"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.2"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

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
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "cceb0257b662528ecdf0b4b4302eb00e767b38e7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.0"

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
git-tree-sha1 = "ea3e4ac2e49e3438815f8946fa7673b658e35bdb"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

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
git-tree-sha1 = "dad726963ecea2d8a81e26286f625aee09a91b7c"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.4.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

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
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

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
# ╠═510bdffa-6367-11ed-23ca-9d49e3f3543f
# ╠═66106324-994f-4751-8a1e-0b307380bd11
# ╟─9eb4b899-4b05-4301-9e65-13029b25cdbb
# ╟─b84043ea-bb4d-4527-b31f-76cc90ebc7dc
# ╟─683da7e5-2794-4766-a026-cb55bd23690f
# ╟─bf07f944-19a0-4d3a-bdae-4ef1ed2d9f64
# ╟─07294a71-73a0-4993-b076-671fcc9c8d93
# ╟─c6310180-499a-4dd1-bda3-8d86f791c1b0
# ╟─f9290e78-f1e9-44d1-90fc-d7c002623cf4
# ╟─cc26831a-fab9-4e65-8e4b-4c89371c6970
# ╟─f4059c54-e68b-4004-b3ee-78a7fca03dcc
# ╟─f07cd793-3570-4b0d-9f8a-f8835304480b
# ╟─aee9adf7-92ca-483f-a1b3-744b9a07970d
# ╟─48b97a84-20c4-4660-949e-047152b374c8
# ╟─5e0e9565-0798-4a92-bafe-e8e69d4ab7f9
# ╟─e1520e15-839e-4ff4-8b93-023a1b6a78e3
# ╟─bec05993-17de-4121-af30-2ae15956c6e1
# ╟─5230069e-a2aa-40fe-a2e5-aceefe6b6635
# ╟─abc30a8b-b728-4936-a9b3-cdbf210a265d
# ╠═755b8709-4a86-4b79-a61c-605ba8ecdd8b
# ╟─e9f3585c-0b5b-497a-9a5f-55cb5963d7ac
# ╠═981d2bc0-3030-4d4a-a2c3-ae6c3819838d
# ╟─789c7a0a-870d-4fdb-a11d-4ab314cbbce9
# ╠═1de57dcb-85c0-44c0-b225-f81194ffea06
# ╠═c4d83106-f940-4c69-bb95-8effe7e8bd50
# ╟─7448ed44-0f65-4d4a-b4f4-20b165a34a44
# ╠═2abd6312-b4f5-4301-8881-d86ddfce66cd
# ╟─3693c497-5420-48cf-ae65-cbed6f60ae36
# ╟─984533f4-b473-414d-a240-676c83351814
# ╟─8d31706c-c953-4d96-af97-ff661522f69f
# ╟─34cb6e80-43b9-48db-853a-d51ad53164ac
# ╟─dbeda7e3-ce02-49c2-93b1-1e2e712c9c09
# ╟─f4fc6854-a44d-4bfd-88bd-a3b9eaf95332
# ╟─d89807e0-612d-4794-b06f-b4a233ef9abe
# ╟─055d49e6-8b2e-462d-abe3-bf3c5c97f61c
# ╠═24722797-ae00-4066-8838-43e9eb4b5ee3
# ╠═95df5658-24d0-440d-b157-e4cf54c11d1a
# ╠═3931bfba-cb35-487d-a798-923e8ee454d2
# ╠═57f66ed6-b4aa-4ab0-9eaa-02f12983594a
# ╟─de48b3f3-3cba-45b9-b0ef-eb7cfbb2c7aa
# ╠═669c587c-c877-4e9e-a934-2850c4208147
# ╠═55252064-0f58-44ac-a836-981a6cd8227a
# ╠═f775760a-1311-4060-a347-aa2d631be0e4
# ╠═643c4cd5-6a96-4859-8a91-142946c880e4
# ╠═caba823b-2cb8-4760-9d18-31ab7a065d82
# ╟─4d38d5dd-6ee7-4847-b3d4-b139c4e52cfb
# ╟─182a5805-f90d-4b1b-a874-c5da4aaf7c51
# ╟─db189e71-79af-48d4-bd94-6c30bef943a3
# ╟─7dc96a58-5490-4046-8882-066ceb3c2932
# ╟─778d9984-f09e-4b65-8b6d-07323dc0e39c
# ╟─abb0457d-4201-41df-957e-6d1d18fd29a1
# ╠═e35d80c1-043b-4152-b005-c579f2c1557d
# ╠═1f8b678c-dbb5-4155-806c-fd072846bf56
# ╠═5ca4bfab-13a5-4455-92cf-289ebfbb61a9
# ╠═4904034d-d259-44f9-b194-95f18f952887
# ╠═c4c2597b-08a5-4806-aeb2-a083ce6db5be
# ╟─79cd1553-4407-49dd-a3d3-be624bf44bee
# ╟─b7208479-cb4d-485e-bbe0-e50b84408beb
# ╟─49e7c89e-219a-43eb-ac0f-7ca0c675ed86
# ╟─d3b6841b-3764-4a39-adf0-f5a4d03f8b15
# ╟─617845d0-993f-4dd7-a640-f5b59f2df452
# ╟─2a1814cd-dd77-4b00-8aee-7623ad3f024c
# ╟─7eda4d40-46e3-4192-b152-135c80495435
# ╟─3d2673e1-d1af-44d3-8441-7825504102be
# ╟─7eb7606b-2f65-41c8-a510-6e40f4c306cf
# ╟─ad2a7440-dc91-43cf-9fa5-ea49cf79f543
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
