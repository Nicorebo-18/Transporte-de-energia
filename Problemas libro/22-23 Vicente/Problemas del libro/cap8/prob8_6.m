%prob 8.6
%Sólo apartados b) y c)
clear
clc
%Bases
Sb=100e6;
Ub1=138e3;%zona de líneas
Zb1=Ub1^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ub2=10e3;%zona generador 1
Zb2=Ub2^2/Sb;
Ib2=Sb/Ub2/sqrt(3);
Ub3=15e3;%zona generador 2
Zb3=Ub3^2/Sb;
Ib3=Sb/Ub3/sqrt(3);
%Sólo componentes directas porque es un cortocircuito trifásico
SG1=50e6;
UG1=12e3;
xG1=0.2i;
xg1=xG1*(Sb/SG1)*(UG1/Ub2)^2;
SG2=100e6;
UG2=15e3;
xG2=0.2i;
xg2=xG2*(Sb/SG2)*(UG2/Ub3)^2;
ST1=50e6;
UT1AT=138e3;
xT1=0.1i;
xt1=xT1*(Sb/ST1)*(UT1AT/Ub1)^2;
ST2=100e6;
UT2AT=138e3;
xT2=0.1i;
xt2=xT2*(Sb/ST2)*(UT2AT/Ub1)^2;
X23=40i;
x23=X23/Zb1;
X34=40i;
x34=X34/Zb1;
%
Ydir=[1/xg1+1/xt1 -1/xt1 0 0 0;
      -1/xt1 1/xt1+1/x23 -1/x23 0 0;
      0 -1/x23 1/x23+1/x34 -1/x34 0;
      0 0 -1/x34 1/x34+1/xt2 -1/xt2;
      0 0 0 -1/xt2 1/xt2+1/xg2];
Zdir=inv(Ydir);
%
v=[0 0 0 0 0;
1 1 1 1 1;
0 0 0 0 0];%tensiones prefalta (15 kV en nudo 5)
q=5;%nudo donde se produce el cortocircuito
ifaltafffdir=v(2,q)/Zdir(q,q);
ifaltafff=[0;ifaltafffdir;0];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
Ifaltafff=A*ifaltafff;
IFALTAFFF=abs(Ifaltafff)*Ib3/1e3%en kA por fase
%Suponiendo que la f.e.m. del generador 2 es la tensión nominal
e=v(2,q);
ig=e/xg2;
ifaltafffg2=[0;ig;0];%en componentes simétricas
Ifaltafffg2=A*ifaltafffg2;
IFALTAFFFG2=abs(Ifaltafffg2)*Ib3/1e3%corriente de falta desde el generador 2 en kA por fase
Ifaltaffft2=Ifaltafff-Ifaltafffg2;
IFALTAFFFT2=abs(Ifaltaffft2)*Ib3/1e3%corriente de falta desde el transformador 2 en kA por fase
