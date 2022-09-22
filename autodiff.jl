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
	using LinearAlgebra
	using PlutoTeachingTools
	using PlutoUI
	import Zygote
end

# ╔═╡ f447c167-2bcb-4bf3-86cd-0f40f4e54c97
TableOfContents()

# ╔═╡ a405d214-4348-4692-999e-0e890bd91e5d
md"""
# HW2 - Automatic differentiation
"""

# ╔═╡ 1cfba628-aa7b-4851-89f1-84b1a45802b3
md"""
# 1. Warm up: scalar functions
"""

# ╔═╡ 3829f016-a7cd-4ce6-b2d4-1c84da8fdb97
md"""
Let $f : \mathbb{R} \longrightarrow \mathbb{R}$ be a function with scalar input and output.
When we say that $f$ is differentiable at $x \in \mathbb{R}$, we mean that there is a _number_ $f'(x) \in \mathbb{R}$ such that for any perturbation $h \in \mathbb{R}$,

$$f(x+h) = f(x) + f'(x)h + o(h)$$

In other words, $f$ can be approximated with a straight tangent line around $x$.
Furthermore, the error is negligible compared with the distance $\lvert h \rvert$ to $x$, at least for small enough values of $\lvert h \rvert$ (that is what the $o(h)$ means).

The number $f'(x)$ is called the _derivative_ of $f$ at $x$, and it gives the slope of the tangent.
"""

# ╔═╡ 755ff203-43d8-488f-a075-14a858b0a096
md"""
To generalize derivatives in higher dimensions, we will need to shift our focus from lines to functions.
Indeed, a straight line with slope $f'(x)$ is nothing but a linear function $h \longmapsto f'(x)h$.
So computing a derivative boils down to the following question:

_What is the best linear approximation of my function around a given point?_
"""

# ╔═╡ a7d2e710-cf08-4c77-9042-78ee73b6f698
md"""
# 2. From differentials to Jacobians
"""

# ╔═╡ d50a296b-bbfc-4d88-b8db-582f6176609d
md"""
## Theory
"""

# ╔═╡ 4d9d2f52-c406-4a7c-8b0e-ba5af7ebc3d8
md"""
Let $f: \mathcal{A} \longrightarrow \mathcal{B}$ be a function between two normed vector spaces.
When we say that $f$ is differentiable at $x \in \mathcal{A}$, we mean that there is a _linear function_ $df_x: \mathcal{A} \longrightarrow \mathcal{B}$ such that for any perturbation $h \in \mathcal{A}$,

$$f(x + h) = f(x) + df_x(h) + o(\lVert h \rVert)$$

The linear function $df_x$ is called the _differential_ of $f$ at $x$.
"""

# ╔═╡ de4df88a-2a55-4a02-aeaf-f02242b6c52f
md"""
When $\mathcal{A} = \mathbb{R}^n$ and $\mathcal{B} = \mathbb{R}^m$ are both Euclidean spaces, we can always find a matrix $Jf_x \in \mathbb{R}^{m \times n}$ that satisfies

$$df_x(h) = Jf_x h$$

In the previous equation, the left hand side is the application of a function to a vector, while the right hand side is a matrix-vector product.
The matrix $Jf_x$ is called the _Jacobian_ of $f$ at $x$.
"""

# ╔═╡ e22cec4a-03d3-4821-945b-9283e16207a8
md"""
It can be expressed with partial derivatives: if $x = (x_1, ..., x_n)$ and $f(x) = (f_1(x), ..., f_m(x))$, then

$$Jf_x = \begin{pmatrix}
\frac{\partial f_1(x)}{\partial x_1} & \frac{\partial f_1(x)}{\partial x_2} & \cdots & \frac{\partial f_1(x)}{\partial x_n} \\
\frac{\partial f_2(x)}{\partial x_1} & \frac{\partial f_2(x)}{\partial x_2} & \cdots & \frac{\partial f_2(x)}{\partial x_n} \\
\vdots & \vdots & \ddots & \vdots \\
\frac{\partial f_m(x)}{\partial x_1} & \frac{\partial f_m(x)}{\partial x_2} & \cdots & \frac{\partial f_m(x)}{\partial x_n} \\
\end{pmatrix}$$

However, it is good practice to learn how to manipulate Jacobians in matrix form, without needing to compute individual coefficients.
"""

