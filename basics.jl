### A Pluto.jl notebook ###
# v0.18.2

using Markdown
using InteractiveUtils

# ╔═╡ 202b23a5-0e7c-4bfc-99c4-e5efd8e6343a
using PlutoUI, Markdown, Plots

# ╔═╡ fa8022a0-b4b1-4157-b761-b90c8aa31274
md"""
> 🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 857b194c-2397-4ad7-95a9-38ec35815995
TableOfContents()

# ╔═╡ d1824521-94e0-4d76-b561-77ffe8aabdf8
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	not_defined(var) = Markdown.MD(Markdown.Admonition(
		"info", "Not defined", [
			md"Have you defined **$(Markdown.Code(string(var)))**?"
		]
	))
	keep_working(text=md"You're almost there") = Markdown.MD(Markdown.Admonition(
		"danger", "Keep working!", [text]
	))
	correct(text=md"Well done.") = Markdown.MD(Markdown.Admonition(
		"tip", "Correct!", [text]
	))
end;

# ╔═╡ 9f45b9f5-21a8-421b-873d-ffcaeaf293d9
md"""
# Using Pluto notebooks

This document you see is a notebook created with [Pluto.jl](https://github.com/fonsp/Pluto.jl).
It is a mixture of Julia code and web components, designed to make the programming experience more fun and interactive.
"""

# ╔═╡ 8dbbb4f8-4948-4349-a87d-c579bd014507
md"""
## Cells and evaluation

In this notebook, you have access to a structured equivalent of Julia's REPL (Read-Eval-Print Loop), i.e. the interactive console. Here, you can divide your code in cells to modify and run each one separately.
"""

# ╔═╡ 7e401ec1-1e5c-41c5-89a2-1198879899ff
1+1

# ╔═╡ 3635885d-51cf-49cf-8767-70984ee3248c
md"""
Press `Ctrl + Shift + ?` (or `Cmd + Shift + ?` on a Mac) to open the list of keyboard shortcuts.
"""

# ╔═╡ ee2855cf-6d24-4634-aa49-3da3829fa1b4
md"""
## Some quirks of Pluto

The behaviors described below are specific to Pluto notebooks and do not apply to Julia as a whole:
-  To put several lines in a Pluto cell, you must wrap them in a `begin ... end` block.
- You cannot redefine a variable with the same name twice in the same notebook.
- If you want interactivity to work, avoid modifying variables in another cell that the one containing their definition.
- By default, the output of a cell is the value of its last expression, you can hide it by ending the cell with `;`.
- Usually, packages have to be installed (with `import Pkg; Pkg.add("MyPackage")`) before they can be used. However, Pluto takes care of that for us, so when you need a package, just write `using MyPackage` in a cell. This package will then be downloaded and installed in a local environment specific to the current notebook.
"""

# ╔═╡ 2f3f1509-409a-4416-a86a-24686b164bb6
md"""
## Help and documentation

Pluto offers you a `Live Docs` tab on the bottom right corner of the screen. If you expand it and click a function or variable, you will be able to explore the documentation associated with it. The same goes if you type `?` before a command in the REPL.

For details on Pluto itself, check out the [FAQ](https://github.com/fonsp/Pluto.jl/wiki).
"""

# ╔═╡ 89e4cb15-e8e8-49be-9fd4-860e2753e262
md"""
## Interactivity

The ability to interact is one of the key features of Pluto. Here is a quick example.
"""

# ╔═╡ cd1354d6-5e30-4acc-aba2-1e0bc611f44f
var1, var2 = 6, 7

# ╔═╡ 296e5f0d-f7d6-4a63-b836-43f7f8a5cb95
md"""
In the cell below, define a variable `var3` equal to the product of `var1` and `var2`.
"""

# ╔═╡ 21de7124-d8a8-46d7-8180-8167962d3cf5


# ╔═╡ 13dce566-aaf0-48bf-8ab8-509b577209e4
if !@isdefined var3
	not_defined(:var3)
elseif var3 != var1 * var2
	keep_working(md"`var3` is not equal to the product of `var1` and `var2`.")
else
	correct(md"You've made it: $var3 = $var1 x $var2.")
end

# ╔═╡ be4b0a90-7175-4b8c-a0f6-540edc97f332
md"""
As you can see, the feedback has changed! Now check what happens when you play with the value of `var1`: which parts of the notebook are modified?

This happens because Pluto tracks the consequences of every cell: as soon as you change one cell, all the other cells that depend on it are re-run. If you have computation-intensive cells that you don't want to re-run every time, just `Disable` them using the button with the three dots on the right.
"""

# ╔═╡ 437bd878-066a-4159-9936-746f9111e62d
md"""
# Julia essentials

Here we give you some useful tools for the rest of the course, but we cannot describe every part of Julia. To look up a piece of syntax without diving deep into the documentation, a very good resource is the [Fast Track to Julia](https://juliadocs.github.io/Julia-Cheat-Sheet/).

A word of warning before we start!

> In Julia, when you run a chunk of code for the first time, it takes longer due to *just-in-time compilation*. Don't be surprised, it is essential for performance, and the following runs are much faster.
"""

# ╔═╡ 511d7889-b6a5-433a-bf67-efc705a36f2d
md"""
## Variables

Variable assignment works as one would expect. Note that you can use LaTeX symbols by typing (for instance) `\beta` + `Tab` in the REPL. This also works for indices or exponents when typing `u\_1` + `Tab`.
"""

# ╔═╡ 53e41b8d-3495-4017-8f15-c6aa2d36a4db
md"""
In the cell below, define a variable named `α` and equal to $0.001$.
"""

# ╔═╡ 097c8536-0cd6-402f-801d-9a4adb3ad278


# ╔═╡ d4ab7a0a-3069-4d9a-841c-00a4e995b9a7
if !@isdefined α
	not_defined(:α)
elseif !(α ≈ 0.001)
	keep_working()
else
	correct()
end

# ╔═╡ 9650902e-5e33-4f8e-a1d6-f32de582f743
md"""
In Julia, each variable has a type. Julia's typing system is dynamic, which means variables can change types, but performance can be increased by avoiding such changes and helping the compiler infer the types before runtime. More on this in the next notebook.
"""

# ╔═╡ ddae35e4-4289-42a3-9e44-b5e09e72d768
begin
	a1, a2, a3, a4 = 1, 1.0, '1', "1"
	typeof(a1), typeof(a2), typeof(a3), typeof(a4)
end

# ╔═╡ 856b3cb5-e81c-4732-abba-d11739c58c8d
md"""
The manual page on [types](https://docs.julialang.org/en/v1/manual/types/) is an important read.
"""

# ╔═╡ dd5a7c0e-9a0b-413f-bc43-3072c716b52e
md"""
## Functions

A function is defined with the `function` keyword.
"""

# ╔═╡ 18b0b89d-643c-419c-81b4-27884aea39ce
function mystring(a)
    return "This is $a."
end

# ╔═╡ 7b190dd0-c6f6-4062-8f7b-444b19a3fa5f
md"""
Right now, this function only has one "method", i.e. one implementation. If we want, we can define other methods by changing the arguments or specifying their types to obtain a custom behavior on an interesting subset of inputs.
"""

# ╔═╡ 9b71d9d4-5299-4567-a95f-e673ba436f56
mystring(a::Integer) = "This is the integer $a."

# ╔═╡ 63608c6a-121e-46e2-837e-6806e064986f
md"""
This is linked to a key feature of Julia called multiple dispatch: the program will decide which method to apply depending on the type of all the arguments.
"""

# ╔═╡ 5a42d51d-7d0d-44fe-9fbf-9623edb3be07
mystring("3")

# ╔═╡ 45693c3c-0d65-44c4-b87f-c8d6cc0684e3
mystring(3)

# ╔═╡ 3bb9e2d2-8bd4-4dc5-b354-01c5e215bb90
md"""
In the cell below, define a third method of `mystring` for real numbers.
"""

# ╔═╡ 2f175b45-db50-4b8f-8e92-519971921551


# ╔═╡ 05fc5ad7-90ef-43b7-bb8e-d8e34f4101c0
if mystring(3.) != "This is the real number 3."
	keep_working(md"""`mystring(3.)` must return "This is the real number 3." """)
else
	correct()
end

# ╔═╡ 0f4564c4-6273-4613-b858-80360e85aeab
md"""
Basic functions have lots of different implementations for each input type! As an example, try to compute the number of methods for addition in Julia and store the result in a variable named `nb_methods_addition`.
"""

# ╔═╡ 385169fa-c03e-4dce-b4b7-7452be6a5f49
hint(md"Search the docs for `+`, `methods` and `length`.")

# ╔═╡ 63b373bd-2ddf-4c2b-9294-5165abee2e67


# ╔═╡ be6daa5b-27c1-4ffc-9683-f71560255da4
if !@isdefined nb_methods_addition
	not_defined(:nb_methods_addition)
elseif nb_methods_addition != length(methods(+))
	keep_working()
else
	correct()
end

# ╔═╡ b242483f-9331-4f76-a030-b100b2bddea3
md"""
As in Python, you can add keyword arguments (separated by a semicolon `;`), and arguments can have default values.
"""

# ╔═╡ 4af026ba-238c-4627-aaed-8e4c45a0a0d0
function introduction(name, age=25; country, passion="maths")
	return "Hi, I'm $name, I'm $age, I come from $country and I like $passion."
end

# ╔═╡ b969b6d5-a877-43ef-a750-e58ac3707331
introduction("Guillaume", country="France")

# ╔═╡ e7e5d1c4-8552-4442-abbe-041dababae2c
md"""
Read the manual pages on [functions](https://docs.julialang.org/en/v1/manual/functions/#man-functions) and [methods](https://docs.julialang.org/en/v1/manual/methods/) to know more.
"""

# ╔═╡ 62615d93-143d-4ec6-9a1e-991e3e0d9401
md"""
## Arrays

The type of an array has the form `Array{T,D}`, where `T` is the type of the elements and `D` the number of dimensions (or axes). For $D=1$ and $D=2$ we have shortcuts:
"""

# ╔═╡ 7eac7c25-ccd1-412e-971a-d55fdff3abf5
typeof([1, 2, 3])

# ╔═╡ b66dfcc9-147e-48ff-9a31-45e59b9eaa23
typeof([1. 2.; 3. 4.])

# ╔═╡ 4cc75d1e-132f-4530-8809-b56883bbc157
md"""
Note that arrays can store arbitrary content, including variables with different types, but this will make your code very inefficient. In the cell below, try to guess the type of the array `[1, "1"]` without creating it, and store your guess into `type_of_array`.
"""

# ╔═╡ 8941fec5-dc88-4715-8392-8813e6d63c6b
hint(md"""Use the function `supertypes` on the types of `1` and `"1"` to look for the lowest common supertype.""")

# ╔═╡ 2d4cf48a-ab3d-4049-a2d8-6006602d0c6d


# ╔═╡ bae28a24-06e6-4181-8e90-abe86fc1f26e
if !@isdefined type_of_array
	not_defined(:type_of_array)
elseif type_of_array != Vector{Any}
	keep_working()
else
	correct()
end

# ╔═╡ ae5f5814-a36f-438a-bd01-5fc12470e650
md"""
You can create an array in advance using its type and the keyword `undef`. Until you fill them, its elements will contain whatever was there in memory before, so don't trust their values!
"""

# ╔═╡ c9599e1d-4e28-463a-be9a-bf1537569c26
vector_no_init = Vector{Int}(undef, 5)

# ╔═╡ 46781dca-5fde-49b5-86b3-5e33a070d7ae
md"""
You can also create arrays filled with the value of your choice using `zeros`, `ones` or `fill`.
"""

# ╔═╡ 52328943-c1fa-42c5-8eef-5f429495fde8
matrix_of_zeros = zeros(Float64, 3, 2)

# ╔═╡ 647e5323-a820-4a9d-abda-e61c6b15dca9
md"""
To apply a function to all elements of an array, simply add a dot after its name. For instance, in the cell below, compute the elementwise exponential of `[0, 1]` without using a loop and store it into `exp_01`.
"""

# ╔═╡ f0de14d5-f97d-49ad-b97f-c9116408144d


# ╔═╡ b077861d-4daf-45a6-ae46-bc0c4cf82b3b
if !@isdefined exp_01
	not_defined(:exp_01)
elseif exp_01 != exp.([0, 1])
	keep_working()
else
	correct()
end

# ╔═╡ 4ac48d76-0d64-4990-ae38-22343b83653f
md"""
The same goes for elementary operators, except the dot must come before.
"""

# ╔═╡ 4796c251-a104-49bb-819f-d018ecbaf5d5
[1, 2, 3] .* 2 .== [1, 2, 3] .^ 2

# ╔═╡ 08d3a430-1b0d-4026-9bf9-6620f46e2998
md"""
Read the manual page on [arrays](https://docs.julialang.org/en/v1/manual/arrays/) if you need more information.
"""

# ╔═╡ 8944faa2-4e27-4840-a738-5410865d82c3
md"""
## Conditions and loops
"""

# ╔═╡ e567975a-c0be-49ba-9c12-e23aba99de09
md"""
Here is an example of `if - else` block.
"""

# ╔═╡ b0172361-e107-4419-94d1-dba9bd58ecc5
function collatz(n::Integer)
    if n % 2 == 0
        return n ÷ 2
    else
        return 3n+1
    end
end

# ╔═╡ 35f19df1-ca46-4f0c-9011-aed919798de7
md"""
Here is an example of `for` loop.
"""

# ╔═╡ 5fc8dcc5-0df3-4253-a79c-4325f0e78bf8
function collatzseq(x::Integer, n::Integer)
	for i in 1:n
		x = collatz(x)
	end
	return x
end

# ╔═╡ 17a63246-4ec3-425d-a81b-720b1e92e764
md"""
Loops also allow us to define arrays by comprehension.
"""

# ╔═╡ c504521c-5938-4549-a718-d06575abdad9
[collatzseq(5, i+j) for i in 1:3, j = 1:5]

# ╔═╡ add7330e-4bb7-471e-8422-14d4eea94c16
md"""
Finally, here's an example of `while` loop. Does it always terminate?
"""

# ╔═╡ 7c1c3005-e195-4018-b689-fbe0c535afd7
function collatzlength(x::Integer)
	n = 0
	while x > 1
		x = collatz(x)
		n += 1
	end
	return n
end

# ╔═╡ b9e84c1e-61d5-4a41-8584-308f24442a82
md"""
Read the manual page on [control flow](https://docs.julialang.org/en/v1/manual/control-flow/) to discover additional syntax.
"""

# ╔═╡ d05fbbc4-d55f-4a7c-9975-8f2e5918dd30
md"""
## Structures

Julia's notion of object is nothing more than a tuple with named components. We can define one like this:
"""

# ╔═╡ 066134fb-67e9-49ce-91a5-5faec0366e4f
struct Point
    x::Float64
    y::Float64
end

# ╔═╡ d8dfb915-48a5-43bc-ba24-155f856111df
md"""
These structures do not "contain" any methods. However, we can write some outside of the `struct` by specifying the type of the argument. In the cell below, write a method called `norm` that computes the Euclidean norm of a `Point`.
"""

# ╔═╡ 1c17177a-330d-4277-ac17-b2c1bcdf6a2f


# ╔═╡ 876a902d-29ef-4b82-8101-851ae87aac22
if !@isdefined norm
	not_defined(:norm)
elseif norm(Point(3., 4.)) != 5.
	keep_working()
else
	correct()
end

# ╔═╡ f3e299eb-704b-456d-b00a-bbc0dca6589a
md"""
If you are unsure what to do with a struct, you can list the applicable methods using `methodswith(type)`.
"""

# ╔═╡ 536f5bcb-3f1e-4427-b8e3-715710dd410b
md"""
## Plots

Julia has various utilities for plotting, but the most versatile is [Plots.jl](https://docs.juliaplots.org/latest/). If you are used to Python syntax, you may prefer [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl), although the installation is slightly more involved.
"""

# ╔═╡ ca0f6333-a0fa-4fe4-8769-2825991b679d
plot(1:10, exp.(1:10), xlabel="x", ylabel="exp(x)", label="this grows fast")

# ╔═╡ 243c6579-6039-413f-b8bb-ec2c21567187
md"""
## Miscellaneous

Here are some things you may need to know that didn't fit elsewhere:
- comments start with a `#`
- functions that modify one of their arguments typically end with `!`
- the null object in Julia is `nothing`, of type `Nothing`
- exceptions can be thrown using the simple command `error("this doesn't work")`
- macros start with `@` (you don't need to know what they are, just recognize them)

If you're still surprised by something, check the [Julia FAQ](https://docs.julialang.org/en/v1/manual/faq/).
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.20.1"
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

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c9a6160317d1abe9c44b3beb367fd448117679ca"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.13.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

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

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a6c850d77ad5118ad3be4bd188919ce97fffac47"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.0+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "4f00cc36fede3c04b8acf9b2e2763decfdcecfa6"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.13"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "56ad13e26b7093472eba53b418eba15ad830d6b5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.9"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "60e9def572717de8345d65a1b913df0fd3903621"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "8365fa7758e2e8e4443ce866d6106d8ecbb4474e"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.20.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "1f27772b89958deed68d2709e5f08a5e5f59a5af"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.7"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "74fb527333e72ada2dd9ef77d98e4991fb185f04"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─fa8022a0-b4b1-4157-b761-b90c8aa31274
# ╠═202b23a5-0e7c-4bfc-99c4-e5efd8e6343a
# ╠═857b194c-2397-4ad7-95a9-38ec35815995
# ╟─d1824521-94e0-4d76-b561-77ffe8aabdf8
# ╟─9f45b9f5-21a8-421b-873d-ffcaeaf293d9
# ╟─8dbbb4f8-4948-4349-a87d-c579bd014507
# ╠═7e401ec1-1e5c-41c5-89a2-1198879899ff
# ╟─3635885d-51cf-49cf-8767-70984ee3248c
# ╟─ee2855cf-6d24-4634-aa49-3da3829fa1b4
# ╟─2f3f1509-409a-4416-a86a-24686b164bb6
# ╟─89e4cb15-e8e8-49be-9fd4-860e2753e262
# ╠═cd1354d6-5e30-4acc-aba2-1e0bc611f44f
# ╟─296e5f0d-f7d6-4a63-b836-43f7f8a5cb95
# ╠═21de7124-d8a8-46d7-8180-8167962d3cf5
# ╟─13dce566-aaf0-48bf-8ab8-509b577209e4
# ╟─be4b0a90-7175-4b8c-a0f6-540edc97f332
# ╟─437bd878-066a-4159-9936-746f9111e62d
# ╟─511d7889-b6a5-433a-bf67-efc705a36f2d
# ╟─53e41b8d-3495-4017-8f15-c6aa2d36a4db
# ╠═097c8536-0cd6-402f-801d-9a4adb3ad278
# ╟─d4ab7a0a-3069-4d9a-841c-00a4e995b9a7
# ╟─9650902e-5e33-4f8e-a1d6-f32de582f743
# ╠═ddae35e4-4289-42a3-9e44-b5e09e72d768
# ╟─856b3cb5-e81c-4732-abba-d11739c58c8d
# ╟─dd5a7c0e-9a0b-413f-bc43-3072c716b52e
# ╠═18b0b89d-643c-419c-81b4-27884aea39ce
# ╟─7b190dd0-c6f6-4062-8f7b-444b19a3fa5f
# ╠═9b71d9d4-5299-4567-a95f-e673ba436f56
# ╟─63608c6a-121e-46e2-837e-6806e064986f
# ╠═5a42d51d-7d0d-44fe-9fbf-9623edb3be07
# ╠═45693c3c-0d65-44c4-b87f-c8d6cc0684e3
# ╟─3bb9e2d2-8bd4-4dc5-b354-01c5e215bb90
# ╠═2f175b45-db50-4b8f-8e92-519971921551
# ╟─05fc5ad7-90ef-43b7-bb8e-d8e34f4101c0
# ╟─0f4564c4-6273-4613-b858-80360e85aeab
# ╟─385169fa-c03e-4dce-b4b7-7452be6a5f49
# ╠═63b373bd-2ddf-4c2b-9294-5165abee2e67
# ╟─be6daa5b-27c1-4ffc-9683-f71560255da4
# ╟─b242483f-9331-4f76-a030-b100b2bddea3
# ╠═4af026ba-238c-4627-aaed-8e4c45a0a0d0
# ╠═b969b6d5-a877-43ef-a750-e58ac3707331
# ╟─e7e5d1c4-8552-4442-abbe-041dababae2c
# ╟─62615d93-143d-4ec6-9a1e-991e3e0d9401
# ╠═7eac7c25-ccd1-412e-971a-d55fdff3abf5
# ╠═b66dfcc9-147e-48ff-9a31-45e59b9eaa23
# ╟─4cc75d1e-132f-4530-8809-b56883bbc157
# ╟─8941fec5-dc88-4715-8392-8813e6d63c6b
# ╠═2d4cf48a-ab3d-4049-a2d8-6006602d0c6d
# ╟─bae28a24-06e6-4181-8e90-abe86fc1f26e
# ╟─ae5f5814-a36f-438a-bd01-5fc12470e650
# ╠═c9599e1d-4e28-463a-be9a-bf1537569c26
# ╟─46781dca-5fde-49b5-86b3-5e33a070d7ae
# ╠═52328943-c1fa-42c5-8eef-5f429495fde8
# ╟─647e5323-a820-4a9d-abda-e61c6b15dca9
# ╠═f0de14d5-f97d-49ad-b97f-c9116408144d
# ╟─b077861d-4daf-45a6-ae46-bc0c4cf82b3b
# ╟─4ac48d76-0d64-4990-ae38-22343b83653f
# ╠═4796c251-a104-49bb-819f-d018ecbaf5d5
# ╟─08d3a430-1b0d-4026-9bf9-6620f46e2998
# ╟─8944faa2-4e27-4840-a738-5410865d82c3
# ╟─e567975a-c0be-49ba-9c12-e23aba99de09
# ╠═b0172361-e107-4419-94d1-dba9bd58ecc5
# ╟─35f19df1-ca46-4f0c-9011-aed919798de7
# ╠═5fc8dcc5-0df3-4253-a79c-4325f0e78bf8
# ╟─17a63246-4ec3-425d-a81b-720b1e92e764
# ╠═c504521c-5938-4549-a718-d06575abdad9
# ╟─add7330e-4bb7-471e-8422-14d4eea94c16
# ╠═7c1c3005-e195-4018-b689-fbe0c535afd7
# ╟─b9e84c1e-61d5-4a41-8584-308f24442a82
# ╟─d05fbbc4-d55f-4a7c-9975-8f2e5918dd30
# ╠═066134fb-67e9-49ce-91a5-5faec0366e4f
# ╟─d8dfb915-48a5-43bc-ba24-155f856111df
# ╠═1c17177a-330d-4277-ac17-b2c1bcdf6a2f
# ╟─876a902d-29ef-4b82-8101-851ae87aac22
# ╟─f3e299eb-704b-456d-b00a-bbc0dca6589a
# ╟─536f5bcb-3f1e-4427-b8e3-715710dd410b
# ╠═ca0f6333-a0fa-4fe4-8769-2825991b679d
# ╟─243c6579-6039-413f-b8bb-ec2c21567187
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
