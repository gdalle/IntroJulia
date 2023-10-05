### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ fb467b58-0f09-4fdf-9fd5-36070ede39ab
# ╠═╡ show_logs = false
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(url="https://github.com/gdalle/HashCode2014.jl"),
        Pkg.PackageSpec(name="PlutoTeachingTools"),
        Pkg.PackageSpec(name="PlutoUI"),
        Pkg.PackageSpec(name="PythonCall"),
    ])
    using HashCode2014, PlutoTeachingTools, PlutoUI, PythonCall
end

# ╔═╡ fcc41a80-b44a-4eb8-ade6-13f075c5b72f
TableOfContents()

# ╔═╡ 51d9bad9-aebd-40bb-8682-688a57c876db
html"<button onclick=present()>Present</button>"

# ╔═╡ 633fc28a-6138-11ed-2bf2-9fc45fc9a926
md"""
# Optimization challenge
"""

# ╔═╡ 6fdbc050-ed89-48af-9b21-43aeb5bc103a
md"""
# 1. Overview
"""

# ╔═╡ bf76e4a9-8319-4aca-91fc-93d31952906f
md"""
## Street view routing
"""

# ╔═╡ 5b096f1a-b5b7-4db0-855a-de39ddb5ef4c
md"""
This challenge is taken from Google Hash Code, an annual team programming competition.
Its 2014 final round was about routing cars with cameras through Paris, making them capture as much street data as possible within a limited time frame.

The first thing you need to do is read the official [task description](https://storage.googleapis.com/coding-competitions.appspot.com/HC/2014/hashcode2014_final_task.pdf).
"""

# ╔═╡ ed66c4e6-17e8-4706-9cf4-56f4bc1d7b6c
md"""
## Assignment
"""

# ╔═╡ 9a15943f-5dad-4043-b540-546d0fc2f025
md"""
Your goal is to solve Hash Code 2014 by developing a Julia package.
This package should follow the best pracices seen in class, and contain at least the following elements:
- Types for storing problem instances and solutions
- Functions for
  - checking the feasibility of a solution
  - computing its objective value
- Algorithms for
  - generating a good solution
  - finding an upper bound on the best objective value
- Thorough unit tests
- Detailed documentation
- Continuous integration
"""

# ╔═╡ 3dda0ec8-8471-47e4-b1ce-699f613845c0
md"""
## Deliverable
"""

# ╔═╡ a7cd1bb9-44b3-44ce-bf2e-e3575ae73efe
md"""
Your project will take the form of a public GitHub repository containing a Julia package and its documentation website.
We ask you to make it public because open source development produces code that is accessible, auditable and reusable by everyone.
This will also allow instructors to check in on your work regularly and give you advice if you need it.
"""

# ╔═╡ 5aea0b2d-c3da-4496-9a9f-2fbc31fecf19
md"""
The documentation website will serve as a report.
It should contain the following pages:

- a tutorial aimed at users of your code
- a list of all the docstrings
- a mathematical description of your algorithms
- a critical discussion of their implementation and performance
"""

# ╔═╡ 3eff3936-4713-43a8-b4c5-ac0245086fab
md"""
## Helper package
"""

# ╔═╡ e103f446-d3f9-432d-9fb6-dd0f67ee716b
md"""
We wrote a small package called [HashCode2014.jl](https://github.com/gdalle/HashCode2014.jl) to help you get started.
In addition to basic structures for storage, it includes a parser for text files, a solution checker, a very simple random walk algorithm that you can use as a baseline, and a visualization tool.
Check out its [documentation](https://gdalle.github.io/HashCode2014.jl/dev/) for more details.
"""

# ╔═╡ 0ae617af-adbd-428e-89aa-ddd0ab7ba07b
md"""
Instance manipulation
"""

# ╔═╡ 1af5671d-913e-43b5-aa79-ef8e9ae619b0
city = HashCode2014.read_city()

# ╔═╡ 9dd4e94c-b7c9-49ed-a526-4e2f35bb6ff3
city.junctions[1]

# ╔═╡ dfd54ad7-f64e-471d-a8f3-22dd25d55321
city.streets[1]

# ╔═╡ 4455a822-96f1-4cc3-b1d3-684db20d0fdc
md"""
Solution manipulation
"""

# ╔═╡ bdcad1ba-c27b-485d-ab08-2781e4dda004
solution = HashCode2014.random_walk(city)

# ╔═╡ f5c66add-ef7b-4499-9c20-5c3b44de3eba
HashCode2014.is_feasible(solution, city; verbose=true)

# ╔═╡ 29259dbd-74dd-446d-9bc3-e25a2146685c
HashCode2014.total_distance(solution, city)

# ╔═╡ ab7088c2-de1c-4351-a2a3-21956b4dcb27
HashCode2014.plot_streets(city, solution)

# ╔═╡ 493882c1-7bfe-4fb4-8cf7-6841cd4f9e4d
md"""
Most of the types and functions in this package are very inefficient: it is up to you to find better storage and evaluation methods!
"""

# ╔═╡ b268179b-a2ea-481d-be0d-e1aed35d6a6c
md"""
# 2. Rules and advice
"""

