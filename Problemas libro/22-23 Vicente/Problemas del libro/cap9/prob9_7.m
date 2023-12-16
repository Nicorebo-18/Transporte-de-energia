%problema 9.7
clear
clc
%Bases
Sb=100e6;
Ub1=20e3;%generador 1
Ub2=20e3;%generador 2
Ub3=220e3;%líneas
Ib3=Sb/Ub3/sqrt(3);
%
xg1=[0.05i;0.15i;0.15i];
xn1=0.25i/3;
xg2=xg1;
xn2=xn1;
xt1=[0.1i;0.1i;0.1i];
xt2=xt1;
x12=[0.3i;0.125i;0.125i];
x13=[0.35i;0.15i;0.15i];
x23=[0.7125i;0.25i;0.25i];
%Para poder calcular cómodamente cualquier cosa, introduzco en bornes de los generadores los nudos 4 y 5
%Aunque no sería necesario para contestar el enunciado del problema.
Yhom=[1/xt1(1)+1/x12(1)+1/x13(1) -1/x12(1) -1/x13(1) -1/xt1(1) 0;
      -1/x12(1) 1/x12(1)+1/x23(1)+1/xt2(1) -1/x23(1) 0 0;
      -1/x13(1) -1/x23(1) 1/x13(1)+1/x23(1) 0 0;
      -1/xt1(1) 0 0 1/xt1(1)+1/(3*xn1+xg1(1)) 0;%No sería necesaria para contestar
      0 0 0 0 1/(3*xn2+xg2(1))];
Ydir=[1/xt1(2)+1/x12(2)+1/x13(2) -1/x12(2) -1/x13(2) -1/xt1(2) 0;
      -1/x12(2) 1/x12(2)+1/x23(2)+1/xt2(2) -1/x23(2) 0 -1/xt2(2);
      -1/x13(2) -1/x23(2) 1/x13(2)+1/x23(2) 0 0;
      -1/xt1(2) 0 0 1/xt1(2)+1/xg1(2) 0;
      0 -1/xt2(2) 0 0 1/xt2(2)+1/xg2(2)];
Yinv=[1/xt1(3)+1/x12(3)+1/x13(3) -1/x12(3) -1/x13(3) -1/xt1(3) 0;
      -1/x12(3) 1/x12(3)+1/x23(3)+1/xt2(3) -1/x23(3) 0 -1/xt2(3);
      -1/x13(3) -1/x23(3) 1/x13(3)+1/x23(3) 0 0;
      -1/xt1(3) 0 0 1/xt1(3)+1/xg1(3) 0;
      0 -1/xt2(3) 0 0 1/xt2(3)+1/xg2(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
q=3;%nudo donde se produce el cortocircuito
zf=0.1i;%reactancia de falta
v=[0 0 0 0 0;
   1 1 1 1 1;
   0 0 0 0 0];%tensiones prefalta en todos los nudos
ifaltadir=v(2,q)/(Zdir(q,q)+Zinv(q,q)+zf);
ifalta=[0;ifaltadir;-ifaltadir];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
IFALTA=abs(A*ifalta)*Ib3/1e3%módulo de las corrientes por fase en kA
ufalta=zeros(3,5);
for m=1:5
  ufalta(:,m)=v(:,m)-diag([Zhom(m,q);Zdir(m,q);Zinv(m,q)])*ifalta;%en componentes simétricas
endfor
%La tensión del nudo 5 calculada no sirve porque hay un transformador YNd11. Hay que corregirla.
ufalta5=ufalta(:,5).*[0;cos(-11*pi/6)+1i*sin(-11*pi/6);cos(11*pi/6)+1i*sin(11*pi/6)];%en componentes simétricas
Ufalta=A*[ufalta(:,1:4) ufalta5];%en p.u. por fase
UFALTA=abs(Ufalta).*[Ub3 Ub3 Ub3 Ub1 Ub2]/1e3/sqrt(3)%módulos de las tensiones fase-neutro de falta en kV por fase
%La corriente de falta por la línea 12 sería
ifalta12=(ufalta(:,1)-ufalta(:,2))./x12;%en componentes simétricas
Ifalta12=A*ifalta12;%en p.u. por fase
IFALTA12=abs(Ifalta12)*Ib3/1e3%en kA por fase