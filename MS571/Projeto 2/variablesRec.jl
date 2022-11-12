using MAT, Shuffle, Plots

file=matopen("dado2.mat")
Yo=read(file, "Y")
R=read(file, "R")
close(file)
n, m=size(Yo)
k=100 #Número de atributos
λ₁, λ₂=0, 0

Y=Array{Float64}(undef, 0, m)
for i=1:n
    mean=sum(Yo[i, :])/sum(R[i, :])
    @inbounds global Y=vcat(Y, (Yo[i, :].-R[i, :].*mean)')
end
X=randn(n, k)
Θ=randn(m, k)
P=append!(vec(X), vec(Θ))