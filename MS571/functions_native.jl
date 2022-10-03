function foward(A, x₀, Θ; L=L, h=h)
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
    end

    return A
end  

function J(Θ_v::Vector; L=L, λ=λ, h=h, A=A, x₀=x₀, Y=Y, N=N, s=s)
    Θ=[reshape(Θ_v[s[l-1]+1:s[l]+s[l-1]], (N[l-1]+1, N[l])) for l=2:L]
    Y_x=foward(A, x₀, Θ)[L]
  
    return abs(sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2)
end

function randInitializeWeights(; N=N)
  Θ=Vector{Float64}()

  for l=2:L
    ϵ = (6/(N[l-1]+N[l]))^(1/2)
    Θ=vcat(Θ, rand(Float64, Int((N[l-1]+1)*N[l])).*(2*ϵ).-ϵ)
  end

  return Θ
end