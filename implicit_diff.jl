### A Pluto.jl notebook ###
# v0.19.11

#> [frontmatter]
#> title = "HW2 - Automatic and implicit differentiation"
#> date = "2022-09-22"

using Markdown
using InteractiveUtils

# ╔═╡ ddbf8ae6-39b6-11ed-226e-0d38991ed784
begin
	using BenchmarkTools
	using ChainRulesCore
	using KrylovKit
	using LinearAlgebra
	using PlutoTeachingTools
	using PlutoUI
	import Zygote
end

# ╔═╡ f447c167-2bcb-4bf3-86cd-0f40f4e54c97
TableOfContents()

# ╔═╡ a405d214-4348-4692-999e-0e890bd91e5d
md"""
# HW2 - Automatic and implicit differentiation
"""

# ╔═╡ e7fa3587-d99d-4a77-b99d-a58b2df8f3c0
md"""
# 1. Calculus and autodiff refresher
"""

# ╔═╡ 4d9d2f52-c406-4a7c-8b0e-ba5af7ebc3d8
md"""
## From differentials to Jacobians

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

# ╔═╡ d76d5ddc-fe59-47f4-8b56-6f704b486ebc
md"""
### Example: linear regression

Linear regression is perhaps the most basic form of machine learning.
Given a matrix of features $X \in \mathbb{R}^{m \times n}$ and a vector of targets $y \in \mathbb{R}^m$, we approximate $y$ by a linear function $X\theta$, where $\theta \in \mathbb{R}^n$ is a vector of parameters.
One way to measure the quality of the approximation for a given $\theta$ is to compute the quadratic error on each component of $y$:

$$f: \theta \in \mathbb{R}^n \longmapsto (X\theta - y) \odot (X\theta - y) \in \mathbb{R}^m$$

where $\odot$ denotes the componentwise product.
To insert this function into a neural network, we need to differentiate it with respect to the parameters.
"""

# ╔═╡ ae7b2114-de91-4f1b-8765-af5e02cc1b63
md"""
> Task: Compute the differential and then the Jacobian matrix of the function $f$ at a point $\theta$.
"""

# ╔═╡ b8974b20-d8dc-4109-a64e-585c7afdb484
md"""
Let us look at what happens when we add a small perturbation $\varepsilon$ to $\theta$:

$$\begin{aligned}
f(\theta + \varepsilon)
& = [X(\theta + \varepsilon) - y] \odot [X(\theta + \varepsilon) - y] \\
& = [(X\theta - y) + X\varepsilon] \odot [(X\theta - y) + X\varepsilon]
\end{aligned}$$

The componentwise product is bilinear, which means we can expand as follows:

$$\begin{aligned}
f(\theta + \varepsilon)
& = \underbrace{(X\theta - y) \odot (X\theta - y)}_{f(\theta)} + \underbrace{2(X\theta - y) \odot X\varepsilon}_{df_\theta(\varepsilon)} + \underbrace{X\varepsilon \odot X\varepsilon}_{o(\lVert \varepsilon \rVert)}
\end{aligned}$$

The middle term of the right hand side is a linear function of $\varepsilon$, which is how we identify the differential:

$$df_\theta: \varepsilon \in \mathbb{R}^n \longmapsto 2(X\theta - y) \odot X\varepsilon \in \mathbb{R}^m$$

Now we only need to work out the Jacobian associated with this differential.
The trick is to represent componentwise multiplication using a diagonal matrix:

$$Jf_\theta = 2 \mathrm{diag}(X\theta - y) X$$
"""

# ╔═╡ 28f31ef9-27ea-4e94-8f03-89b0f6cfa0d1
md"""
> Task: Implement the function $f$ and a function computing its Jacobian matrix.
"""

# ╔═╡ 7d27892c-4781-4f22-a37e-2be5bafa68b1
hint(md"You can use `.*` for the componenwise product, and `Diagonal` (from `LinearAlgebra`) to create a diagonal matrix from a vector.")

# ╔═╡ 883803e0-2fa1-4922-be37-f325af4f5c41
function linreg_errors(θ; X, y)
	err = (X * θ .- y)
	return err .* err
end

# ╔═╡ c5fc8f3a-ed90-41ec-b4b9-1172a41e3adc
function linreg_errors_jacobian(θ; X, y)
	return 2 .* Diagonal(X * θ .- y) * X
end

# ╔═╡ 40e13883-dd9a-43b9-9ef7-1069ef036846
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	ε = 0.001 .* rand(n)
	diff1 = linreg_errors(θ + ε; X=X, y=y) .- linreg_errors(θ; X=X, y=y)
	diff2 = linreg_errors_jacobian(θ; X=X, y=y) * ε
	diff1, diff2
end

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

# ╔═╡ face60fb-e54e-4490-8002-daa56c3f14f8
md"""
### Example (continued)

