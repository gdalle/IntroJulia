### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 202b23a5-0e7c-4bfc-99c4-e5efd8e6343a
using PlutoUI

# ╔═╡ f4936cc0-aef0-48e7-94ca-2fa9421a4fcb
using Markdown: MD, Admonition, Code

# ╔═╡ 5a855d3b-06cc-4df5-bedf-e4129c79d307
using Plots

# ╔═╡ fa8022a0-b4b1-4157-b761-b90c8aa31274
md"""
> 🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 857b194c-2397-4ad7-95a9-38ec35815995
TableOfContents()

# ╔═╡ d1824521-94e0-4d76-b561-77ffe8aabdf8
begin
	hint(text) = MD(Admonition("hint", "Hint", [text]))
	not_defined(var) = MD(Admonition("info", "Not defined", [md"Make sure you defined **$(Code(string(var)))**"]))
	keep_working(text=md"You're not there yet.") = MD(Admonition("danger", "Keep working!", [text]))
	correct(text=md"Good job.") = MD(Admonition("tip", "Correct!", [text]))
end;

# ╔═╡ 9f45b9f5-21a8-421b-873d-ffcaeaf293d9
md"""
# Using Pluto notebooks

This document you see is a notebook created with [Pluto.jl](https://github.com/fonsp/Pluto.jl). Is is a mixture of Julia code and web components designed to make the programming experience more fun and interactive.
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
- By default, the output of a cell is the value of its last expression, you can hide it by ending the cell with `;`.
- The standard `print` and `println` functions will not work in Pluto notebooks since they will display text in the terminal from which you launched the notebook. Two possible workarounds: wrap your cell in a `with_terminal() do ... end` block or use the `PlutoUI: Print` function.
- Usually, packages have to be installed (with `Pkg.add("MyPackage")`) before they can be used. However, Pluto takes care of that for us, so when you need a package, just write `using MyPackage` in a cell and it will be downloaded and installed in a local environment specific to the current notebook.
"""

# ╔═╡ 2f3f1509-409a-4416-a86a-24686b164bb6
md"""
## Help and documentation

Pluto offers you a `Live Docs` tab on the bottom right corner of the screen. If you expand it and click a function or variable, you will be able to explore the documentation associated with it. The same goes if you type `?` before a command in the REPL.
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

Here we give you some useful tools for the rest of the course, but we cannot describe every part of Julia. To look up a command without diving deep into the documentation, a very good resource is the [Fast Track to Julia](https://juliadocs.github.io/Julia-Cheat-Sheet/).

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
In the cell below, define a variable named $\epsilon$ and equal to $0.001$.
"""

# ╔═╡ 097c8536-0cd6-402f-801d-9a4adb3ad278


# ╔═╡ d4ab7a0a-3069-4d9a-841c-00a4e995b9a7
if !@isdefined ϵ
	not_defined(:ϵ)
elseif !(ϵ ≈ 0.001)
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
mystring(3.)

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

# ╔═╡ 63b373bd-2ddf-4c2b-9294-5165abee2e67


# ╔═╡ 385169fa-c03e-4dce-b4b7-7452be6a5f49
hint(md"Search the docs for `+`, `methods` and `length`.")

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

# ╔═╡ 62615d93-143d-4ec6-9a1e-991e3e0d9401
md"""
## Arrays

The type of an array has the form `Array{T, d}`, where `T` is the type of the elements and `d` the number of dimensions (or axes). For $d=1$ and $d=2$ we have shortcuts:
"""

# ╔═╡ 7eac7c25-ccd1-412e-971a-d55fdff3abf5
typeof([1, 2, 3])

# ╔═╡ b66dfcc9-147e-48ff-9a31-45e59b9eaa23
typeof([1. 2.; 3. 4.])

# ╔═╡ 4cc75d1e-132f-4530-8809-b56883bbc157
md"""
Note that arrays can store arbitrary content, including variables with different types, but this will make your code very inefficient. In the cell below, try to guess the type of the array `[1, "1"]` without creating it, and store your guess into `type_of_array`.
"""

# ╔═╡ 2d4cf48a-ab3d-4049-a2d8-6006602d0c6d


# ╔═╡ 8941fec5-dc88-4715-8392-8813e6d63c6b
hint(md"""Use the function `supertypes` on the types of `1` and `"1"` to look for the lowest common supertype.""")

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
To apply a function to all elements of an array, simply add a dot after its name. For instance, in the cell below, compute the exponential of `[0, 1]` without using a loop and store it into `exp_01`.
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
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.19.4"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random", "StaticArrays"]
git-tree-sha1 = "ed268efe58512df8c7e224d2e170afd76dd6a417"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.13.0"

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

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "344f143fa0ec67e47917848795ab19c6a455f32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.32.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "9f473cdf6e2eb360c576f9822e7c765dd9d26dbc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.0"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "eaf96e05a880f3db5ded5a5a8a7817ecba3c7392"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

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

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "6a8a2a625ab0dea913aba95c11370589e0239ff0"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.6"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "4ea90bd5d3985ae1f9a908bd4500ae88921c5ce7"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "501c20a63a34ac1d015d5304da0e645f42d91c9f"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.11"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "1e72752052a3893d0f7103fbac728b60b934f5a5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.19.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "b3fb709f3c97bfc6e948be68beeecb55a0b340ae"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "2a7a2469ed5d94a98dea0e85c46fa653d76be0cd"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.4"

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

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "885838778bb6f0136f8317757d7803e0d81201e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.9"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "fed1ec1e65749c4d96fc20dd13bea72b55457e62"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.9"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "000e168f5cc9aded17b6999a560b7c11dda69095"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.0"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─fa8022a0-b4b1-4157-b761-b90c8aa31274
# ╠═202b23a5-0e7c-4bfc-99c4-e5efd8e6343a
# ╠═857b194c-2397-4ad7-95a9-38ec35815995
# ╟─f4936cc0-aef0-48e7-94ca-2fa9421a4fcb
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
# ╠═63b373bd-2ddf-4c2b-9294-5165abee2e67
# ╟─385169fa-c03e-4dce-b4b7-7452be6a5f49
# ╟─be6daa5b-27c1-4ffc-9683-f71560255da4
# ╟─b242483f-9331-4f76-a030-b100b2bddea3
# ╠═4af026ba-238c-4627-aaed-8e4c45a0a0d0
# ╠═b969b6d5-a877-43ef-a750-e58ac3707331
# ╟─62615d93-143d-4ec6-9a1e-991e3e0d9401
# ╠═7eac7c25-ccd1-412e-971a-d55fdff3abf5
# ╠═b66dfcc9-147e-48ff-9a31-45e59b9eaa23
# ╟─4cc75d1e-132f-4530-8809-b56883bbc157
# ╠═2d4cf48a-ab3d-4049-a2d8-6006602d0c6d
# ╟─8941fec5-dc88-4715-8392-8813e6d63c6b
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
# ╟─8944faa2-4e27-4840-a738-5410865d82c3
# ╟─e567975a-c0be-49ba-9c12-e23aba99de09
# ╠═b0172361-e107-4419-94d1-dba9bd58ecc5
# ╟─35f19df1-ca46-4f0c-9011-aed919798de7
# ╠═5fc8dcc5-0df3-4253-a79c-4325f0e78bf8
# ╟─17a63246-4ec3-425d-a81b-720b1e92e764
# ╠═c504521c-5938-4549-a718-d06575abdad9
# ╟─add7330e-4bb7-471e-8422-14d4eea94c16
# ╠═7c1c3005-e195-4018-b689-fbe0c535afd7
# ╟─d05fbbc4-d55f-4a7c-9975-8f2e5918dd30
# ╠═066134fb-67e9-49ce-91a5-5faec0366e4f
# ╟─d8dfb915-48a5-43bc-ba24-155f856111df
# ╠═1c17177a-330d-4277-ac17-b2c1bcdf6a2f
# ╟─876a902d-29ef-4b82-8101-851ae87aac22
# ╟─f3e299eb-704b-456d-b00a-bbc0dca6589a
# ╟─536f5bcb-3f1e-4427-b8e3-715710dd410b
# ╠═5a855d3b-06cc-4df5-bedf-e4129c79d307
# ╠═ca0f6333-a0fa-4fe4-8769-2825991b679d
# ╟─243c6579-6039-413f-b8bb-ec2c21567187
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
