include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/functions_for.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/activation_function.jl")
include("C:/Users/Usuário/Desktop/Julia-Projects/MS571/variables.jl")

Θ=[randInitializeWeights(N[l], N[l-1]) for l=2:L]
Θₗ=copy(Θ)
A=Vector{Vector{Float64}}(undef, L)
Εₗ=maximum(sum(abs.(foward(A, x₀[i, :], Θ)[L].-Y[i, :])) for i=1:m)
#last_check=0
while true 
  Ε=0
  Δ=[zeros(Float64, (N[l], N[l-1]+1)) for l=2:L]
  for i=1:m
    A=foward(A, x₀[i, :], Θ)
    δ=A[L].-Y[i, :]
    Ε=maximum([Ε, sum(abs.(δ))])
    for l=L-1:-1:1
        Δ[l]+=δ*hcat([1], A[l]')
        δ=(δ'*Θ[l][:, 2:end]).*gᶿ(A[l])
    end

    #last_check=check(1, 1, 1, i)
  end

  if Εₗ<Ε
    α/=10
    Θ=copy(Θₗ)
    Ε=Εₗ
  else
    Θₗ=copy(Θ)
  end
  Εₗ=Ε

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

for i=1:N[2]
    println(reshape(Θ[2][i, 2:end]), (Int(√N[1]), Int(√N[1])))
end