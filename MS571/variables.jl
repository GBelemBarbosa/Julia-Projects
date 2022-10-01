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
ϵₜ=0.00000001
k=0