function J(P::Vector; λ₁=λ₁, λ₂=λ₂, m=m, n=n, k=k, Y=Y, R=R)
    X=reshape(P[1:n*k], (n, k))
    Θ=reshape(P[n*k+1:end], (m, k))
  
    return sum(R.*(Y-X*Θ').^2)/2#+λ₁*sum(X.^2)/2+λ₂*sum(Θ.^2)/2
end

function g!(storage, P::Vector; λ₁=λ₁, λ₂=λ₂, m=m, n=n, k=k, Y=Y, R=R) #Gradiente de J
    X=reshape(P[1:n*k], (n, k))
    Θ=reshape(P[n*k+1:end], (m, k))

    err=X*Θ'-Y
    
    storage[1:n*k]=vec(err.*R*Θ.+λ₁.*X)
    storage[n*k+1:end]=vec((err.*R)'*X.+λ₂.*Θ)
end