> Task: In the case of linear regression, explain (with your own words) why it uses less memory and CPU to compute a single JVP / VJP than the full Jacobian matrix. 
"""

# ╔═╡ 870bf931-7dc6-47fa-9d48-7f294a81e65d
md"""
Because we can perform two matrix-vector product one after the other:

$$\begin{aligned}
	Jf_\theta u & = 2 \mathrm{diag}(X\theta - y) (Xu) \\
	v^\top Jf_\theta & = (v^\top 2 \mathrm{diag}(X\theta - y)) X \\
\end{aligned}$$

Besides, the products with a diagonal matrix can be implemented as componentwise operations.
"""

# ╔═╡ 7bb17e25-0fee-43d1-9cf6-309e8363ebfa
md"""
> Task: Implement functions that compute the JVP and the VJP for $f$. Make sure that the VJP returns a column vector and not a row vector.
"""

# ╔═╡ 10db457a-e546-45fd-b8d5-c22b16f4aae5
function linreg_errors_jvp(u, θ; X, y)
	return (2 .* (X * θ .- y)) .* (X * u)
end

# ╔═╡ a0e5cac8-a775-46ab-9f62-e8bdedc68ebe
function linreg_errors_vjp(v, θ; X, y)
	return X' * (v .* 2 .* (X * θ .- y))
end

# ╔═╡ 004f563d-d265-4cd7-81ee-614f03aec9cb
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	u = rand(n)
	v = rand(m)
	jvp = linreg_errors_jvp(u, θ; X=X, y=y)
	vjp = linreg_errors_vjp(v, θ; X=X, y=y)
	jvp, vjp
end

# ╔═╡ 5f82da90-5fb4-45df-8a23-150ef60f0137
md"""
> Task: Check the correctness of your JVP / VJP using the following naive implementations.
"""

# ╔═╡ 5459eef9-6731-40f6-858c-095d31389c79
function linreg_errors_jvp_naive(u, θ; X, y)
	J = linreg_errors_jacobian(θ; X=X, y=y)
	return J * u
end

# ╔═╡ 07308936-f443-457e-af09-c66ce365c289
function linreg_errors_vjp_naive(v, θ; X, y)
	J = linreg_errors_jacobian(θ; X=X, y=y)
	return J' * v
end

# ╔═╡ 45bc5357-2150-4f7c-8274-1897cb0eaa42
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	u = rand(n)
	jvp = linreg_errors_jvp(u, θ; X=X, y=y)
	jvp_naive = linreg_errors_jvp_naive(u, θ; X=X, y=y)
	@assert jvp ≈ jvp_naive
	jvp, jvp_naive
end

# ╔═╡ 7a2c6e9d-13da-4701-9080-3f98e602f2e1
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	v = rand(m)
	vjp = linreg_errors_vjp(v, θ; X=X, y=y)
	vjp_naive = linreg_errors_vjp_naive(v, θ; X=X, y=y)
	@assert vjp ≈ vjp_naive
	vjp, vjp_naive
end

# ╔═╡ 077a4a05-18c3-4b5d-b72a-333b6eee0db2
md"""
> Task: Compare the performance of your JVP / VJP to that of the naive implementations.
"""

# ╔═╡ 253ed069-8a26-4887-9f0d-a715c786eb66
hint(md"You can use the macro `@benchmark` (from `BenchmarkTools.jl`). For technical reasons, you will need to put dollar signs in front of every variable when calling your functions.")

# ╔═╡ 1dda6335-e574-4af8-bc0b-ef620bee5cf7
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	u = rand(n)
	benchmark = @benchmark linreg_errors_jvp($u, $θ; X=$X, y=$y)
	benchmark_naive = @benchmark linreg_errors_jvp_naive($u, $θ; X=$X, y=$y)
	benchmark, benchmark_naive
end

# ╔═╡ 97f88ed8-6e6b-4ef3-acbb-cf609f5372b5
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	v = rand(m)
	benchmark = @benchmark linreg_errors_vjp($v, $θ; X=$X, y=$y)
	benchmark_naive = @benchmark linreg_errors_vjp_naive($v, $θ; X=$X, y=$y)
	benchmark, benchmark_naive
end

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

Utilities that compose JVPs (or VJPs) using the chain rule are the second ingredient of autodiff.
In Julia, this is taken care of by various backends, such as `Zygote.jl` or `Enzyme.jl`.
While some are more widely used than others, there is no clear best choice: a comprehensive list of options is available on the [JuliaDiff](https://juliadiff.org/) website.

Making composition work for arbitrary computational graphs is no easy task, and it is the subject of ongoing research.
That is why we do not ask you to try it at home.
In the rest of this homework, our goal is to show how custom JVPs and VJPs can be defined, and we will let the autodiff backend take care of composition.
"""

