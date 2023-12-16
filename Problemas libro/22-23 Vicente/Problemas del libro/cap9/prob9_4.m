%problema 9.3
clear
clc
%Bases
Sb=10000e3;
Ub1=6.9e3;
Zb1=Ub1^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ub2=44e3;
Ib2=Sb/Ub2/sqrt(3);
%
xg=[0.05i;0.15i;0.15i];
xt=[0.075i;0.075i;0.075i];
h=11;%índice horario del transformador
XN=0.381i;%Ohmios referidos a las bases propias del generador
xn=XN/Zb1;
%
Yhom=[1/(3*xn+xg(1)) 0;
      0 1/xt(1)];
Ydir=[1/xg(2)+1/xt(2) -1/xt(2);
      -1/xt(2) 1/xt(2)];
Yinv=[1/xg(3)+1/xt(3) -1/xt(3);
      -1/xt(3) 1/xt(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
q=2;%nudo donde se produce el cortocircuito
v=[0 0;
   1 1;
   0 0];%tensiones prefalta en todos los nudos
ifaltahom=v(2,q)/(Zhom(q,q)+Zdir(q,q)+Zinv(q,q));
ifalta=[ifaltahom;ifaltahom;ifaltahom];%en componentes simétricas
%Esta corriente de falta es la que circula por el lado de AT del transformador
%La corriente por el lado de BT sería:
ifaltaBT=ifalta.*[0;cos(-h*pi/6)+1i*sin(-h*pi/6);cos(h*pi/6)+1i*sin(h*pi/6)];%en componentes simétricas
%Esta corriente también es la que circula por el generador
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
IfaltaBT=A*ifaltaBT;%en p.u. por fase
IFALTAG=abs(IfaltaBT)*Ib1/1e3%módulo de las corrientes en kA por fase