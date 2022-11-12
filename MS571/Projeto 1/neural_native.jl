using Optim

include("functions_native.jl")
include("activation_function.jl")
include("variables.jl")

Θ=randInitializeWeights()
s=vcat([0], [Int((N[l-1]+1)*N[l]) for l=2:L])
Λ=[0, 0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10] #possíveis escolhas de λ
I=[5, 10, 20, 40] #possíveis números de iteração

results=Array{Tuple{Int64, Float64}}(undef, (length(Λ), length(I))) #matriz de resultados
A=Vector{Array{Float64}}(undef, L)
Δ=[zeros(Float64, (N[l-1]+1)*N[l]) for l=2:L]

for j=eachindex(I)
    itₘ=I[j]
    for i=eachindex(Λ) #itera sob todos os pares de possibilidades
        λ=Λ[i]
        res=optimize(J, g!, Θ, ConjugateGradient(), Optim.Options(iterations = itₘ)) #gradiente conjugado
        Θᵥ=Optim.minimizer(res)
        Θ_f=[reshape(Θᵥ[s[l-1]+1:s[l]+s[l-1]], (N[l-1]+1, N[l])) for l=2:L]
        Yₓ=foward(A, x₀, Θ_f)[L]
        results[i, j]=(sum(Int(argmax(Yₓ[i, :])!=labels[i]) for i=1:m), Optim.minimum(res)) #(erro de classificação da solução, J mínimo encontrado)
        println(Optim.iterations(res), )
    end
end