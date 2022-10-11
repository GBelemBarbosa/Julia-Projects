include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/functions_vectorized.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/activation_function.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/variables.jl")

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
A=foward(Vector{Array{Float64}}(undef, L), x₀, Θ)
δ=A[L].-Y
Ε=sum(round.(abs.(δ)))
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=α.*vcat(ones(1, m), A[l]')*δ./m+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])

    #check(l, 1, 1, l)

    Θ[l]-=Δ[l]
  end

  A=foward(A, x₀, Θ)

  δ=A[L].-Y
  Εₗ=Ε
  Ε=sum(round.(abs.(δ)))
  if Εₗ<Ε
    β+=βᵢ
    α=αᵢ/β
    println(α, ' ', k, ' ', Εₗ, ' ', Ε)
  end
  
  k+=1
  #k=itₘ
end
println(sum(round.(abs.(δ))))

#= for i=1:N[2]
    println(reshape(Θ[2][2:end, i]), (Int(√N[1]), Int(√N[1])))
end =#
