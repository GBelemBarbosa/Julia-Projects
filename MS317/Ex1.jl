interesse(p, option1, option2)=(reduce(*, [(1+x[2])^x[1] for x in option1])/reduce(*, [(1+x[2])^x[1] for x in option2]))^(1/p)-1
#Calcula um interesse de p períodos para option2 tal que capital final de option1 seja igual a de option2 

MfP(option)=reduce(*, [(1+x[2])^x[1] for x in option]) #Valor final

option1=[(5, 1/20), (5, 3/50), (5, 7/100)] #Opção é lista de tuplas cujas primeiras entradas são o número de períodos e 
#as segundas o interesse para aqueles períodos

option2=[(10, 3/50)]

x=interesse(5, option1, option2) #Calcula x para 5 períodos que iguala as opções

println("x=", x)

pop!(option1)
push!(option1, (10, 7/100)) #Retornando o problema para 20 meses

println("Mf/P (a)=", MfP(option1))

push!(option2, (10, x)) #Adicionando os períodos com interesse x

println("Mf/P (b)=", MfP(option2))