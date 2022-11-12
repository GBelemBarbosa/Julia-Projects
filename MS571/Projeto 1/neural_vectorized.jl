include("functions_vectorized.jl")
include("activation_function.jl")
include("variables.jl")

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
Θₗ=copy(Θ) #copy of the initial Θ that will be  used in the gradient check
A=foward(Vector{Array{Float64}}(undef, L), x₀, Θ)
δ=A[L].-Y
Ε=sum(Int(argmax(A[L][i, :])!=labels[i]) for i=1:m)
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
k=0 #number of iterations
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=vcat(ones(1, m), A[l]')*δ./m+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])

    if k==0
      check(l, 1, 1)
    end

    Θ[l]-=α.*Δ[l]
  end

  A=foward(A, x₀, Θ)

  δ=A[L].-Y
  Εₗ=Ε
  Ε=sum(Int(argmax(A[L][i, :])!=labels[i]) for i=1:m)
  if Εₗ<Ε
    β+=βᵢ
    α=αᵢ/β
    println(α, ' ', k, ' ', Εₗ, ' ', Ε)
  end
  
  k+=1
end
println(Ε)
