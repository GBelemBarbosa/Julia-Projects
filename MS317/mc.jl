cIni=200000
mFin=307600

mc=mFin/cIni

jc(j, n)=(1+j)^n

sol(j1, j2, n, mFin)=log(mFin/jc(j2, n))/log(jc(j1, 1)/jc(j2, 1))

sol(4/100, 5/100, 10, mc)

G(m, j1, j2, x)=(x<m)*jc(j1, x)+(x>=m)*jc(j1, m)*jc(j2, x-m)

G(6, 4/100, 5/100, 10)*cIni

t=1:10
T=[t, G(t, 4/100, 5/100, 10)]