# ╔═╡ 8752f8f9-55f5-42bb-b3da-45e4a2d41779
md"""
## `ChainRules.jl`

The `ChainRules.jl` package is an attempt to unify JVP and VJP rules (also called "pushforwards" and "pullbacks") for many different autodiff backends.
It contains rules for most of the Julia standard library, but also allows users to define homemade rules.
We strongly encourage you to read the [first page of the `ChainRules.jl` documentation](https://juliadiff.org/ChainRulesCore.jl/stable/) before going further.

Custom rules are mainly useful in two situations.

1. First, autodiff backends are not all-powerful: many of them impose limitations on the language constructs they accept. For instance, functions that mutate one of their arguments (typically indicated with a `!`) will give rise to errors with most reverse mode backends. Another example is functions that call other programming languages (like C++ or Python). 
2. Second, the derivatives computed by autodiff backends may be suboptimal in terms of performance. This is typically the case for iterative procedures: fixed point algorithms, optimization routines, ODE solvers, etc. For such functions, the default behavior of an autodiff backend is to "unroll" the iterations and differentiate through them one at a time.

We illustrate situation 1 below, and use this opportunity to introduce the rule writing syntax.
An elegant solution for situation 2 is implicit differentiation, which we introduce in the second part of this homework.
From now on, we only focus on reverse mode autodiff, that is, we forget all about JVPs and only work with VJPs.
"""

# ╔═╡ b3fd3a8b-22fd-40a0-9af3-0c66a7ec05a3
md"""
### Example (continued)

Here we focus on an alternative implementation of the error function $f$, which involves mutation.
"""

# ╔═╡ ea16d4c6-d6e4-46fa-a721-fa5a0f2ff021
function linreg_errors_mutating(θ; X, y)
	err = (X * θ .- y)
	err .^= 2
	return err
end

# ╔═╡ 53c4fb54-ab79-4924-9d65-fc5e5b5b50a1
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	err1 = linreg_errors(θ; X=X, y=y)
	err2 = linreg_errors_mutating(θ; X=X, y=y)
	err1, err2
end

# ╔═╡ 568abbe8-872c-4e76-a2ad-52d894f8cf01
md"""
The mutating version is quite efficient, perhaps more than the one you wrote.
"""

# ╔═╡ 20011833-32f1-4c6f-bb51-ae809aeb3dd3
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	benchmark1 = @benchmark linreg_errors($θ; X=$X, y=$y)
	benchmark2 = @benchmark linreg_errors_mutating($θ; X=$X, y=$y)
	benchmark1, benchmark2
end

# ╔═╡ 80fb6b17-69f1-40fc-96d4-fa3f0a05f349
md"""
But this version makes our reverse mode autodiff backend (`Zygote.jl`) very angry.
Fortunately, we have done all the grunt work and can easily define a custom reverse rule to overcome this issue.
This is done by implementing a new method of `ChainRulesCore.rrule`, which must return two things:

- the output $f(x)$ of the initial function
- a `pullback` function that takes $v$ as input and outputs the VJP $v^\top Jf_x$ 
"""

