using MAT, Shuffle, Plots, LinearAlgebra

file=matopen("dado1.mat")
X=read(file, "X")
close(file)
m, n=size(X)
k=100 #Número de componentes principais usados

X_normalized=Array{Float64}(undef, m, 0)
for i=1:n
    @inbounds global X_normalized=hcat(X_normalized, X[:, i].-sum(X[:, i])/m)
end
Σ=X_normalized'X_normalized./m
