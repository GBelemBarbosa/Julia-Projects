function foward(A, x₀, Θ; L=L, m=m) #return all layers of activation units
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
    end

    return A
end  

function J(A, Θ, x₀, Y; L=L, λ=λ, m=m) #cost function
  Y_x=foward(A, x₀, Θ; m=size(x₀)[1])[L]

  return -sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum(sum(Θ[l][2:end, :].^2) for l=1:L-1)/2
end

function check(l, i, j; Θₗ=Θₗ, L=L, x₀=x₀, Y=Y, Δ=Δ, m=m, ϵₜ=ϵₜ, α=α) #gradient check with unilateral difference
  A=Vector{Array{Float64}}(undef, L)

  Θₗ[l][i, j]+=ϵₜ
  F=J(A, Θₗ, x₀, Y; m=m) #value ϵₜ-ahead
  Θₗ[l][i, j]-=2*ϵₜ
  B=J(A, Θₗ, x₀, Y; m=m) #value ϵₜ-behind
  println((F-B)/(2*ϵₜ), " ", Δ[l][i, j])
  Θₗ[l][i, j]+=ϵₜ #return entry to original state
end

function randInitializeWeights(Lᵢ, Lₒ) #initialization of Θ with the Xavier distribution
  ϵ = (6/(Lᵢ+Lₒ))^(1/2)

  return vcat(zeros(Float64, (1, Lₒ)), rand(Float64, (Lᵢ, Lₒ)).*(2*ϵ).-ϵ)
end
