using Optim

include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/functions_native.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/activation_function.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/variables.jl")

Θ=randInitializeWeights()
s=vcat([0], [Int((N[l-1]+1)*N[l]) for l=2:L])

A=Vector{Array{Float64}}(undef, L)

res=optimize(J, Θ)
Θ_v=Optim.minimizer(res)
Θ_f=[reshape(Θ_v[s[l-1]+1:s[l]+s[l-1]], (N[l-1]+1, N[l])) for l=2:L]
Y_x=foward(A, x₀, Θ_f)[L]
Ε=Optim.minimum(res)
println(res)
println(Y_x)