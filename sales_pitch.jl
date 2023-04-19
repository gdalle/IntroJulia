### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> title = "IntroJulia - sales pitch"

using Markdown
using InteractiveUtils

# ╔═╡ 2483e29e-50cf-4158-ac7b-7f3c4505b3b3
using PlutoTeachingTools

# ╔═╡ d8c50cf8-62fb-4d58-ab66-ce8b13cc1fae
using PlutoUI

# ╔═╡ 7d3d0153-f1a3-47ac-9396-3cce21f41743
using PlutoTest

# ╔═╡ 56057902-de8d-11ed-1278-971402574480
md"""
!!! danger "Introduction to Julia - sales pitch"
	🏠[Course home](https://gdalle.github.io/IntroJulia/)
"""

# ╔═╡ 6afdd882-b89b-4bad-9aa4-cd4867551b92
html"<button onclick='present()'>Present</button>"

# ╔═╡ 85038100-6677-48e3-856c-8222735159ad
TableOfContents()

# ╔═╡ 2ce2824f-52b7-444e-950f-5370b4ba59e0
md"""
# Example gallery
"""

# ╔═╡ 22b1bb59-f0de-4888-9b9c-fbaf0fab773c


# ╔═╡ dd796fa6-fa31-4559-9855-f6ade6a6c510
md"""
# The Julia story
"""

# ╔═╡ 5c1790e6-4b0d-41a3-9a73-a56cce53a4f5
md"""
## 2012: the announcement
"""

# ╔═╡ 4d7fdbcd-e0ef-4801-8c57-a18e930fc273
md"""
> We are power Matlab users. Some of us are Lisp hackers. Some are Pythonistas, others Rubyists, still others Perl hackers. There are those of us who used Mathematica before we could grow facial hair. There are those who still can't grow facial hair. We've generated more R plots than any sane person should. C is our desert island programming language.
>
> We love all of these languages; they are wonderful and powerful. For the work we do — scientific computing, machine learning, data mining, large-scale linear algebra, distributed and parallel computing — each one is perfect for some aspects of the work and terrible for others. Each one is a trade-off.
>
> We are greedy: we want more.

[Why we created Julia](https://julialang.org/blog/2012/02/why-we-created-julia/) -- Jeff Bezanson, Stefan Karpinski, Viral B. Shah, and Alan Edelman
"""

# ╔═╡ 7b3b504e-37af-4b62-a029-868f6f1dfdde
md"""
## 2017: the SIAM Review article
"""

# ╔═╡ 09e11181-a81b-4527-8f40-a2a45bd7574c
md"""
> Julia is designed to be easy and fast and questions notions generally held to be “laws of nature” by practitioners of numerical computing:
> 1. High-level dynamic programs have to be slow.
> 2. One must prototype in one language and then rewrite in another language for speed or deployment.
> 3. There are parts of a system appropriate for the programmer, and other parts that are best left untouched as they have been built by the experts.

[Julia: A Fresh Approach to Numerical Computing](https://epubs.siam.org/doi/10.1137/141000671) -- Jeff Bezanson, Alan Edelman, Stefan Karpinski, and Viral B. Shah
"""

# ╔═╡ 7b21340d-e638-4581-afa9-878fc0d3842f
md"""
## 2018: a stable language
"""

# ╔═╡ fd55ba42-e17e-47f7-a629-1b0a3f2c2c74
md"""
> The single most significant new feature in Julia 1.0, of course, is a commitment to language API stability: code you write for Julia 1.0 will continue to work in Julia 1.1, 1.2, etc. The language is “fully baked.” The core language devs and community alike can focus on packages, tools, and new features built upon this solid foundation.

[Announcing the release of Julia 1.0](https://julialang.org/blog/2018/08/one-point-zero/) -- Julia developers
"""

# ╔═╡ a3ea30b3-0e2a-407d-b5ba-e577e63f9e8f
md"""
## 2022: user testimonies
"""

# ╔═╡ fd937762-0915-4655-846a-0e6fa735e239
md"""
[Why we use Julia, 10 years later](https://julialang.org/blog/2022/02/10years/) -- The Julia Community
"""

# ╔═╡ 36dcfe6a-d9bc-448f-a359-620261eaa6df
md"""
## 2023: time to first plot is "solved"
"""

# ╔═╡ 964afa90-73ce-42f3-bfcd-33688ccb7368
md"""
## Every year: JuliaCon
"""

