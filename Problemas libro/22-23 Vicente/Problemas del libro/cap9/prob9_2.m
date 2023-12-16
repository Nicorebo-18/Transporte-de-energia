%problema 9.2
clear
clc
xg1=[0.08i;0.15i;0.15i];%reactancias homopolar, directa e inversa del generador 1
xg2=[inf;0.25i;0.25i];
xt1=[0.15i;0.15i;0.15i];
x23=[0.4i;0.2i;0.2i];
xt2=xt1;
xg3=[0.05i;0.15i;0.15i];
Yhom=[1/xg1(1) 0 0 0;
      0 1/xt1(1)+1/x23(1) -1/x23(1) 0;
      0 -1/x23(1) 1/x23(1)+1/xt2(1) 0;
      0 0 0 1/xg3(1)];
Ydir=[1/xg1(2)+1/xg2(2)+1/xt1(2) -1/xt1(2) 0 0;
      -1/xt1(2) 1/xt1(2)+1/x23(2) -1/x23(2) 0;
      0 -1/x23(2) 1/x23(2)+1/xt2(2) -1/xt2(2);
      0 0 -1/xt2(2) 1/xt2(2)+1/xg3(2)];
Yinv=[1/xg1(3)+1/xg2(3)+1/xt1(3) -1/xt1(3) 0 0;
      -1/xt1(3) 1/xt1(3)+1/x23(3) -1/x23(3) 0;
      0 -1/x23(3) 1/x23(3)+1/xt2(3) -1/xt2(3);
      0 0 -1/xt2(3) 1/xt2(3)+1/xg3(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
q=2;%nudo donde se produce el cortocircuito
v=[0 0 0 0;
   1 1 1 1;
   0 0 0 0];%tensiones prefalta en todos los nudos
ifaltahom=v(2,q)/(Zhom(q,q)+Zdir(q,q)+Zinv(q,q));
ifalta=[ifaltahom;ifaltahom;ifaltahom];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
Ifalta=A*ifalta;%en p.u. por fase
IFALTA=abs(Ifalta)%módulo de las corrientes por fase en p.u.
%Para calcular la corriente por el transformador 1, tenemos que calcular las tensiones de falta
ufalta=zeros(3,4);
for m=1:4
  ufalta(:,m)=v(:,m)-diag([Zhom(m,q);Zdir(m,q);Zinv(m,q)])*ifalta;
endfor
%y calcular la corriente de falta que circula por la línea 23
ifalta23=(ufalta(:,3)-ufalta(:,2))./x23;%en componentes simétricas
%La corriente por el lado de AT del transformador 1 será:
ifaltaAT1=ifalta-ifalta23;%en componentes simétricas
IfaltaAT1=A*ifaltaAT1;%en p.u. por fase
IFALTAAT1=abs(IfaltaAT1)%módulo de las corrientes por fase en p.u.
%La corriente por el lado de BT del transformador 1 será (suponiendo que su índice horario sea 11):
ifaltaBT1=ifaltaAT1.*[0;cos(-11*pi/6)+1i*sin(-11*pi/6);cos(11*pi/6)+1i*sin(11*pi/6)];%en componentes simétricas
IfaltaBT1=A*ifaltaBT1;%en p.u. por fase
IFALTABT1=abs(IfaltaBT1)%módulo de las corrientes por fase en p.u.
