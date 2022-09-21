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
itₘ=10000

h(x) = 1/(1+exp(-x))
gᶿ(x) = x.*(1 .-x)

function calc(A, x₀, Θ, h; L=L, N=N)
  A[1]=x₀
  for l=1:L-1
    A[l+1]=h.(hcat(ones(N[l]+1, 1), A[l])*Θ[l])
  end
  return A
end  

Θ=[rand(Float64, (N[l-1]+1, N[l])) for l=2:L+1]
Θ[L]=ones(Float64, (N[L-1]+1, 1))
Θₗ=copy(Θ)

k=1
A=calc(Vector{Array{Float64}}(undef, L), x₀, Θ, h)
δ=A[L].-Y
Ε=maximum(abs.(δ))
Δ=[zeros(Float64, (N[l], N[l-1]+1)) for l=2:L]
while Ε>ϵ && k<itₘ 
  Δ[L-1]=sum(δ.*hcat(ones(m, 1), A[L-1]), dims=1)'
  δ=(δ*Θ[L-1][2:end]').*gᶿ(A[L-1])
  Θ[L-1]-=(α/m).*Δ[L-1]
  for l=L-2:-1:1
    Δ[l]=vcat(ones(1, m), A[l]')*δ
    δ=(δ*Θ[l][2:end, :]).*gᶿ(A[l])
    Θ[l]-=(α/m).*Δ[l]
  end

  A=calc(A, x₀, Θ, h)

  δ=A[L].-Y
  Εₗ=Ε
  Ε=maximum(abs.(δ))
  if Εₗ<Ε
    α/=10
    Θ=copy(Θₗ)
    Ε=Εₗ
  else
    Θₗ=copy(Θ)
  end

  k+=1
end
println(Ε)
println(calc(A, x₀, Θ, h))