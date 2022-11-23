using Random, LaTeXStrings, LinearAlgebra, Latexify
using Plots; pyplot()

m=8
n=3

f(x)=12-3x
g(x)=2-0.5x+0.3*randn()

x₁=2 .-4 .*rand(m)
x₂=f.(x₁)
y=g.(x₁)
xlim=[-2; 2]
ylim=f.(xlim)
println("********************************************************")
println(latexify(x₁; fmt="%.4e"))

xₚ=[-1, 10]
flag=true
include("project.jl")

flag=false
x₂+=0.5*randn(m)
include("project.jl")
xₚ=[-1, 14]
include("project.jl")
