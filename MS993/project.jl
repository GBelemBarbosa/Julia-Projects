X=hcat(ones(m, 1), x₁, x₂)
β=X'*X\(X'*y)
println(latexify(X; fmt="%.4e"))

U, Σ, V=svd(X)
println(latexify(U; fmt="%.4e"))
println(latexify(Σ; fmt="%.4e"))
Vt=V'
println(latexify(Vt; fmt="%.4e"))

u=vcat([1], xₚ)'*V *Diagonal(Σ)^-1
println(latexify(u; fmt="%.4e"))
println(sum(u.^2))

println(latexify(V[:, 3]; fmt="%.4e"))
println(latexify(V[:, 3]./V[3, 3]; fmt="%.4e"))
f(x)=-(V[1, 3]+V[2, 3]x)./V[3, 3]
ylim=f.(xlim)

plt=plot3d(xlim, ylim, vec(zeros(2, 1)),
    camera=(10, 30),
    xlabel=L"x_1",
    ylabel=L"x_2",
    zlabel=L"y",
    zlims=(0, 4.5),
    title="Dados colineares",
    labels="")
plot3d!(xlim, ylim, hcat(ones(2, 1), xlim, ylim)*β, labels="Previsão")
scatter!(x₁, x₂, vec(zeros(m, 1)), labels="", color="green")
scatter!(x₁, x₂, y, labels="Dados", color="pink")
for i=eachindex(x₁)
    plot3d!([x₁[i], x₁[i]], [x₂[i], x₂[i]], [0, y[i]], line=(:dash), color="orange", labels="")
end
display(plt)
savefig(plt, string(xₚ[2])*string(round(V[3, 3], digits=3))*"plane10.png")

plt1=deepcopy(plt)
scatter!(plt1, [xₚ[1]], [xₚ[2]], [0], labels="Dado a prever", color="darkblue")
savefig(plt1, string(xₚ[2])*string(round(V[3, 3], digits=3))*"plane11.png")

plt2=deepcopy(plt1)
plane(x, y)=β[1]+x*β[2]+y*β[3]
surface!(plt2, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
scatter!(plt2, [xₚ[1]], [xₚ[2]], [plane(xₚ[1], xₚ[2])], labels="Previsão do novo dado", color="magenta")
plot3d!(plt2, [xₚ[1], xₚ[1]], [xₚ[2], xₚ[2]], [0, plane(xₚ[1], xₚ[2])], line=(:dash), color="orange", labels="")
savefig(plt2, string(xₚ[2])*string(round(V[3, 3], digits=3))*"plane12.png")

U, Σ, Vt=U[:, 1:2], Σ[1:2], Vt[1:2, :]
α=U'*y
Z=Diagonal(Σ)*Vt
if flag
    plt3=deepcopy(plt1)
    β[3]=-0.3
    β[1], β[2]=Z[:, 1:2]\(α-Z[:, 3]*β[3])
    surface!(plt3, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
    scatter!(plt3, [xₚ[1]], [xₚ[2]], [plane(xₚ[1], xₚ[2])], labels="Previsão do novo dado", color="magenta")
    plot3d!(plt3, [xₚ[1], xₚ[1]], [xₚ[2], xₚ[2]], [0, plane(xₚ[1], xₚ[2])], line=(:dash), color="orange", labels="")
    savefig(plt3, string(xₚ[2])*string(round(V[3, 3], digits=3))*"plane12newplane.png")
end
#= c=1
anim = @animate for i=0:0.01:c
    plt3=deepcopy(plt1)
    β[3]=abs(i-c/2)
    β[1], β[2]=Z[:, 1:2]\(α-Z[:, 3]*β[3])
    surface!(plt3, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
    scatter!(plt3, [xₚ[1]], [xₚ[2]], [plane(xₚ[1], xₚ[2])], labels="Previsão do novo dado", color="magenta")
    plot3d!(plt3, [xₚ[1], xₚ[1]], [xₚ[2], xₚ[2]], [0, plane(xₚ[1], xₚ[2])], line=(:dash), color="orange", labels="")
end
gif(anim, "plane.gif", fps=10) =#

println("----------------")