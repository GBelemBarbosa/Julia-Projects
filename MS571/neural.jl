λ=0
αᵢ=1
α=αᵢ
ϵ=0.001
itₘ=100000
Y=[1 0 0
0 1 0
0 0 1]
x₀=[0.1 0.3
0.6 -0.2
-1.2 -3.1]
m, n=size(x₀)
N=[n, 1, size(Y, 2)] #number of nodes (not including bias node) of each layer (both ends included)
L=length(N) #number of layers (both ends included)
#ϵₜ=0.00000001

h(x) = 1/(1+exp(-x))
gᶿ(x) = x.*(1 .-x)

function calc(A, x₀, Θ; L=L, h=h)
  A[1]=x₀
  for l=1:L-1
    A[l+1]=h.(hcat(ones(m, 1), A[l])*Θ[l])
  end
  return A
end  

function J(A, Θ, x₀, Y; L=L, λ=λ, h=h)
  Y_x=calc(A, x₀, Θ)[L]
  return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
end

function randInitializeWeights(Lᵢ, Lₒ)
  ϵ = (6/(Lᵢ+Lₒ))^(1/2)
  return rand(Float64, (Lᵢ+1, Lₒ))#= .*(2*ϵ).-ϵ =#
end

Θ=[randInitializeWeights(N[l-1], N[l]) for l=2:L]
#= Θ[1][:]=[0.5840734716978144; 0.051617598421553; 0.9918986567236378]
Θ[2][:, :]=[0.5140013396876221 0.4806251848919789; 0.5320848827153589 0.1742770270519577; 0.7135248439951913 0.5351374545060602]' =#
Θₗ=copy(Θ)

k=1
A=calc(Vector{Array{Float64}}(undef, L), x₀, Θ)
δ=A[L].-Y
Ε=maximum(abs.(δ))
Δ=[zeros(Float64, (N[l-1]+1, N[l])) for l=2:L]
while Ε>ϵ && k<itₘ 
  for l=L-1:-1:1
    Δ[l]=α.*vcat(ones(1, m), A[l]')*δ+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
    δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])
    Θ[l]-=Δ[l]./m
  end

  A=calc(A, x₀, Θ)

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

  #= Θ[2][1,1]+=ϵₜ
  F=J(A, Θ, x₀, Y)
  Θ[2][1,1]-=2*ϵₜ
  B=J(A, Θ, x₀, Y)
  println((F-B)/(2*ϵₜ), " ", -Δ[2][1, 1]/(m*αᵢ))
  k=itₘ =#
  
  k+=1
end
println(A[L], " ", Y, " ", Ε)
#[Θ_for[l]'.-Θ[l] for l=1:L-1]

for i=1:N[2]
    println(reshape(Θ[2][2:end, i]), (Int(√N[1]), Int(√N[1])))
end