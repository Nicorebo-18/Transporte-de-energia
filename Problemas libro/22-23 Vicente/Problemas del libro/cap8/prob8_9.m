%problema 8.9
clear
clc
%
xg=0.25i;
xt=0.12i;
xl=0.28i;
xr=0.6i%valor arbitrario de la reactancia de la red que iremos cambiando hasta conseguir que Icc=5 p.u.
%
Ydir=[1/xg+1/(xt+xl) -1/(xt+xl);
      -1/(xt+xl) 1/(xt+xl)+1/xr];
Zdir=inv(Ydir);
q=1;
v=[0 0;1 1;0 0];
ifaltafffdir1=v(2,q)/Zdir(q,q);
ifaltafff1=[0;ifaltafffdir1;0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;1 a^2 a;1 a a^2];
Ifaltafff1=A*ifaltafff1