# ╔═╡ e6df285d-b8d9-434a-ba83-02fc5e3d83bb
function ChainRulesCore.rrule(f::typeof(linreg_errors_mutating), θ; X, y)
	err = linreg_errors_mutating(θ; X=X, y=y)
	function pullback(v)
		@info "Calling pullback" v
		vjp_f = NoTangent()
		vjp_θ = linreg_errors_vjp(v, θ; X=X, y=y)
		return (vjp_f, vjp_θ)
	end
	return err, pullback
end

# ╔═╡ e8b97c6f-9228-4fa4-99aa-9c81fb582693
md"""
Here are a few explanations regarding the syntax.

- What does `f::typeof(linreg_errors_mutating)` do? It tells `ChainRulesCore.jl` that the reverse rule we define applies to one specific function. In Julia, each function has its own unique type, which allows us to dispatch on it.
- Why does `pullback` return a $2$-tuple? Because in some settings, the function $f$ may have internal parameters that we also want to take into account when differentiating. It is not the case here, so we specify that there is no tangent (VJP) with respect to `f`. This is the role of the dummy `NoTangent()` struct. On the other hand, the tangent (VJP) with respect to `θ` does exist, so we return an actual value for this one.
- Okay but then what about `X` and `y`? Shouldn't the pullback return a $4$-tuple? By convention, `ChainRulesCore.jl` only considers derivatives with respect to positional arguments, not keyword arguments.
"""

# ╔═╡ 98a59f9c-af6c-460a-bf70-f4e28da1aa80
let
	n, m = 3, 5
	X = rand(m, n)
	y = rand(m)
	θ = rand(n)
	jac0 = linreg_errors_jacobian(θ; X=X, y=y)
	jac1 = Zygote.jacobian(θ -> linreg_errors(θ; X=X, y=y), θ)[1]
	# Run the following line without a custom rrule, and you will get an error
	jac2 = Zygote.jacobian(θ -> linreg_errors_mutating(θ; X=X, y=y), θ)[1]
	jac0, jac1, jac2
end

# ╔═╡ b0341e9e-bc59-4530-8a92-0d54995de534
md"""
> Task: Explain why the pullback is called several times when computing the Jacobian.
"""

# ╔═╡ ae94949d-3a91-462d-8302-065c162d412b
md"""

"""

# ╔═╡ 93585262-4d86-48cf-a1c3-6b83615879d6
md"""
# 2. Implicit differentiation
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
## Implicit differentiation
"""

