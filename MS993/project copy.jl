using Random, LaTeXStrings, LinearAlgebra, Latexify
using Plots; pyplot()

m=8
n=3

f(x)=12-3x
g(x)=2-0.5x

disturb=1.5.*randn(m)
x₁=2 .-4 .*rand(m)
x₂=f.(x₁)
y=g.(x₁)
xlim=[-2; 2]
ylim=f.(xlim)

c=2
anim = @animate for i=0:0.05:c
    X=hcat(ones(m, 1), x₁, x₂.+abs(i-1).*disturb)
    β=X'*X\(X'*y)
    U, Σ, V=svd(X)
    Vt=V'

    f(x)=-(V[1, 3]+V[2, 3]x)./V[3, 3]
    ylim=f.(xlim)

    plt=plot3d(xlim, ylim, vec(zeros(2, 1)),
        camera=(10, 30),
        xlabel=L"x_1",
        ylabel=L"x_2",
        zlabel=L"y",
        zlims=(0, 4.5),
        title=L"\sigma_1="*string(round(Σ[1]; digits=2))*L", \sigma_2="*string(round(Σ[2]; digits=2))*L", \sigma_3="*string(round(Σ[3]; digits=2)),
        labels="")
    plot3d!(xlim, ylim, hcat(ones(2, 1), xlim, ylim)*β, labels="Previsão")
    scatter!(x₁, X[:, 3], vec(zeros(m, 1)), labels="", color="green")
    scatter!(x₁, X[:, 3], y, labels="Dados", color="pink")
    for i=eachindex(x₁)
        plot3d!([x₁[i], x₁[i]], [X[i, 3], X[i, 3]], [0, y[i]], line=(:dash), color="orange", labels="")
    end
    plt
end
gif(anim, "colapse.gif", fps=5)

println("----------------")