# ╔═╡ f51920d4-652b-467c-8f02-fcd1a0f92c2e
md"""
The case of real-valued functions is especially interesting in machine learning.
Neural networks are trained by minimizing a scalar loss function computed from their parameters.
While the parameter dimension $n$ may be of order $10^6$ or even $10^9$, the output dimension $m$ is always $1$.
"""

# ╔═╡ e19f2824-e7a0-4ee0-b37d-350342d3cbdd
md"""
!!! danger "Task"
	Consider a real-valued function $f: \mathbb{R}^n \longrightarrow \mathbb{R}$. What is the shape of the Jacobian matrix? What is its relation to the gradient $\nabla f_x$?
"""

# ╔═╡ 82fd26e3-b429-480d-be04-f0ac363c4a31
md"""
When the function $f$ is real-valued, $m = 1$ and the Jacobian matrix only has one row.
It can be seen as the transpose of the gradient: $Jf_x = \nabla f_x^\top$.
"""

# ╔═╡ 25b572fa-1f9a-43f9-98a3-181d8dd6e21a
md"""
---
"""

# ╔═╡ b5241dc4-32c1-4e91-b401-c25f4b7cb3cd
md"""
## Example
"""

# ╔═╡ d76d5ddc-fe59-47f4-8b56-6f704b486ebc
md"""
Linear regression is perhaps the most basic form of machine learning.
Given a matrix of features $M \in \mathbb{R}^{m \times n}$ and a vector of targets $y \in \mathbb{R}^m$, we approximate $y$ by $M x$, where $x \in \mathbb{R}^n$ is a vector of parameters (feature weights).
One way to measure the quality of the approximation for a given $x$ is to compute the squared error on all components of $y$.
Let us denote by $\odot$ the componentwise product between vectors: we define the function

$$f: x \in \mathbb{R}^n \longmapsto (Mx - y) \odot (Mx - y) = \begin{pmatrix} (Mx - y)_1^2 \\ \vdots \\ (Mx - y)_m^2 \end{pmatrix} \in \mathbb{R}^m$$

If we want to find the best possible $x$, we can do it by minimizing the sum of the components of $f(x)$.
We may also wish to use the function $f$ within a larger neural network.
In both cases, it is essential to differentiate $f$ with respect to its input $x$ (assuming $M$ and $y$ are fixed).
"""

# ╔═╡ ae7b2114-de91-4f1b-8765-af5e02cc1b63
md"""
!!! danger "Task"
	Compute the differential of the function $f$ at a point $x$.
"""

