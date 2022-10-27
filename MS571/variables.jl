using DelimitedFiles
using CSV
using DataFrames
using Shuffle

λ=0 #regularization parameter
αᵢ=10
βᵢ=10
β=βᵢ
α=αᵢ/β #α∈{αᵢ/βᵢ, αᵢ/2βᵢ, αᵢ/3βᵢ, ...} non-summable sequence of learning rates
ϵ=0 #early stopping parameter (err<=ϵ)
itₘ=10 #early stopping maximum iterations
labels=readdlm("labelMNIST.csv", Int64)
Y=[Int(j==labels[i]) for i=eachindex(labels), j=1:maximum(labels)] #labels in one-hot format
x₀=readdlm("imageMNIST.txt", ',', Float64)
m, n=size(x₀) #number of examples and attributes, respectively
N=[n, 25, size(Y, 2)] #number of nodes (not including bias node) of each layer (both ends included)
L=length(N) #number of layers (both ends included)
ϵₜ=0.0001 #gradient check time delta
