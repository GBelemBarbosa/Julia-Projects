using Optim

include("functions_native.jl")
include("variablesRec.jl")

Λ=[0] #Possíveis escolhas de λ

results=Array{Float64}(undef, (length(Λ), length(Λ))) #Matriz de resultados

println(J(P)) #Peso das variáveis aleatórias

for i=eachindex(Λ)
    global λ₁=Λ[i]
    for j=eachindex(Λ) #Itera sob todos os pares de possibilidades
        global λ₂=Λ[j]
        res=optimize(J, g!, P, ConjugateGradient()) #Gradiente conjugado
        P_p=Optim.minimizer(res)
        global X_p=reshape(P_p[1:n*k], (n, k))
        global Θ_p=reshape(P_p[n*k+1:end], (m, k))
        global Y_p=X_p*Θ_p'
        results[i, j]=Optim.minimum(res) #J mínimo
        println(results[i, j])
    end
end

using Latexify

sorted_by_score=sort(movie_ids, rev=true, by=x->sum(Y_p[findfirst(isequal(x), movie_ids)[1], :])) #Sorting nos filmes por score
for i=1:10
    println(sorted_by_score[i], ", média: ", sum(Y_p[findfirst(isequal(sorted_by_score[i]), movie_ids)[1], :])/m, ";")
end