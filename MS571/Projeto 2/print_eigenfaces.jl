import Plots

include("PCA.jl")

for i=1:36
    heatmap(reshape(U[:, i], (Int(√n), Int(√n))), color=:greys)
    savefig("images\\eigen"*string(i)*".png")
end