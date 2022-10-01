include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/functions_vectorized.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/activation_function.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/variables.jl")

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
Θₗ=copy(Θ)
A=foward(Vector{Array{Float64}}(undef, L), x₀, Θ)
δ=A[L].-Y
Ε=maximum(sum(abs.(δ), dims=2))
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=α.*vcat(ones(1, m), A[l]')*δ+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])

    #check(l, 1, 1, l)

    Θ[l]-=Δ[l]./m
  end

  A=foward(A, x₀, Θ)

  δ=A[L].-Y
  Εₗ=Ε
  Ε=maximum(sum(abs.(δ), dims=2))
  if Εₗ<Ε
    α/=10
    Θ=copy(Θₗ)
    Ε=Εₗ
  else
    Θₗ=copy(Θ)
  end
  
  k+=1
  #k=itₘ
end
println(A[L], " ", Y, " ", Ε)

for i=1:N[2]
    println(reshape(Θ[2][2:end, i]), (Int(√N[1]), Int(√N[1])))
end