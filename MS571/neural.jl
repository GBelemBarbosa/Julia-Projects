m=3
n=3
L=3 #number of layers (both ends included)
N=[n-1,2,1] #number of nodes (not including bias node) of each layer (both ends included)
push!(N, 0)
Y=[1
0
1]
x₀=[0.1 0.3
0.6 -0.2
-1.2 -3.1]
α=1
ϵ=0.001
itₘ=1

h(x) = 1/(1+exp(-x))

function calc(x₀, Θ, h; L=L, N=N)
  for l=1:L-1
    x₀=h.(hcat(ones(N[l]+1, 1), x₀)*Θ[l]')
  end
  return x₀
end  

Θ=[rand(Float64, (N[l], N[l-1]+1)) for l=2:L+1]
Θ[L]=ones(Float64, (1, N[L-1]+1))

k=0
Ε=0
A=Vector{Vector{Float64}}(undef, L)
while true 
  Δ=[zeros(Float64, (N[l], N[l-1]+1)) for l=2:L]
  for i=1:m
    A[1]=x₀[i, :]
    for l=1:L-1
      A[l+1]=h.(Θ[l]*vcat([1], A[l]))
    end
    δ=A[L].-Y[i]
    Ε=maximum([Ε, maximum(abs.(δ))])
    Δ[L-1].+=δ.*hcat(ones(N[L], 1), A[L-1]')
    δ=(Θ[L-1][2:end].*δ).*A[L-1].*(1 .-A[L-1])
    for l=L-2:-1:1
      Δ[l]+=δ*hcat([1], A[l]');
      δ=(Θ[l][:, 2:end]*δ).*A[l].*(1 .-A[l])
    end
  end
  for l=1:L-1
    Θ[l]-=(α/m).*Δ[l]
  end
  k+=1
  if abs(Ε)<ϵ || k>itₘ
    break
  end
end
