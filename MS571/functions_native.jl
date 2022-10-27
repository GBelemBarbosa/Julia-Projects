function foward(A, x₀, Θ; L=L, m=m)
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
    end

    return A
end  

function J(Θ_v::Vector; L=L, λ=λ, A=A, x₀=x₀, Y=Y, N=N, s=s)
    Θ=[reshape(Θ_v[s[l-1]+1:s[l]+s[l-1]], (N[l-1]+1, N[l])) for l=2:L]
    Yₓ=foward(A, x₀, Θ)[L]
  
    return -sum(Y.*log.(Yₓ).+(1 .-Y).*log.(1 .-Yₓ))/m+λ*sum(sum(Θ[l][2:end, :].^2) for l=1:L-1)/2
end

function g!(storage, Θ_v; L=L, ϵₜ=ϵₜ, m=m, λ=λ, Y=Y, N=N, s=s, Δ=Δ, A=A) #gradiente de J
  print(".")
  Θ=[reshape(Θ_v[s[l-1]+1:s[l]+s[l-1]], (N[l-1]+1, N[l])) for l=2:L]
  A=foward(A, x₀, Θ)

  δ=A[L].-Y
  for l=L-1:-1:1
      Δ[l]=vec(vcat(ones(1, m), A[l]')*δ./m+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :]))
      δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])
  end

  for l=2:L
    storage[s[l-1]+1:s[l]+s[l-1]]=Δ[l-1]
  end
end

function randInitializeWeights(; N=N, L=L)
  Θ=Vector{Float64}()

  for l=2:L
    ϵ=(6/(N[l-1]+N[l]))^(1/2)
    Θ=vcat(Θ, rand(Float64, Int((N[l-1]+1)*N[l])).*(2*ϵ).-ϵ)
  end

  return Θ
end