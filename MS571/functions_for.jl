function foward(A, x₀, Θ; L=L, h=h)
    A[1]=x₀
    for l=1:L-1
      A[l+1]=h.(Θ[l]*vcat([1], A[l]))
    end

    return A
end  

function J_λ(A, Θ, x₀, Y; L=L, λ=λ, h=h)
    Y_x=foward(A, x₀, Θ)[L]

    return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m+λ*sum([sum(Θ[l][2:end, :].^2) for l=1:L-1])/2
end

function J(A, Θ, x₀, Y; L=L, h=h)
    Y_x=foward(A, x₀, Θ)[L]

    return sum(Y.*log.(Y_x).+(1 .-Y).*log.(1 .-Y_x))/m
end

function check(l, i, j, I; Θ=Θ, L=L, x₀=x₀, Y=Y, Δ=Δ, m=m, ϵₜ=ϵₜ, α=α, last_check=last_check)
    A=Vector{Array{Float64}}(undef, L)
    
    Θ[l][i, j]+=ϵₜ
    F=J(A, Θ, x₀[I, :], Y[I, :])
    Θ[l][i, j]-=2*ϵₜ
    B=J(A, Θ, x₀[I, :], Y[I, :])
    current_check=-Δ[l][i, j]/(m*α)
    println((F-B)/(2*ϵₜ), " ", current_check-last_check)
    Θ[l][i, j]+=ϵₜ

    return current_check
end

function randInitializeWeights(Lᵢ, Lₒ)
    ϵ = (6/(Lᵢ+Lₒ))^(1/2)

    return rand(Float64, (Lᵢ, Lₒ+1)).*(2*ϵ).-ϵ
end