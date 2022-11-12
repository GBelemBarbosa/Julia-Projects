using Optim

include("functions_native.jl")
include("variablesRec.jl")

Λ=[0] #Possíveis escolhas de λ

results=Array{Float64}(undef, (length(Λ), length(Λ))) #Matriz de resultados

println(J(P))

for i=eachindex(Λ)
    global λ₁=Λ[i]
    for j=eachindex(Λ) #Itera sob todos os pares de possibilidades
        global λ₂=Λ[j]
        println(λ₁, " ", λ₂)
        res=optimize(J, g!, P, ConjugateGradient()) #Gradiente conjugado
        P_p=Optim.minimizer(res)
        X_p=reshape(P[1:m*k], (m, k))
        Θ_p=reshape(P[m*k+1:end], (n, k))
        Y_p=X_p*Θ_p'
        results[i, j]=Optim.minimum(res) #J mínimo
        println(results[i, j])
    end
end