using Random, LaTeXStrings, LinearAlgebra
using Plots; pyplot()

f(x)=12-3x
g(x)=2-0.5x+0.3*randn()

xlim=[-2.0
    2.0]
ylim=f.(xlim)
m=8
x₁=2 .-4 .*rand(m)
x₂=f.(x₁)
ϵ=-0.2
x₂[end]-=1
y=g.(x₁)
y[end]+=ϵ
X=hcat(ones(m, 1), x₁, x₂)
β=X'*X\(X'*y)
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
sleep(10)

scatter!(plt0, [-1], [10], [0], labels="Dado a prever", color="darkblue")
plt1=deepcopy(plt)
scatter!(plt1, [-1], [10], [0], labels="Dado a prever", color="darkblue")
display(plt1)
sleep(10)

plt2=deepcopy(plt1)
plane(x, y)=β[1]+x*β[2]+y*β[3]
surface!(plt2, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
scatter!(plt2, [-1], [10], [plane(-1, 10)], labels="Previsão do novo dado", color="magenta")
plot3d!(plt2, [-1, -1], [10, 10], [0, plane(-1, 10)], line=(:dash), color="orange", labels="")
display(plt2)
sleep(10)

U, Σ, V=svd(X)
println(svd(X))
Vt=V'
U, Σ, Vt=U[:, 1:2], Σ[1:2], Vt[1:2, :]
α=U'*y
Z=Diagonal(Σ)*Vt
anim = @animate for i=0:0.05:2
    plt3=deepcopy(plt0)
    y[end]-=0.05*ϵ
    β=X'*X\(X'*y)
    plane(x, y)=β[1]+x*β[2]+y*β[3]
    scatter!(plt3, [x₁[end]], [X[end, end]], [y[end]], labels="Dado não colinear mais erro", color="red")
    plot3d!(plt3, [x₁[end], x₁[end]], [x₂[end], x₂[end]], [0, y[end]], line=(:dash), color="orange", labels="")
    surface!(plt3, -2:0.1:2, 6:0.1:18, plane, alpha=0.4, colorbar=false)
    scatter!(plt3, [-1], [10], [plane(-1, 10)], labels="Previsão do novo dado", color="magenta")
    plot3d!(plt3, [-1, -1], [10, 10], [0, plane(-1, 10)], line=(:dash), color="orange", labels="")
end
gif=gif(anim, "plane_almost.gif", fps=10)