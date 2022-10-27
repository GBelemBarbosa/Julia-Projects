include("neural_vectorized.jl")

Errors=zeros(Float64, (size(Y, 2), size(Y, 2)))
for i=1:m
  if argmax(A[L][i, :])!=labels[i]
    Errors[argmax(A[L][i, :]), labels[i]]+=1
  end
end
println(Errors)
errors=heatmap(Errors, color=:greys)
savefig("errors.png")

for i=1:N[2]
  heatmap(reshape(Θ[1][2:end, i], (Int(√N[1]), Int(√N[1]))), color=:greys)
  savefig(string(i)*".png")
end