# ╔═╡ e4aedbd4-a609-4eaf-812b-d2f3d6f4df3d
hint(md"Write $f(x+h)$ as a componentwise product, and then expand it as you would do with a regular product (trust me, you are allowed to do that).
Keep in mind that you need to group the terms according to their order in $h$: zero-th order, first order or second order.")

# ╔═╡ b8974b20-d8dc-4109-a64e-585c7afdb484
md"""
Let us look at what happens when we add a small perturbation $h$ to $x$:

$$\begin{aligned}
f(x + h)
& = [M(x + h) - y] \odot [M(x + h) - y] \\
& = [(Mx - y) + Mh] \odot [(Mx - y) + Mh] \\
& = \underbrace{(Mx - y) \odot (Mx - y)}_{\text{constant in $h$}} + \underbrace{2 (Mx - y) \odot (Mh)}_{\text{linear in $h$}} + \underbrace{(Mh) \odot (Mh)}_{\text{quadratic in $h$}}
\end{aligned}$$
"""

# ╔═╡ f4994938-9270-4058-9c95-01591c87d9c7
md"""
Now we pause for a minute and examine the three terms we obtained.

1. The first one is exactly the value of $f$ at $x$
2. The second one is a linear function of $h$
3. The third one is a quadratic function of $h$, which is negligible compared to the linear term (in the "small $h$" regime)

This means we can identify the differential:

$$df_x: h \in \mathbb{R}^n \longmapsto 2 (Mx - y) \odot (M h) \in \mathbb{R}^m$$
"""

# ╔═╡ f472111d-d7e8-42db-9a08-6a8dd67af09b
md"""
---
"""

# ╔═╡ bd10d753-eea6-4798-939c-8e5551d40c5c
md"""
!!! danger "Task"
	Compute the Jacobian matrix of the function $f$ at a point $x$. Check that its size is coherent.
"""

# ╔═╡ 2f95afd6-1418-44bb-9868-970dbe888500
hint(md"A componentwise product between two vectors $a \odot b$ can also be interpreted as the multiplication by a diagonal matrix $D(a) b$.
Using this with $a = 2(Mx - y)$ and $b = Mh$ should help you recognize the Jacobian matrix.")

# ╔═╡ 06e91432-935f-4d7c-899f-d7968a10a78e
md"""
If $a \in \mathbb{R}^m$ is a vector, we denote by $D(a)$ the diagonal matrix with diagonal coefficients $a_1, ..., a_m$.
Using the hint above, we find that

$$df_x(h) = 2 D(Mx - y) (Mh) = \left[2 D(Mx-y)M\right] h$$

This yields the following Jacobian formula:

$$Jf_x = 2D(Mx-y)M \in \mathbb{R}^{m \times n}$$
"""

# ╔═╡ 8ff815b0-34a4-4e42-8c18-ff45096ed260
md"""
---
"""

# ╔═╡ 28f31ef9-27ea-4e94-8f03-89b0f6cfa0d1
md"""
!!! danger "Task"
	Implement the function $f$ and a function computing its Jacobian.
"""

# ╔═╡ ca4b41dd-353e-498d-a461-648c582cb999
hint(md"You may want to use the `Diagonal` constructor from `LinearAlgebra`.")

# ╔═╡ 883803e0-2fa1-4922-be37-f325af4f5c41
function f(x; M, y)
	err = (M * x .- y) .^ 2
	return err
end

# ╔═╡ c5fc8f3a-ed90-41ec-b4b9-1172a41e3adc
function Jf(x; M, y)
	return 2 * Diagonal(M * x .- y) * M
end

# ╔═╡ 40e13883-dd9a-43b9-9ef7-1069ef036846
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	h = 0.001 .* rand(n)
	diff1 = f(x + h; M=M, y=y) .- f(x; M=M, y=y)
	diff2 = Jf(x; M=M, y=y) * h
	diff1, diff2
end

# ╔═╡ 4440f39c-51e5-4ffd-8031-96d4a760270c
md"""
---
"""

# ╔═╡ 69a9ec45-d2ff-4362-9c3c-5c004e46ceb3
md"""
# 3. JVPs and VJPs
"""

# ╔═╡ 7c172e2d-5672-405e-8960-f104607a3610
md"""
## Theory
"""

# ╔═╡ 8923a5ad-ddba-4ae2-886e-84526a3521ba
md"""
In concrete applications, the dimensions $n$ and $m$ often make it impossible to store a full Jacobian (of size $m \times n$) in memory.
As a result, autodiff systems only manipulate Jacobians "lazily" by computing their products with vectors.
These products come in two flavors:

- _Jacobian-vector products_ (JVPs) of the form $u \in \mathbb{R}^n \longmapsto J u \in \mathbb{R}^m$. 
- _vector-Jacobian products_ (VJPs) of the form $v \in \mathbb{R}^m \longmapsto v^\top J \in \mathbb{R}^n$.

With a little bit of sweat, it is usually possible to implement these operations in a clever way.
"""

# ╔═╡ e1b9f114-58e7-4546-a3c0-5e07fb1665e7
md"""
!!! danger "Task"
	How many JVPs would it take to compute the full Jacobian, and what vectors should you choose? Same question for VJPs.
"""

# ╔═╡ ba07ccda-ae66-4fce-837e-00b2b039b404
md"""
- If we cycle through the basis vectors $u = (0, ..., 0, 1, 0, ..., 0) \in \mathbb{R}^n$ of the input space, each product $Ju$ gives us one _column_ of the Jacobian matrix. Therefore, we need $n$ JVPs in total.
- If we cycle through the basis vectors $v = (0, ..., 0, 1, 0, ..., 0) \in \mathbb{R}^m$ of the output space, each product $v^\top J$ gives us one _row_ of the Jacobian matrix. Therefore, we need $m$ VJPs in total.
"""

# ╔═╡ 663e3899-e7b3-4420-8d66-7e88c1b79185
md"""
---
"""

# ╔═╡ 5ae3bf90-6393-45b9-840e-feeb2e727508
md"""
Rules that compute JVPs and VJPs for built-in functions are the first ingredient of autodiff.
They serve as basic building blocks for more complex constructs.
In Julia, these rules are handled by the [`ChainRules.jl`](https://github.com/JuliaDiff/ChainRules.jl) ecosystem (see part 5).
"""

# ╔═╡ 37cab21f-aa70-48c2-be62-55e285481525
md"""
## Example
"""

# ╔═╡ f66a0ea7-70fd-4340-8b02-6fbaab847dfc
md"""
!!! danger "Task"
	Explain why JVPs and JVPs can be computed for our linear regression function $f$ without storing its full Jacobian.
"""

# ╔═╡ 8cca11ed-a61c-4cc8-af4b-350137073756
hint(md"Try to think in terms of computer program instead of mathematics. Describe the sequence of intermediate operations that you would perform for each of these computations.")

# ╔═╡ 7144c6c8-79dd-437d-a201-bac143f6a261
md"""
The JVP can be computed as follows:

$$Jf_x u = 2D(Mx-y)M u \quad \implies \begin{cases} a = Mu \\ b = 2D(Mx-y) a \end{cases}$$

The VJP can be computed as follows:

$$v^\top Jf_x = v^\top 2D(Mx-y)M \quad \implies \begin{cases} a = v^\top 2D(Mx - y) \\ b = a M \end{cases}$$

In both cases, we only need to store a few vectors and not full matrices.
"""

# ╔═╡ 07cd4e47-5fac-49c4-80a5-c5bdf21bd484
md"""
---
"""

# ╔═╡ 45765f4a-536d-4e9d-be9d-144b7ccd4dcf
md"""
!!! danger "Task"
	Implement the JVP and VJP for the function $f$, following the efficient method you just suggested.
	Try to reduce allocations as much as possible by mutating vectors.
"""

# ╔═╡ df89f509-cfd7-46b3-9dd1-cdcfcea68053
hint(md"Now you should revert to `.*` for componentwise products instead of using diagonal matrices.
You may also need the `'` operator for transposition.")

# ╔═╡ 37dbaa56-7b8f-4c2a-ad8c-6c3ba6060cfa
function f_jvp(u, x; M, y)
	return 2 .* (M * x .- y) .* (M * u)
end

# ╔═╡ 0b51e23e-a015-4e86-ba48-6475a9ee9779
function f_vjp(v, x; M, y)
	return (v .* 2 .* (M * x .- y))' * M
end

# ╔═╡ 79880fd1-0fc1-4f14-9d1f-664afcc939c8
md"""
---
"""

# ╔═╡ 14dcad57-23ae-4905-aac4-d29066f2a085
md"""
!!! danger "Task"
	Check the correctness of your JVP / VJP implementations against the naive versions provided below.
"""

# ╔═╡ 0ea654fe-d3d0-4f40-b3dc-806b1982c040
function f_jvp_naive(u, x; M, y)
	J = Jf(x; M=M, y=y)
	return J * u
end

# ╔═╡ 06a59777-b6ec-4808-9105-7a2542a629ea
function f_vjp_naive(v, x; M, y)
	J = Jf(x; M=M, y=y)
	return v' * J
end

# ╔═╡ 90c6515b-b0c0-4f9b-bd4e-ae29c0ecab23
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	u = rand(n)
	jvp1 = f_jvp(u, x; M=M, y=y)
	jvp2 = f_jvp_naive(u, x; M=M, y=y)
	jvp1, jvp2
end

# ╔═╡ 9222d644-5d20-474a-83db-4b2e3bed45e2
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	v = rand(m)
	vjp1 = f_vjp(v, x; M=M, y=y)
	vjp2 = f_vjp_naive(v, x; M=M, y=y)
	vjp1, vjp2
end

# ╔═╡ c511e1c4-0306-46c7-800f-8257266c0091
md"""
!!! danger "Task"
	Compare the performance of both implementations, using the macro `@benchmark` from `BenchmarkTools.jl`.
"""

# ╔═╡ ba206cb6-d2ca-4a4a-9c20-d66b015226dd
hint(md"To obtain unbiased results, you will need to prepend every variable name with a dollar sign `$` when using this macro. Otherwise the variables are treated as global, which impacts performance.")

# ╔═╡ 0cc728dd-40d2-4713-b378-e67b3ed1c44f
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	u = rand(n)
	benchmark1 = @benchmark f_jvp($u, $x; M=$M, y=$y)
	benchmark2 = @benchmark f_jvp_naive($u, $x; M=$M, y=$y)
	benchmark1, benchmark2
end

# ╔═╡ c79e7017-4acc-4562-817a-50245ce654dc
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	v = rand(m)
	benchmark1 = @benchmark f_vjp($v, $x; M=$M, y=$y)
	benchmark2 = @benchmark f_vjp_naive($v, $x; M=$M, y=$y)
	benchmark1, benchmark2
end

# ╔═╡ d0ae8c14-b341-4220-8a1c-79fed9758f64
md"""
---
"""

# ╔═╡ 268ac292-c12f-4ce1-85b1-699c9f1c74f0
md"""
# 4. Forward and reverse mode
"""

# ╔═╡ f1170858-9464-4cc1-9772-fe2b49ff7893
md"""
## Theory
"""

# ╔═╡ f843b77d-8160-4d87-8641-eeb04549af8f
md"""
Let us now consider a composite function $f = f^3 \circ f^2 \circ f^1$ with $3$ layers.
The _chain rule_ yields the following differential:

$$df_x = df^3_{(f^2 \circ f^1) (x)} \circ df^2_{f^1(x)} \circ df^1_x$$

In the Euclidean case, we can re-interpret this function composition as a matrix product:

$$\underbrace{Jf_{x}}_J = \underbrace{Jf^3_{(f^2 \circ f^1) (x)}}_{J^3} \underbrace{Jf^2_{f^1(x)}}_{J^2} \underbrace{Jf^1_{x\phantom{)}}}_{J^1}$$
"""

# ╔═╡ 9b34a8f9-6afa-4712-bde8-a94f4d5e7a33
md"""
But again, storing and multiplying full Jacobian matrices is expensive in high dimension.
Assuming we know how to manipulate the $J^k$ lazily, can we do the same for $J$?
In other words, can we deduce JVPs / VJPs for $f$ based on JVPs / VJPs for the $f^k$?

The answer is yes, but only if we do it in the right direction:

- For a JVP, we can accumulate the product from first to last layer (in _forward mode_):

$$J u = J^3 J^2 J^1 u \quad \implies \quad \begin{cases} u^1 = J^1 u \\ u^2 = J^2 u^1 \\ u^3 = J^3 u^2 \end{cases}$$

- For a VJP, we can accumulate the product from last to first layer (in _reverse mode_)

$$v^\top J = v^\top J^3 J^2 J^1 \quad \implies \quad \begin{cases} v^3 = v^\top J^3 \\ v^2 = (v^3)^\top J^2 \\ v^1 = (v^2)^\top J^1 \end{cases}$$

These considerations generalize to more complex computational graphs, such as the ones drawn in class.
"""

# ╔═╡ 7f4610e7-35f5-4287-b5eb-c8b347b04337
md"""
!!! danger "Task"
	Which autodiff mode should you choose if you want to compute the gradient of a real-valued function: forward or reverse?
"""

# ╔═╡ a8c24bdc-7d8b-43c3-92a3-93614e3bf3c5
md"""
For a real-valued function, the gradient is the transpose of the Jacobian, which has a single row.
It can be computed with a single VJP, as opposed to $n$ JVPs.
Therefore, reverse mode is more adequate.
"""

# ╔═╡ 5aaac098-461d-486b-913a-244696e84557
md"""
---
"""

# ╔═╡ d83aa26e-ec82-4951-b31c-f5dfbb57c140
md"""
Utilities that compose JVPs / VJPs using the chain rule are the second ingredient of autodiff.
In Julia, this is taken care of by various _autodiff backends_, such as `Zygote.jl` or `Enzyme.jl`.
While some are more widely used than others, there is no overall best choice.
A comprehensive list of options is available on the [JuliaDiff](https://juliadiff.org/) website.
From now on, we will use `Zygote.jl`, which is a reverse mode backend.
"""

# ╔═╡ 36766a3d-0602-4919-91ca-53fdb158da1d
md"""
## Example
"""

# ╔═╡ 00351a96-e83e-4f5c-bff9-8fcff24cbaa0
md"""
!!! warning "TODO"
	Compose $f$ with a sum
"""

# ╔═╡ 0ecc5901-cfa0-4add-aea5-a39cd7341d2b
md"""
# 5. `ChainRules.jl`
"""

# ╔═╡ 098c0148-5130-490c-a25b-3d0dfa0b20b9
md"""
## Theory
"""

# ╔═╡ 8752f8f9-55f5-42bb-b3da-45e4a2d41779
md"""
The `ChainRules.jl` package is an attempt to provide unified JVP / VJP rules (also called "pushforwards" and "pullbacks") to many different autodiff backends.
It contains rules for most of the Julia standard library, but also allows users to define custom rules.
We strongly encourage you to read the [first page of the `ChainRules.jl` documentation](https://juliadiff.org/ChainRulesCore.jl/stable/) before going further.
"""

# ╔═╡ ac45151f-f1e2-4db3-bac8-5a9d843f4c17
md"""
Custom rules are very useful because autodiff backends are not all-powerful.
Many of them impose limitations on the language constructs they accept.
For instance, functions that mutate one of their arguments (typically indicated with a `!`) will give rise to errors with most reverse mode backends.
Another example is functions that call other programming languages behind the scenes (like C++ or Python).
"""

# ╔═╡ 96bcf799-67c2-41c5-8634-b8c4e861bfca
md"""
## Example
"""

# ╔═╡ b3fd3a8b-22fd-40a0-9af3-0c66a7ec05a3
md"""
Suppose we implement our linear regression function $f$ by pre-allocating the output vector.
This is a common pattern in Julia because it improves performance.
"""

# ╔═╡ ea16d4c6-d6e4-46fa-a721-fa5a0f2ff021
function f!(e, x; M, y)
	mul!(e, M, x)  # in-place matrix multiplication: now e = Mx
	e .-= y  # now e = Mx - y
	e .^= 2  # now e = (Mx - y) .^ 2
	return e
end

# ╔═╡ a748644e-6e42-403f-8636-f0b75ea67b10
md"""
We can check that we obtain the same results.
"""

# ╔═╡ 1c74a79d-7780-431e-8c33-cbd7f12a1cc4
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	e = rand(m)
	err1 = f!(e, x; M=M, y=y)
	err2 = f(x; M=M, y=y)
	err1, err2
end

# ╔═╡ a47f12aa-5baa-440a-b977-ae5138f3fb50
md"""
And as we can see, this version is a bit faster than the one you coded, mostly because of better memory management.
"""

# ╔═╡ 53c4fb54-ab79-4924-9d65-fc5e5b5b50a1
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	e = rand(m)
	benchmark1 = @benchmark f!($e, $x; M=$M, y=$y)
	benchmark2 = @benchmark f($x; M=$M, y=$y)
	benchmark1, benchmark2
end

# ╔═╡ 80fb6b17-69f1-40fc-96d4-fa3f0a05f349
md"""
But it also makes our reverse mode autodiff backend (`Zygote.jl`) very angry.
"""

# ╔═╡ a80b3a0f-53d1-473e-9bea-2494a85ac511
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	e = rand(m)
	Zygote.jacobian(x -> f!(e, x; M=M, y=y), x)[1]
end

# ╔═╡ bcda87d0-1c35-4c47-bd4b-c0a96bc8a18d
md"""
Fortunately, we have done all the grunt work and can easily define a custom reverse rule to overcome this issue.
This involves implementing a new method of `ChainRulesCore.rrule`, which must return two things:

- the output $f(x)$ of the initial function
- a `pullback` function that turns $v$ into the VJP $v^\top Jf_x$ 

To improve clarity, we do this on a copy of our mutating $f$.
"""

# ╔═╡ 1ec1e8a8-4bb3-4aab-9abf-8e754c2eb88f
function f_diff!(e, x; M, y)
	mul!(e, M, x)
	e .-= y
	e .^= 2
	return e
end

# ╔═╡ e6df285d-b8d9-434a-ba83-02fc5e3d83bb
function ChainRulesCore.rrule(fun::typeof(f_diff!), e, x; M, y)
	output = f!(e, x; M=M, y=y)
	function pullback(v)
		@info "Calling custom pullback" v
		vjp_fun = NoTangent()
		vjp_e = ZeroTangent()
		vjp_x = f_vjp(v, x; M=M, y=y)
		return (vjp_fun, vjp_e, vjp_x)
	end
	return output, pullback
end

# ╔═╡ e8b97c6f-9228-4fa4-99aa-9c81fb582693
md"""
Here are a few explanations regarding the syntax.

What does `fun::typeof(f_diff!)` mean?
It tells `ChainRulesCore.jl` that the reverse rule we define applies to one specific function.
In Julia, each function has its own unique type, which allows us to dispatch on it.

Why does `pullback` return a $3$-tuple `(vjp_fun, vjp_e, vjp_x)`?
Because `ChainRulesCore.jl` wants us to define a VJP for every positional argument of the function `fun`... and also for the function `fun` itself.
Indeed, the function may have internal parameters that we want to take into account when differentiating.
It is not the case here, so we specify that there is no tangent (VJP) with respect to `fun` by returning a dummy `NoTangent()` struct.
Similarly, we return a `ZeroTangent()` for `e`, since it is completely overwritten by our function: its initial value does not affect the final result.
On the other hand, the VJP with respect to `x` does exist, so we return an nontrivial value for this one.
"""

# ╔═╡ 98a59f9c-af6c-460a-bf70-f4e28da1aa80
let
	n, m = 3, 5
	M = rand(m, n)
	y = rand(m)
	x = rand(n)
	e = rand(m)
	jac0 = Jf(x; M=M, y=y)
	jac1 = Zygote.jacobian(x -> f(x; M=M, y=y), x)[1]
	jac2 = Zygote.jacobian(x -> f_diff!(e, x; M=M, y=y), x)[1]
	jac0, jac1, jac2
end

# ╔═╡ 448995fc-25b0-4879-910e-6406f359d577
md"""
!!! danger "Task"
	How many times is the pullback called? Is it expected?
"""

# ╔═╡ 4eda48ec-fe88-41dc-88b7-b1ad547d698f
md"""
Once for each output dimension, that is, for each row of the Jacobian.
"""

# ╔═╡ 15b3aa76-1ef0-4089-a189-ce11573f5812
md"""
---
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
BenchmarkTools = "~1.3.1"
ChainRulesCore = "~1.15.5"
PlutoTeachingTools = "~0.2.3"
PlutoUI = "~0.7.40"
Zygote = "~0.6.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "97091e40190d297d9d10936dec1c1e4e415d9039"

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
# ╟─1cfba628-aa7b-4851-89f1-84b1a45802b3
# ╟─3829f016-a7cd-4ce6-b2d4-1c84da8fdb97
# ╟─755ff203-43d8-488f-a075-14a858b0a096
# ╟─a7d2e710-cf08-4c77-9042-78ee73b6f698
# ╟─d50a296b-bbfc-4d88-b8db-582f6176609d
# ╟─4d9d2f52-c406-4a7c-8b0e-ba5af7ebc3d8
# ╟─de4df88a-2a55-4a02-aeaf-f02242b6c52f
# ╟─e22cec4a-03d3-4821-945b-9283e16207a8
# ╟─f51920d4-652b-467c-8f02-fcd1a0f92c2e
# ╟─e19f2824-e7a0-4ee0-b37d-350342d3cbdd
# ╟─82fd26e3-b429-480d-be04-f0ac363c4a31
# ╟─25b572fa-1f9a-43f9-98a3-181d8dd6e21a
# ╟─b5241dc4-32c1-4e91-b401-c25f4b7cb3cd
# ╟─d76d5ddc-fe59-47f4-8b56-6f704b486ebc
# ╟─ae7b2114-de91-4f1b-8765-af5e02cc1b63
# ╟─e4aedbd4-a609-4eaf-812b-d2f3d6f4df3d
# ╟─b8974b20-d8dc-4109-a64e-585c7afdb484
# ╟─f4994938-9270-4058-9c95-01591c87d9c7
# ╟─f472111d-d7e8-42db-9a08-6a8dd67af09b
# ╟─bd10d753-eea6-4798-939c-8e5551d40c5c
# ╟─2f95afd6-1418-44bb-9868-970dbe888500
# ╟─06e91432-935f-4d7c-899f-d7968a10a78e
# ╟─8ff815b0-34a4-4e42-8c18-ff45096ed260
# ╟─28f31ef9-27ea-4e94-8f03-89b0f6cfa0d1
# ╟─ca4b41dd-353e-498d-a461-648c582cb999
# ╠═883803e0-2fa1-4922-be37-f325af4f5c41
# ╠═c5fc8f3a-ed90-41ec-b4b9-1172a41e3adc
# ╠═40e13883-dd9a-43b9-9ef7-1069ef036846
# ╟─4440f39c-51e5-4ffd-8031-96d4a760270c
# ╟─69a9ec45-d2ff-4362-9c3c-5c004e46ceb3
# ╟─7c172e2d-5672-405e-8960-f104607a3610
# ╟─8923a5ad-ddba-4ae2-886e-84526a3521ba
# ╟─e1b9f114-58e7-4546-a3c0-5e07fb1665e7
# ╟─ba07ccda-ae66-4fce-837e-00b2b039b404
# ╟─663e3899-e7b3-4420-8d66-7e88c1b79185
# ╟─5ae3bf90-6393-45b9-840e-feeb2e727508
# ╟─37cab21f-aa70-48c2-be62-55e285481525
# ╟─f66a0ea7-70fd-4340-8b02-6fbaab847dfc
# ╟─8cca11ed-a61c-4cc8-af4b-350137073756
# ╟─7144c6c8-79dd-437d-a201-bac143f6a261
# ╟─07cd4e47-5fac-49c4-80a5-c5bdf21bd484
# ╟─45765f4a-536d-4e9d-be9d-144b7ccd4dcf
# ╟─df89f509-cfd7-46b3-9dd1-cdcfcea68053
# ╠═37dbaa56-7b8f-4c2a-ad8c-6c3ba6060cfa
# ╠═0b51e23e-a015-4e86-ba48-6475a9ee9779
# ╟─79880fd1-0fc1-4f14-9d1f-664afcc939c8
# ╟─14dcad57-23ae-4905-aac4-d29066f2a085
# ╠═0ea654fe-d3d0-4f40-b3dc-806b1982c040
# ╠═06a59777-b6ec-4808-9105-7a2542a629ea
# ╠═90c6515b-b0c0-4f9b-bd4e-ae29c0ecab23
# ╠═9222d644-5d20-474a-83db-4b2e3bed45e2
# ╟─c511e1c4-0306-46c7-800f-8257266c0091
# ╟─ba206cb6-d2ca-4a4a-9c20-d66b015226dd
# ╠═0cc728dd-40d2-4713-b378-e67b3ed1c44f
# ╠═c79e7017-4acc-4562-817a-50245ce654dc
# ╟─d0ae8c14-b341-4220-8a1c-79fed9758f64
# ╟─268ac292-c12f-4ce1-85b1-699c9f1c74f0
# ╟─f1170858-9464-4cc1-9772-fe2b49ff7893
# ╟─f843b77d-8160-4d87-8641-eeb04549af8f
# ╟─9b34a8f9-6afa-4712-bde8-a94f4d5e7a33
# ╟─7f4610e7-35f5-4287-b5eb-c8b347b04337
# ╟─a8c24bdc-7d8b-43c3-92a3-93614e3bf3c5
# ╟─5aaac098-461d-486b-913a-244696e84557
# ╟─d83aa26e-ec82-4951-b31c-f5dfbb57c140
# ╟─36766a3d-0602-4919-91ca-53fdb158da1d
# ╟─00351a96-e83e-4f5c-bff9-8fcff24cbaa0
# ╟─0ecc5901-cfa0-4add-aea5-a39cd7341d2b
# ╟─098c0148-5130-490c-a25b-3d0dfa0b20b9
# ╟─8752f8f9-55f5-42bb-b3da-45e4a2d41779
# ╟─ac45151f-f1e2-4db3-bac8-5a9d843f4c17
# ╟─96bcf799-67c2-41c5-8634-b8c4e861bfca
# ╟─b3fd3a8b-22fd-40a0-9af3-0c66a7ec05a3
# ╠═ea16d4c6-d6e4-46fa-a721-fa5a0f2ff021
# ╟─a748644e-6e42-403f-8636-f0b75ea67b10
# ╠═1c74a79d-7780-431e-8c33-cbd7f12a1cc4
# ╟─a47f12aa-5baa-440a-b977-ae5138f3fb50
# ╠═53c4fb54-ab79-4924-9d65-fc5e5b5b50a1
# ╟─80fb6b17-69f1-40fc-96d4-fa3f0a05f349
# ╠═a80b3a0f-53d1-473e-9bea-2494a85ac511
# ╟─bcda87d0-1c35-4c47-bd4b-c0a96bc8a18d
# ╠═1ec1e8a8-4bb3-4aab-9abf-8e754c2eb88f
# ╠═e6df285d-b8d9-434a-ba83-02fc5e3d83bb
# ╟─e8b97c6f-9228-4fa4-99aa-9c81fb582693
# ╠═98a59f9c-af6c-460a-bf70-f4e28da1aa80
# ╟─448995fc-25b0-4879-910e-6406f359d577
# ╟─4eda48ec-fe88-41dc-88b7-b1ad547d698f
# ╟─15b3aa76-1ef0-4089-a189-ce11573f5812
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
