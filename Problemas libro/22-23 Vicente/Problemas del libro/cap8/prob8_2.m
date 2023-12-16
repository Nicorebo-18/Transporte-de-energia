%prob 8.2
clear
clc
%Bases
Sb=25e6;
Ub1=66e3;
Zb1=Ub1^2/Sb;%zona línea
Ib1=Sb/Ub1/sqrt(3);
Ub2=11e3;
Zb2=Ub2^2/Sb;%zona generador
Ib2=Sb/Ub2/sqrt(3);
Ub3=6.6e3;
Zb3=Ub3^2/Sb;%zona motores
Ib3=Sb/Ub3/sqrt(3);
%Sólo impedancias directas porque es un cortocircuito trifásico
xg=0.2i;
xt12=0.1i;
x23=0.15i;
xt34=0.1i;
xM1=0.25i;
SM1=5e6;
xm1=xM1*(Sb/SM1);
xM2=xM1;
SM2=SM1;
xm2=xM2*(Sb/SM2);
xM3=xM1;
SM3=SM1;
xm3=xM3*(Sb/SM3);
%
Ydir=[1/xg+1/xt12 -1/xt12 0 0;
      -1/xt12 1/xt12+1/x23 -1/x23 0;
      0 -1/x23 1/x23+1/xt34 -1/xt34;
      0 0 -1/xt34 1/xt34+1/xm1+1/xm2+1/xm3];
Zdir=inv(Ydir);
q=4;
v=[0 0 0 0;
   1 1 1 1;
   0 0 0 0];
ifaltafff4=[0;v(2,q)/Zdir(q,q);0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
Ifaltafff4=A*ifaltafff4;
IFALTAFFF4=abs(Ifaltafff4)*Ib3/1e3%en kA por fase
%
ufalta4=[0;v(2,q)-Zdir(4,4)*ifaltafff4(2);0];%como era de esperar porque es un cortocircuito trifásico franco
%La corriente que pasa por el interruptor B durante el cortocircuito procede del generador y de los motores 1 y 2
e3=[0;1;0];
im3=[0;e3(2)/xm3;0];
Im3=A*im3;
IM3=abs(Im3)*Ib3/1e3;%en kA por fase del motor 3
e2=[0;1;0];
im2=[0;e2(2)/xm2;0];
Im2=A*im2;
IM2=abs(Im2)*Ib3/1e3;%en kA por fase del motor 2
e1=[0;1;0];
im1=[0;e1(2)/xm1;0];
Im1=A*im1;
IM1=abs(Im1)*Ib3/1e3;%en kA por fase del motor 1
ufalta1=[0;v(2,1)-Zdir(1,4)*ifaltafff4(2);0];
eg=[0;1;0];
ig=[0;(eg(2)-ufalta1(2))/xg;0];
Ig=A*ig;
IG=abs(Ig)*Ib2/1e3;%en kA por fase del generador
IB=abs(Im1+Im2+Ig)*Ib3/1e3%en kA por fase por el interruptor B
%La corriente máxima por el interruptor B
IBmax=abs(Im1+Im2+Ig)*2*sqrt(2)*Ib3/1e3%en kA por fase
