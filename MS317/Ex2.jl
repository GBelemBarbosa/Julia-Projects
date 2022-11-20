using Roots

renda(p, option1, option2)=(sum(renda[1]*renda[2] for renda in option1)-sum(renda[1]*renda[2] for renda in option2))/p
#Calcula uma renda de p períodos para option2 tal que renda final de option1 seja igual a de option2 

vectorize(option)=[option[i][2] for i=eachindex(option1) for j=1:option[i][1]]

VF(F, i)=sum(F[k]/(1+i)^(k-1) for k=eachindex(F)) #Valor final igual código visto em aula

option1=[(1, -1), (5, 1/10), (5, 1/5)] #Opção é lista de tuplas cujas primeiras entradas são o número de períodos e 
#as segundas a renda para aqueles períodos ((1, -1) representa o capital inicial)

option2=[(1, -1), (6, 1/10), (3, 1/5)]

r=renda(1, option1, option2)
x=1/r #r é inverso de x pela definição da função renda

println("x=", x)

option1ᵥ=vectorize(option1) #Vetoriza as opções para o formato visto em aula
option2ᵥ=vectorize(option2)

println("TIR=", find_zero(i -> VF(option1ᵥ, i), 0.0)) #Função find_zero resolve o problema

push!(option2ᵥ, r)

println("TIR=", find_zero(i -> VF(option2ᵥ, i), 0.0))

pop!(option2ᵥ)

r=renda(1, [(1, 2)], option2[2:end]) #A option1 é substituída por uma "opção" de renda 2c em 1 período para obter r tal que
#a renda final de option2 seja igual a 2c
x=1/r

println("x=", x)

push!(option2ᵥ, r)

println("TIR=", find_zero(i -> VF(option2ᵥ, i), 0.0))