using Plots 

include("functions_vectorized.jl")
include("activation_function.jl")
include("variables.jl")

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

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
Θₗ=copy(Θ) #copy of the initial Θ that will be  used in the gradient check
A=foward(A, x₀_validacao, Θ; m=m_validacao)
Ε_validacao=sum([Int(argmax(A[L][i, :])!=labels_validacao[i]) for i=1:m_validacao])
A=foward(Vector{Array{Float64}}(undef, L), x₀_treino, Θ; m=m_treino)
δ=A[L].-Y_treino
Ε=sum(Int(argmax(A[L][i, :])!=labels_treino[i]) for i=1:m_treino)

p=scatter([k], [Ε], color="red", label="Erro dos exemplos de treino")
scatter!([k], [Ε_validacao], color="blue", label="Erro dos exemplos de validação")
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
k=0 #number of iterations
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=vcat(ones(1, m_treino), A[l]')*δ./m_treino+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])

    if k==0
      check(l, 1, 1)
    end

    Θ[l]-=α.*Δ[l]
  end
  
  A=foward(A, x₀_validacao, Θ; m=m_validacao)
  Ε_validacao=sum(Int(argmax(A[L][i, :])!=labels_validacao[i]) for i=1:m_validacao)

  A=foward(A, x₀_treino, Θ; m=m_treino)

  δ=A[L].-Y_treino
  Εₗ=Ε
  Ε=sum(Int(argmax(A[L][i, :])!=labels_treino[i]) for i=1:m_treino)
  if Εₗ<Ε
    β+=βᵢ
    α=αᵢ/β
    println(α, ' ', k, ' ', Εₗ, ' ', Ε)
  end

  scatter!([k+1], [Ε], color="red", label="")
  scatter!([k+1], [Ε_validacao], color="blue", label="")

  k+=1
end
A=foward(A, x₀_teste, Θ; m=m_teste)
Ε_teste=sum(Int(argmax(A[L][i, :])!=labels_teste[i]) for i=1:m_teste)
println(Ε, ' ', Ε_validacao, ' ', Ε_teste)
display(p)
savefig("errors.png")
