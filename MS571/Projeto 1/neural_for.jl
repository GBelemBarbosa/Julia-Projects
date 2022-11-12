include("functions_for.jl")
include("activation_function.jl")
include("variables.jl")

Θ=[randInitializeWeights(N[l], N[l-1]) for l=2:L]
Θ[L-1][:, 1].=0.5
Θₗ=copy(Θ)
A=Vector{Vector{Float64}}(undef, L)
Εₗ=sum(sum(abs.(foward(A, x₀[i, :], Θ)[L].-Y[i, :])) for i=1:m) 
#last_check=0
while true 
  Ε=0
  Δ=[zeros(Float64, (N[l], N[l-1]+1)) for l=2:L]
  for i=1:m
    A=foward(A, x₀[i, :], Θ)
    δ=A[L].-Y[i, :]
    Ε+=sum(abs.(δ))
    for l=L-1:-1:1
        Δ[l]+=δ*hcat([1], A[l]')
        δ=(δ'*Θ[l][:, 2:end]).*gᶿ(A[l])
    end

    #last_check=check(1, 1, 1, i)
  end

  if Εₗ<Ε
    β+=βᵢ
    α=αᵢ/β
    Θ=copy(Θₗ)
  else
    Θₗ=copy(Θ)
    Εₗ=Ε
  end

  for l=1:L-1
    Θ[l]-=(α.*Δ[l]+λ.*hcat(zeros(N[l+1], 1), Θ[l][:, 2:end]))./m
  end

  k+=1
  #k=itₘ
  if abs(Ε)<ϵ || k>=itₘ
    break
  end
end
for i=1:m
  println(foward(A, x₀[i, :], Θ)[L], " ", Y[i, :])
end

#= for i=1:N[2]
    println(reshape(Θ[2][i, 2:end]), (Int(√N[1]), Int(√N[1])))
end =#