λ=0
αᵢ=1
α=αᵢ
ϵ=0.001
itₘ=1000
Y=[1 0 0
0 1 0
0 0 1]
x₀=[0.1 0.3
0.6 -0.2
-1.2 -3.1]
m, n=size(x₀)
N=[n, 1, size(Y, 2)] #number of nodes (not including bias node) of each layer (both ends included)
L=length(N) #number of layers (both ends included)
#= ϵₜ=0.00000001
last_check=0 =#

h(x) = 1/(1+exp(-x))
gᶿ(x) = x.*(1 .-x)

function calc(A, x₀, Θ; L=L, h=h)
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(Θ[l]*vcat([1], A[l]))
    end
    return A
end  

function J(A, Θ, x₀, Y; L=L, λ=λ, h=h)
    Y_x=calc(A, x₀, Θ)[L]
    return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
end

function randInitializeWeights(Lᵢ, Lₒ)
    ϵ = (6/(Lᵢ+Lₒ))^(1/2)
    return rand(Float64, (Lᵢ, Lₒ+1))#= .*(2*ϵ).-ϵ =#
end
  
Θ=[randInitializeWeights(N[l], N[l-1]) for l=2:L]
#= Θ[1][:]=[0.5840734716978144, 0.051617598421553, 0.9918986567236378]
Θ[2][:, :]=[0.5140013396876221 0.4806251848919789; 0.5320848827153589 0.1742770270519577; 0.7135248439951913 0.5351374545060602] =#
Θₗ=copy(Θ)
println(Θ)

k=0
Ε=0
A=Vector{Vector{Float64}}(undef, L)
while true 
  Δ=[zeros(Float64, (N[l], N[l-1]+1)) for l=2:L]
  for i=1:m
    A=calc(A, x₀[i, :], Θ)
    δ=A[L].-Y[i, :]
    Ε=maximum([Ε, maximum(abs.(δ))])
    for l=L-1:-1:1
        Δ[l]+=α.*δ*hcat([1], A[l]')
        δ=(δ'*Θ[l][:, 2:end]).*gᶿ(A[l])
    end

    #= Θ[2][1,1]+=ϵₜ
    F=J(A, Θ, x₀[i, :], Y[i, :])-λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
    Θ[2][1,1]-=2*ϵₜ
    B=J(A, Θ, x₀[i, :], Y[i, :])-λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
    current_check=-Δ[2][1, 1]/(m*αᵢ)
    println((F-B)/(2*ϵₜ), " ", current_check-last_check)
    last_check=current_check
    Θ[2][1,1]+=ϵₜ
    k=itₘ+1 =#
  end
  for l=1:L-1
    Θ[l]-=(Δ[l]+λ.*hcat(zeros(N[l+1], 1), Θ[l][:, 2:end]))./m
  end

  Εₗ=Ε
  if Εₗ<Ε
    α/=10
    Θ=copy(Θₗ)
    Ε=Εₗ
  else
    Θₗ=copy(Θ)
  end

  k+=1
  if abs(Ε)<ϵ || k>itₘ
    break
  end
end
println(A[L], " ", Y[m, :], " ", Ε)
#Θ_for=copy(Θ)

for i=1:N[2]
    println(reshape(Θ[2][i, 2:end]), (Int(√N[1]), Int(√N[1])))
end