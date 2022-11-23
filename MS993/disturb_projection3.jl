using Plots, LaTeXStrings, LinearAlgebra, Printf

A=[1.7 -2
  -3.1 -0.5
  0.8 1.6]

b=[1; 1; 3.1]

κA=cond(A)

E=[2 0
   0.1 -1
   0 0.1]

θ=0.1
R=[1 0 0;
   0 cos(θ) -sin(θ);
   0 sin(θ) cos(θ)]

f=[0.0; 0.0; 0.0]

p0=surface(-4:0.1:4, -4:0.1:4, (x, y)->(A*(A[1:2,:]\[x; y]))[3], alpha=0.4, xlim=(-4, 4), ylim=(-4, 4), zlim=(-5, 5), colorbar=false, camera=(50, 20), color=:red, label=L"Im(A)", title=L"κ_2(A)="*(@sprintf "%.1E" κA)*L", ||E||="*(@sprintf "%.1E" norm(E)))
scatter3d!(p0, [b[1]], [b[2]], [b[3]], alpha=0.8, label=L"b=b+f", color="red")

x=A\b
bA=A*x

scatter3d!(p0, [bA[1]], [bA[2]], [bA[3]], label=L"proj_{Im(A)}(b)", alpha=0.8, color="green")

plot!(p0, [bA[1], b[1]], [bA[2], b[2]], [bA[3], b[3]], line=(:dash), alpha=0.4, label="", color="green")

p2=plot(title=L"\frac{||z-y||}{||z||}\leq ...", xlim=(0, 12))

last, last2=0, 0

c=10/50

anim=@animate for i=1:60
    global E=R*E
    A_E=A+E
    p=deepcopy(p0)

    surface!(p, -4:0.1:4, -4:0.1:4, (x, y)->(A_E*(A_E[1:2,:]\[x; y]))[3], alpha=0.4, colorbar=false, camera=(50, 20), color=:blue, label=L"Im(A+E)")

    b_f=b+f
    
    z=A_E\b
    b_fA_E=A_E*z

    s=A_E*z-b_f

    ϵa=norm(E)/norm(A)
    ϵf=norm(f)/(norm(A)*norm(z))

    dir=κA*(ϵa+ϵf)+norm(s)*ϵa*κA^2/(norm(A)*norm(z))

    #scatter3d!(p, [b_f[1]], [b_f[2]], [b_f[3]], alpha=0.8, label=L"b+f", color="purple")

    scatter3d!(p, [b_fA_E[1]], [b_fA_E[2]], [b_fA_E[3]], label=L"proj_{Im(A+E)}(b+f)", alpha=0.8, color="yellow")

    plot!(p, [b_fA_E[1], b_f[1]], [b_fA_E[2], b_f[2]], [b_fA_E[3], b_f[3]], line=(:dash), alpha=0.4, label="", color="yellow")

    err_rel=norm(x-z)/norm(z)

    if last==0
        global last=err_rel
        global last2=dir
    end

    plot!(p2, [(i-1)*c, i*c], [last, err_rel], color="red", label="")
    plot!(p2, [(i-1)*c, i*c], [last2, dir], color="blue", label="")

    global last=err_rel
    global last2=dir

    plot(p, p2)
end
gif(anim, "E_2.gif", fps = 15)