# ╔═╡ 14f4b3cd-3cbc-41c7-9038-0e3db1809447
md"""
## Bonus round: matrix-free solver
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
BenchmarkTools = "~1.3.1"
ChainRulesCore = "~1.15.5"
KrylovKit = "~0.5.4"
PlutoTeachingTools = "~0.2.3"
PlutoUI = "~0.7.40"
Zygote = "~0.6.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "f9e5d3087c5ed2087b1075066cd418a666749ef0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "Statistics", "StructArrays"]
git-tree-sha1 = "a5fd229d3569a6600ae47abe8cd48cbeb972e173"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.44.6"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "dc4405cee4b2fe9e1108caec2d760b7ea758eca2"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.5"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "1833bda4a027f4b2a1c984baddcf755d77266818"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.1.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.DataAPI]]
git-tree-sha1 = "1106fa7e1256b402a86a8e7b15c00c85036fef49"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.11.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "992a23afdb109d0d2f8802a30cf5ae4b1fe7ea68"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "87519eb762f85534445f5cda35be12e32759ee14"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.4"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "187198a4ed8ccd7b5d99c41b69c679269ea2b2d4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.32"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "45d7deaf05cbb44116ba785d147c518ab46352d7"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.5.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

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

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "af14a478780ca78d5eb9908b263023096c2b9d64"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.6"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

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

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "e7e9184b0bf0158ac4e4aa9daf00041b5909bf1a"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "4.14.0"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg", "TOML"]
git-tree-sha1 = "771bfe376249626d3ca12bcd58ba243d3f961576"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.16+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "dedbebe234e06e1ddad435f5c6f4b85cd8ce55f7"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.2"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "0e8bcc235ec8367a8e9648d48325ff00e4b0a545"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.5"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "d8be3432505c2febcea02f44e5f4396fae017503"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "efa8acd030667776248eabb054b1836ac81d92f0"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.7"

[[deps.StaticArraysCore]]
git-tree-sha1 = "ec2bd695e905a3c755b33026954b119ea17f2d22"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.3.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArraysCore", "Tables"]
git-tree-sha1 = "8c6ac65ec9ab781af05b08ff305ddc727c25f680"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.12"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "7149a60b01bf58787a1b83dad93f90d4b9afbe5d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.8.1"

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

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "a789623d84d72551b791bbd9daae37cc1fc0f7ad"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.48"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─d76d5ddc-fe59-47f4-8b56-6f704b486ebc
# ╟─ae7b2114-de91-4f1b-8765-af5e02cc1b63
# ╟─b8974b20-d8dc-4109-a64e-585c7afdb484
# ╟─28f31ef9-27ea-4e94-8f03-89b0f6cfa0d1
# ╟─7d27892c-4781-4f22-a37e-2be5bafa68b1
# ╠═883803e0-2fa1-4922-be37-f325af4f5c41
# ╠═c5fc8f3a-ed90-41ec-b4b9-1172a41e3adc
# ╠═40e13883-dd9a-43b9-9ef7-1069ef036846
# ╟─8923a5ad-ddba-4ae2-886e-84526a3521ba
# ╟─face60fb-e54e-4490-8002-daa56c3f14f8
# ╟─870bf931-7dc6-47fa-9d48-7f294a81e65d
# ╟─7bb17e25-0fee-43d1-9cf6-309e8363ebfa
# ╠═10db457a-e546-45fd-b8d5-c22b16f4aae5
# ╠═a0e5cac8-a775-46ab-9f62-e8bdedc68ebe
# ╠═004f563d-d265-4cd7-81ee-614f03aec9cb
# ╟─5f82da90-5fb4-45df-8a23-150ef60f0137
# ╠═5459eef9-6731-40f6-858c-095d31389c79
# ╠═07308936-f443-457e-af09-c66ce365c289
# ╠═45bc5357-2150-4f7c-8274-1897cb0eaa42
# ╠═7a2c6e9d-13da-4701-9080-3f98e602f2e1
# ╟─077a4a05-18c3-4b5d-b72a-333b6eee0db2
# ╟─253ed069-8a26-4887-9f0d-a715c786eb66
# ╠═1dda6335-e574-4af8-bc0b-ef620bee5cf7
# ╠═97f88ed8-6e6b-4ef3-acbb-cf609f5372b5
# ╟─f843b77d-8160-4d87-8641-eeb04549af8f
# ╟─8752f8f9-55f5-42bb-b3da-45e4a2d41779
# ╟─b3fd3a8b-22fd-40a0-9af3-0c66a7ec05a3
# ╠═ea16d4c6-d6e4-46fa-a721-fa5a0f2ff021
# ╠═53c4fb54-ab79-4924-9d65-fc5e5b5b50a1
# ╟─568abbe8-872c-4e76-a2ad-52d894f8cf01
# ╠═20011833-32f1-4c6f-bb51-ae809aeb3dd3
# ╟─80fb6b17-69f1-40fc-96d4-fa3f0a05f349
# ╠═e6df285d-b8d9-434a-ba83-02fc5e3d83bb
# ╟─e8b97c6f-9228-4fa4-99aa-9c81fb582693
# ╠═98a59f9c-af6c-460a-bf70-f4e28da1aa80
# ╟─b0341e9e-bc59-4530-8a92-0d54995de534
# ╠═ae94949d-3a91-462d-8302-065c162d412b
# ╟─93585262-4d86-48cf-a1c3-6b83615879d6
# ╟─98580356-21c5-472a-aedd-4f47a6799f24
# ╟─60b6952b-d546-4663-9f4f-800b437621f1
# ╟─d6fbb62f-f89a-4737-84fd-736f5af206d6
# ╟─14f4b3cd-3cbc-41c7-9038-0e3db1809447
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
