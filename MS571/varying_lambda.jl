using Plots

include("functions_vectorized.jl")
include("activation_function.jl")
include("variables.jl")
include("neural_vectorized_function.jl")

new_index=shuffle(1:m) #índices embaralhados
x₀=x₀[new_index, :]
labels=labels[new_index]
Y=Y[new_index, :]
m_treino=3000 #60% de m
m_validacao=1000 #20% de m
m_teste=m-m_treino-m_validacao #20% de m

x₀_treino=x₀[1:m_treino, :]
Y_treino=Y[1:m_treino, :]
labels_treino=labels[1:m_treino]

x₀_validacao=x₀[1+m_treino:m_treino+m_validacao, :]
Y_validacao=Y[1+m_treino:m_treino+m_validacao, :]
labels_validacao=labels[1+m_treino:m_treino+m_validacao]

x₀_teste=x₀[1+m_treino+m_validacao:end, :]
Y_teste=Y[1+m_treino+m_validacao:end, :]
labels_teste=labels[1+m_treino+m_validacao:end]

Λ=[0, 0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10] #possíveis escolhas de λ
Θᵢ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
Θₗ=copy(Θᵢ) #copy of the initial Θ that will be  used in the gradient check
errors=zeros(Int64, length(Λ))
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
A=Vector{Array{Float64}}(undef, L)

p=scatter(0, 0)

for i=eachindex(Λ)
    λ=Λ[i]
    Θ=neural(x₀_treino, Y_treino, labels_treino, Θᵢ)

    A=foward(A, x₀_validacao, Θ; m=m_validacao)
    Ε_validacao=sum(Int(argmax(A[L][i, :])!=labels_validacao[i]) for i=1:m_validacao)
    errors[i]=Ε_validacao

    println(Ε_validacao)
    scatter!([λ], [Ε_validacao], color="red", label="")

    β=βᵢ
    α=αᵢ/β #resetando a taxa de aprendizado
end

plot!(xlabel="λ", ylabel="Número de classificações incorretas")
display(p)

λ=Λ[argmin(errors)] #λ ótimo
Θ=neural(vcat(x₀_treino, x₀_validacao), vcat(Y_treino, Y_validacao), vcat(labels_treino, labels_validacao), Θᵢ) #Θ com λ ótimo e usando exemplos de validação no treino
A=foward(A, x₀_teste, Θ; m=m_teste)
Ε_teste=sum(Int(argmax(A[L][i, :])!=labels_teste[i]) for i=1:m_teste)
println(Ε_teste)

β=βᵢ
α=αᵢ/β #resetando a taxa de aprendizado

Θ=neural(x₀, Y, labels, Θᵢ) #Θ com λ ótimo e usando exemplos de validação no treino
A=foward(A, x₀, Θ)
Ε=sum(Int(argmax(A[L][i, :])!=labels[i]) for i=1:m)