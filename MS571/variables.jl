using DelimitedFiles
using CSV
using DataFrames

λ=0
αᵢ=10
βᵢ=10
β=βᵢ
α=αᵢ/β
ϵ=0.001
itₘ=200
labels=readdlm("MS571/labelMNIST.csv", Int64)
Y=[Int(j==labels[i]) for i=eachindex(labels), j=1:maximum(labels)]
str=read("MS571/imageMNIST.csv", String)
x₀=readdlm("MS571/imageMNIST.txt", ',', Float64)
m, n=size(x₀)
N=[n, 25, size(Y, 2)] #number of nodes (not including bias node) of each layer (both ends included)
L=length(N) #number of layers (both ends included)
ϵₜ=0.00000001
k=0