function neural(x₀, Y, labels, Θᵢ; N=N, L=L, ϵ=ϵ, itₘ=itₘ, α=α, αᵢ=αᵢ, β=β, βᵢ=βᵢ, Δ=Δ, λ=λ)
    m=length(labels)
    Θ=copy(Θᵢ)

    A=foward(Vector{Array{Float64}}(undef, L), x₀, Θ; m=m)
    δ=A[L].-Y
    Ε=sum(Int(argmax(A[L][i, :])!=labels[i]) for i=1:m)

    k=0
    while Ε>ϵ && k<itₘ 
        for l=L-1:-1:1
            Δ[l]=vcat(ones(1, m), A[l]')*δ./m+λ.*vcat(zeros(1, N[l+1]), Θ[l][2:end, :])
            δ=(δ*Θ[l][2:end, :]').*gᶿ(A[l])

            if k==0
                check(l, 2, 1; Y=Y, x₀=x₀, m=m)
            end

            Θ[l]-=α.*Δ[l]
        end
        
        A=foward(A, x₀, Θ; m=m)

        δ=A[L].-Y
        Εₗ=Ε
        Ε=sum(Int(argmax(A[L][i, :])!=labels[i]) for i=1:m)
        if Εₗ<Ε
            β+=βᵢ
            α=αᵢ/β
        end

        k+=1
    end

    return Θ
end