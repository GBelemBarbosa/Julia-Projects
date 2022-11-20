using MAT, DelimitedFiles

file=matopen("dado2.mat")
Yo=read(file, "Y")
R=read(file, "R")
close(file)
movie_ids=vec(readdlm("movie_ids.txt", '\n'))
n, m=size(Yo)
k=100 #Número de atributos
λ₁, λ₂=0, 0 #λ para a porção de X e Θ em J, respectivamente

Y=Array{Float64}(undef, 0, m) #Variável Y-μ
for i=1:n
    @inbounds global Y=vcat(Y, (Yo[i, :].-R[i, :].*sum(Yo[i, :])/sum(R[i, :]))') #Normalização
end
X=randn(n*k) #Inicialização de X, Θ e P, vetor de todas as variáveis
Θ=randn(m*k)
P=append!(Vector{Float64}(undef, 0), X, Θ)