# ╔═╡ cd6d305e-f5fb-46f7-abbc-3b175f42a325
md"""
## Teams
"""

# ╔═╡ 1e0f6c1a-694c-4802-91b2-45c67baa0305
md"""
This challenge can be tackled individually, or in teams of up to 3 students.
"""

# ╔═╡ f7cb667c-bc7a-4a41-93a4-54d1e46611d2
md"""
To make things more fun, we encourage teams to compete against each other.
We will thus create a Google Sheets where you can enter your team information and your current best performance.
"""

# ╔═╡ cdb75786-4fc0-491f-bbd7-fdf59d36b668
md"""
## Ethics
"""

# ╔═╡ 6802a897-1be1-4d93-a432-b783ca648830
md"""
Since each team is expected to work in a public repository, plagiarism is technically possible, but we will not tolerate it.
If you draw inspiration from the work of others, we demand that you:
1. cite the source explicitly to separate their contributions
2. make their method better / faster in the process, and explain how you did it
"""

# ╔═╡ 3cc76524-62e7-4476-9a62-02ad93915172
md"""
## Tools
"""

# ╔═╡ 49ce7a51-815b-4d96-b217-e0bf65472828
md"""
As long as you program in Julia, you can use any package from the ecosystem.
We also allow the use of mathematical programming solvers, for instance through [JuMP.jl](https://github.com/jump-dev/JuMP.jl), even when these solvers are not written in Julia.

In terms of hardware, you should run your code on your personal laptop, and not on an MIT cluster or on JuliaHub.
Multithreading is allowed, but GPU computing probably won't be necessary.
As is often the case in combinatorial optimization, the biggest differences come from clever algorithms and implementations, not from having a bigger computer.

Your entire code should never take more than one hour to run on your laptop.
"""

# ╔═╡ d3175bdd-74dd-4c83-8540-a32323580d67
md"""
## Grading
"""

# ╔═╡ d011f5a4-3d5d-4bba-af45-de15efac5f98
md"""
The grading rubric is not defined yet, but the following items will be taken into account:
- Code quality
- Clarity of the documentation
- Cleverness of the algorithms
- Efficiency considerations
- Actual performance and leaderboard ranking (for a small part)
"""

# ╔═╡ Cell order:
# ╠═fb467b58-0f09-4fdf-9fd5-36070ede39ab
# ╠═fcc41a80-b44a-4eb8-ade6-13f075c5b72f
# ╟─51d9bad9-aebd-40bb-8682-688a57c876db
# ╟─633fc28a-6138-11ed-2bf2-9fc45fc9a926
# ╟─6fdbc050-ed89-48af-9b21-43aeb5bc103a
# ╟─bf76e4a9-8319-4aca-91fc-93d31952906f
# ╟─5b096f1a-b5b7-4db0-855a-de39ddb5ef4c
# ╟─ed66c4e6-17e8-4706-9cf4-56f4bc1d7b6c
# ╟─9a15943f-5dad-4043-b540-546d0fc2f025
# ╟─3dda0ec8-8471-47e4-b1ce-699f613845c0
# ╟─a7cd1bb9-44b3-44ce-bf2e-e3575ae73efe
# ╟─5aea0b2d-c3da-4496-9a9f-2fbc31fecf19
# ╟─3eff3936-4713-43a8-b4c5-ac0245086fab
# ╟─e103f446-d3f9-432d-9fb6-dd0f67ee716b
# ╟─0ae617af-adbd-428e-89aa-ddd0ab7ba07b
# ╠═1af5671d-913e-43b5-aa79-ef8e9ae619b0
# ╠═9dd4e94c-b7c9-49ed-a526-4e2f35bb6ff3
# ╠═dfd54ad7-f64e-471d-a8f3-22dd25d55321
# ╟─4455a822-96f1-4cc3-b1d3-684db20d0fdc
# ╠═bdcad1ba-c27b-485d-ab08-2781e4dda004
# ╠═f5c66add-ef7b-4499-9c20-5c3b44de3eba
# ╠═29259dbd-74dd-446d-9bc3-e25a2146685c
# ╠═ab7088c2-de1c-4351-a2a3-21956b4dcb27
# ╟─493882c1-7bfe-4fb4-8cf7-6841cd4f9e4d
# ╟─b268179b-a2ea-481d-be0d-e1aed35d6a6c
# ╟─cd6d305e-f5fb-46f7-abbc-3b175f42a325
# ╟─1e0f6c1a-694c-4802-91b2-45c67baa0305
# ╟─f7cb667c-bc7a-4a41-93a4-54d1e46611d2
# ╟─cdb75786-4fc0-491f-bbd7-fdf59d36b668
# ╟─6802a897-1be1-4d93-a432-b783ca648830
# ╟─3cc76524-62e7-4476-9a62-02ad93915172
# ╟─49ce7a51-815b-4d96-b217-e0bf65472828
# ╟─d3175bdd-74dd-4c83-8540-a32323580d67
# ╟─d011f5a4-3d5d-4bba-af45-de15efac5f98
