%prob 8.5
%Sólo apartado b)
clear
clc
%Bases
Sb=1000e6;
Ub3=20e3;%zona generador 3
Zb3=Ub3^2/Sb;
Ib3=Sb/Ub3/sqrt(3);
Ub2=18e3;%zona generador 2
Zb2=Ub2^2/Sb;
Ib2=Sb/Ub2/sqrt(3);
Ub1=13.8e3;%zona generador 1
Zb1=Ub1^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ub4=500e3;%zona líneas
Zb4=Ub4^2/Sb;
Ib4=Sb/Ub4/sqrt(3);
%
SG1=500e6;
UG1=13.8e3;
xG1=0.2i;
xg1=xG1*(Sb/SG1)*(UG1/Ub1)^2;
SG2=750e6;
UG2=18e3;
xG2=0.18i;
xg2=xG2*(Sb/SG2)*(UG2/Ub2)^2;
SG3=1000e6;
UG3=20e3;
xG3=0.17i;
xg3=xG3*(Sb/SG3)*(UG3/Ub3)^2;
ST1=500e6;
UT1AT=500e3;
xT1=0.12i;
xt1=xT1*(Sb/ST1)*(UT1AT/Ub4)^2;
ST2=750e6;
UT2AT=500e3;
xT2=0.1i;
xt2=xT2*(Sb/ST2)*(UT2AT/Ub4)^2;
ST3=1000e6;
UT3AT=500e3;
xT3=0.1i;
xt3=xT3*(Sb/ST3)*(UT3AT/Ub4)^2;
X12=50i;
x12=X12/Zb4;
X24=50i;
x24=X24/Zb4;
X23=50i;
x23=X23/Zb4;
%Vamos a mantener el mismo número de nudos que indica el enunciado
%Sería más práctico que fuera de 7 nudos
Ydir=[1/(xg1+xt1)+1/x12 -1/x12 0 0;
      -1/x12 1/x12+1/x23+1/x24 -1/x23 -1/x24;
      0 -1/x23 1/x23+1/(xg3+xt3) 0;
      0 -1/x24 0 1/x24+1/(xg2+xt2)];
Zdir=inv(Ydir);
U1=525e3;
u1=U1/Ub4;
%Como se desprecian las corrientes de prefalta, la tensión prefalta en todos los nudos es la misma
v=[0 0 0 0;
u1 u1 u1 u1;
0 0 0 0];%tensiones prefalta en todos los nudos
q=1;%nudo donde se produce el cortocircuito
ifaltafffdir=v(2,q)/Zdir(q,q);
ifaltafff=[0;ifaltafffdir;0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
Ifaltafff=A*ifaltafff;
IFALTAFFF=abs(Ifaltafff)*Ib4/1e3%en kA por fase