using Optmin

λ=0
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

function J(Θ)
  Y_x=calc(A, x₀, Θ)[L]
  return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
end

function randInitializeWeights(Lᵢ, Lₒ)
    ϵ = (6/(Lᵢ+Lₒ))^(1/2)
    return rand(Float64, (Lᵢ+1, Lₒ))#= .*(2*ϵ).-ϵ =#
end

Θ=[zeros(N[l-1], N[l]) for l=2:L]
#= Θ[1][:]=[0.5840734716978144; 0.051617598421553; 0.9918986567236378]
Θ[2][:, :]=[0.5140013396876221 0.4806251848919789; 0.5320848827153589 0.1742770270519577; 0.7135248439951913 0.5351374545060602]' =#

A=Vector{Array{Float64}}(undef, L)

res=optimeze(J, [Θ, Θ])

