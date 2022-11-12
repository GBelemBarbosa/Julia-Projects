include("PCA.jl")

sum_S=sum(S)
sum_Sk=0
for k=1:n
    global sum_Sk+=S[k]
    if sum_Sk/sum_S>=0.99
        println("k mínimo tal que 99% da variância seja retida: ", k)
        break
    end
end