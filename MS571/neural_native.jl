using Optmim

include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/functions_vectorized.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/activation_function.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/variables.jl")

Θ=[zeros(N[l-1], N[l]) for l=2:L]
#Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]

A=Vector{Array{Float64}}(undef, L)

res=optimeze(J, [Θ, Θ])
