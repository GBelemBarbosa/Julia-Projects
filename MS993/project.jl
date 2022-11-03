using Random, LaTeXStrings, LinearAlgebra
using Plots; pyplot()

f(x)=12-3x
g(x)=2-0.5x+0.3*randn()

xlim=[-2.0
    2.0]
ylim=f.(xlim)
m=8
x₂=2 .-4 .*rand(m)
x₃=f.(x₂)
y=g.(x₂)
X=hcat(ones(m, 1), x₂, x₃)
β=X'*X\(X'*y)
plt=plot3d(xlim, ylim, vec(zeros(2, 1)),
    camera=(10, 30),
    xlabel=L"x_2",
    ylabel=L"x_3",
    zlabel=L"y",
    title="Dados colineares",
    labels="Projeção do fit")
plot3d!(xlim, ylim, hcat(ones(2, 1), xlim, ylim)*β, labels="Fit")
scatter!(x₂, x₃, vec(zeros(m, 1)), labels="Projeção dos dados")
scatter!(x₂, x₃, y, labels="Dados")
for i=eachindex(x₂)
    plot3d!([x₂[i], x₂[i]], [x₃[i], x₃[i]], [0, y[i]], line=(:dash), color="orange", labels="")
end
display(plt)
readline()

scatter!([-1], [10], [0], labels="")
display(plt)
readline()

plt2=deepcopy(plt)
plane(x, y)=β[1]+x*β[2]+y*β[3]
surface!(plt2, -2:0.1:2, 6:0.1:18, plane, alpha=0.2, colorbar=false)
scatter!([-1], [10], [plane(-1, 10)], labels="")
plot3d!([-1, -1], [10, 10], [0, plane(-1, 10)], line=(:dash), color="orange", labels="")
display(plt2)
readline()

U, Σ, V=svd(X)
Vt=V'
U, Σ, Vt=U[:, 1:2], Σ[1:2], Vt[1:2, :]
α=U'*y
Z=Diagonal(Σ)*Vt
anim = @animate for i=0:0.01:0.28
    plt2=deepcopy(plt)
    β[3]=abs(i-0.14)
    β[1], β[2]=Z[:, 1:2]\(α-Z[:, 3]*β[3])
    surface!(plt2, -2:0.1:2, 6:0.1:18, plane, alpha=0.2, colorbar=false)
    scatter!([-1], [10], [plane(-1, 10)], labels="")
    plot3d!([-1, -1], [10, 10], [0, plane(-1, 10)], line=(:dash), color="orange", labels="")
end
gif=gif(anim, "plane.gif", fps = 10)