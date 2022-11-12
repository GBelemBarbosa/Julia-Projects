include("variablesPCA.jl")

U, S, V=svd(Σ)
Vt=V'

U_reduzida=U[:, 1:k] #Tomando a porção dos k componentes principais

X_reduzida=X*U_reduzida #Dados reduzidos

X_recon=X_reduzida*U_reduzida' #Dados reconstruídos

println(sum(S[i] for i=1:k)/sum(S)) #Variância para k valores principais