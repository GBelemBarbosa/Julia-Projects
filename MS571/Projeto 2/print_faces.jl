include("PCA.jl")

for i=1:100
    heatmap(reshape(X[i, :], (Int(√n), Int(√n))), color=:greys)
    savefig("images\\face"*string(i)*".png")
end

for i=1:100
    heatmap(reshape(X_recon[i, :], (Int(√n), Int(√n))), color=:greys)
    savefig("images\\face_recon"*string(i)*".png")
end