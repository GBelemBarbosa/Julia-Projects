function foward(A, x₀, Θ; L=L, h=h)
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
    end

    return A
end  

function J(A, Θ, x₀, Y; L=L, λ=λ, h=h)
  Y_x=foward(A, x₀, Θ)[L]

  return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
end

function check(l, i, j, lₗ; Θ=Θ, Θₗ=Θₗ, L=L, x₀=x₀, Y=Y, Δ=Δ, m=m, ϵₜ=ϵₜ, α=α)
  A=Vector{Array{Float64}}(undef, L)

  for k=lₗ+1:L-1
    Θ[k], Θₗ[k]=Θₗ[k], Θ[k]
  end
  Θ[l][i, j]+=ϵₜ
  F=J(A, Θ, x₀, Y)
  Θ[l][i, j]-=2*ϵₜ
  B=J(A, Θ, x₀, Y)
  println((F-B)/(2*ϵₜ), " ", -Δ[l][i, j]/(m*α))
  Θ[l][i, j]+=ϵₜ
  for k=lₗ+1:L-1
    Θ[k], Θₗ[k]=Θₗ[k], Θ[k]
  end
end

function randInitializeWeights(Lᵢ, Lₒ)
  ϵ = (6/(Lᵢ+Lₒ))^(1/2)

  return rand(Float64, (Lᵢ+1, Lₒ)).*(2*ϵ).-ϵ
end