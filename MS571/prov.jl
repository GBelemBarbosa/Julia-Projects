λ=0
α=1
ϵ=0.001
itₘ=100000
Y=[1 0
0 1
1 0]
x₀=[0.1 0.3
0.6 -0.2
-1.2 -3.1]
m=size(x₀, 1)
n=size(x₀, 2)
N=[n, 1, size(Y, 2)] #number of nodes (not including bias node) of each layer (both ends included)
L=length(N) #number of layers (both ends included)

h(x) = 1/(1+exp(-x))
gᶿ(x) = x.*(1 .-x)

function calc(A, x₀, Θ, h; L=L)
  A[1]=x₀
  for l=1:L-1
    A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
  end
  return A
end  

function randInitializeWeights(Lᵢ, Lₒ)
    ϵ = (6/(Lᵢ+Lₒ))^(1/2)
    return rand(Float64, Lᵢ+1, Lₒ)#= .*(2*ϵ).-ϵ =#
end

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
Θₗ=copy(Θ)

k=1
A=calc(Vector{Array{Float64}}(undef, L), x₀, Θ, h)
δ=A[L].-Y
Ε=maximum(abs.(δ))
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=α.*vcat(ones(1, m), A[l]')*δ+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])
    Θ[l]-=Δ[l]./m
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

  #= ϵₜ=0.00000001
  Θ[2][1,1]+=ϵₜ
  f=calc(A, x₀, Θ, h)[L]
  F=sum(Y.*log.(f).+(1 .-Y).*log.(1 .-f), dims=1)
  Θ[2][1,1]-=2*ϵₜ
  b=calc(A, x₀, Θ, h)[L]
  B=sum(Y.*log.(b).+(1 .-Y).*log.(1 .-b), dims=1)
  println(-(F-B)./(m*2*ϵₜ), " ", Δ[2][1, 1]/m)
  k=itₘ =#
  
  k+=1
end
println(A[L], " ", Y, " ", Ε)