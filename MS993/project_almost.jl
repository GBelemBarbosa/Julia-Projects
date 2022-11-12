x₂[end]-=k
X=hcat(ones(m, 1), x₁, x₂)
β=X'*X\(X'*y)

U, Σ, V=svd(X)
println(latexify(U; fmt="%.4e"))
println(latexify(Σ; fmt="%.4e"))
Vt=V'
println(latexify(Vt; fmt="%.4e"))

u=vcat([1], xₚ)'*V *Diagonal(Σ)^-1
println(latexify(u; fmt="%.4e"))
println(sum(u.^2))

Z=Diagonal(Σ)*Vt
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
    title="Dados quasi-colineares",
    labels="")
plot3d!(xlim, ylim, hcat(ones(2, 1), xlim, ylim)*β, labels="Previsão")
scatter!(plt, x₁[1:m-1], x₂[1:m-1], vec(zeros(m-1, 1)), labels="", color="green")
scatter!(plt, [x₁[end]], [x₂[end]], [0], labels="", color="green")
for i=1:m-1
    plot3d!(plt, [x₁[i], x₁[i]], [x₂[i], x₂[i]], [0, y[i]], line=(:dash), color="orange", labels="")
end
scatter!(plt, x₁[1:m-1], x₂[1:m-1], y[1:m-1], labels="Dados colineares", color="pink")
plt0=deepcopy(plt)
scatter!(plt, [x₁[end]], [x₂[end]], [y[end]], labels="Dado não colinear", color="red")
plot3d!(plt, [x₁[end], x₁[end]], [x₂[end], x₂[end]], [0, y[end]], line=(:dash), color="orange", labels="")
display(plt)
savefig(plt, string(xₚ[1])*string(xₚ[2])*string(k)*"plane20.png")

scatter!(plt0, [xₚ[1]], [xₚ[2]], [0], labels="Dado a prever", color="darkblue")
plt1=deepcopy(plt)
scatter!(plt1, [xₚ[1]], [xₚ[2]], [0], labels="Dado a prever", color="darkblue")
savefig(plt1, string(xₚ[1])*string(xₚ[2])*string(k)*"plane21.png")

plt2=deepcopy(plt1)
plane(x, y)=β[1]+x*β[2]+y*β[3]
surface!(plt2, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
scatter!(plt2, [xₚ[1]], [xₚ[2]], [plane(xₚ[1], xₚ[2])], labels="Previsão do novo dado", color="magenta")
plot3d!(plt2, [xₚ[1], xₚ[1]], [xₚ[2], xₚ[2]], [0, plane(xₚ[1], xₚ[2])], line=(:dash), color="orange", labels="")
savefig(plt2, string(xₚ[1])*string(xₚ[2])*string(k)*"plane22.png")

y[end]+=ϵ
#= anim = @animate for i=0:0.05:2
    plt3=deepcopy(plt0)
    y[end]-=0.05*ϵ
    β=X'*X\(X'*y)
    plane(x, y)=β[1]+x*β[2]+y*β[3]
    scatter!(plt3, [x₁[end]], [X[end, end]], [y[end]], labels="Dado não colinear mais erro", color="red")
    plot3d!(plt3, [x₁[end], x₁[end]], [x₂[end], x₂[end]], [0, y[end]], line=(:dash), color="orange", labels="")
    surface!(plt3, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
    scatter!(plt3, [xₚ[1]], [xₚ[2]], [plane(xₚ[1], xₚ[2])], labels="Previsão do novo dado", color="magenta")
    plot3d!(plt3, [xₚ[1], xₚ[1]], [xₚ[2], xₚ[2]], [0, plane(xₚ[1], xₚ[2])], line=(:dash), color="orange", labels="")
end
gif(anim, string(xₚ[1])*string(xₚ[2])*string(k)*"plane_almost.gif", fps=10) =#
x₂[end]+=k
y[end]+=ϵ

println("----------------")