# ╔═╡ 38d6ab9e-3aa0-4890-b8a6-ae1bc3dd4d00
md"""
# Things that make me happy
"""

# ╔═╡ 8f333a67-090b-4310-9af8-5690855a6ac7
md"""
## Package management
"""

# ╔═╡ 489823e8-1e5f-4493-a0c3-2dbbec842142
md"""
## Reactive notebooks
"""

# ╔═╡ 31ce0ecf-69ea-41c6-970f-7117d8399ad2
md"""
# What Julia is good at
"""

# ╔═╡ f57118ea-aa48-45dc-9608-01191b4e686c
md"""
## Plotting
"""

# ╔═╡ 01c815ae-f018-425a-995d-fda5892d7ed2
md"""
## Scientific machine learning
"""

# ╔═╡ 68bdad76-5be7-4824-8c8b-7412fd5ef7a3
md"""
## Optimization
"""

# ╔═╡ b54709c3-f706-46b1-ad56-32f714380eda
md"""
## Automatic differentiation
"""

# ╔═╡ 7b98c941-5156-4f8b-8c2a-b134a0f51597
md"""
## High-performance computing
"""

# ╔═╡ 17b8eacd-db40-43ed-bce7-aea03b3ad447
md"""
# Peeking under the hood
"""

# ╔═╡ 0ac0acfb-8ba2-4afd-9480-60f0652c6351
md"""
## Abstraction
"""

# ╔═╡ 020e801b-0565-48f3-84d5-dd82764fad1b
md"""
## Specialization
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.9"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "78fdb7009f11d6058811d86c3eea6c5319b94ea6"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "d730914ef30a06732bdd9f763f6cc32e92ffbff1"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "6a125e6a4cb391e0b9adbd1afa9e771c2179f8ef"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.23"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

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
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "8c8b07296990c12ac3a9eb9f74cd80f7e81c16b7"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.9"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "feafdc70b2e6684314e188d95fe66d116de834a7"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

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
# ╟─56057902-de8d-11ed-1278-971402574480
# ╠═2483e29e-50cf-4158-ac7b-7f3c4505b3b3
# ╠═d8c50cf8-62fb-4d58-ab66-ce8b13cc1fae
# ╠═7d3d0153-f1a3-47ac-9396-3cce21f41743
# ╟─6afdd882-b89b-4bad-9aa4-cd4867551b92
# ╟─85038100-6677-48e3-856c-8222735159ad
# ╟─2ce2824f-52b7-444e-950f-5370b4ba59e0
# ╠═22b1bb59-f0de-4888-9b9c-fbaf0fab773c
# ╟─dd796fa6-fa31-4559-9855-f6ade6a6c510
# ╟─5c1790e6-4b0d-41a3-9a73-a56cce53a4f5
# ╟─4d7fdbcd-e0ef-4801-8c57-a18e930fc273
# ╟─7b3b504e-37af-4b62-a029-868f6f1dfdde
# ╟─09e11181-a81b-4527-8f40-a2a45bd7574c
# ╟─7b21340d-e638-4581-afa9-878fc0d3842f
# ╟─fd55ba42-e17e-47f7-a629-1b0a3f2c2c74
# ╟─a3ea30b3-0e2a-407d-b5ba-e577e63f9e8f
# ╟─fd937762-0915-4655-846a-0e6fa735e239
# ╟─36dcfe6a-d9bc-448f-a359-620261eaa6df
# ╟─964afa90-73ce-42f3-bfcd-33688ccb7368
# ╟─38d6ab9e-3aa0-4890-b8a6-ae1bc3dd4d00
# ╟─8f333a67-090b-4310-9af8-5690855a6ac7
# ╟─489823e8-1e5f-4493-a0c3-2dbbec842142
# ╟─31ce0ecf-69ea-41c6-970f-7117d8399ad2
# ╟─f57118ea-aa48-45dc-9608-01191b4e686c
# ╟─01c815ae-f018-425a-995d-fda5892d7ed2
# ╟─68bdad76-5be7-4824-8c8b-7412fd5ef7a3
# ╟─b54709c3-f706-46b1-ad56-32f714380eda
# ╟─7b98c941-5156-4f8b-8c2a-b134a0f51597
# ╟─17b8eacd-db40-43ed-bce7-aea03b3ad447
# ╟─0ac0acfb-8ba2-4afd-9480-60f0652c6351
# ╟─020e801b-0565-48f3-84d5-dd82764fad1b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
