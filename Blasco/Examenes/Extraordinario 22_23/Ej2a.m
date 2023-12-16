%Ejercicio2 apatardo a Iván Chamorro
clc
clear

%Datos
xg1=[0.06i;0.20i;0.12i]; %homopolar directa inversa
yg1=1./xg1;
xg4=[0.066i;0.33i;0.22i]; %homopolar directa inversa
yg4=1./xg4;

x12=[3*0.0504i;0.0504i;0.0504i]; %homopolar directa inversa
y12=1./x12;
x13=[3*0.0372i;0.0372i;0.0372i]; %homopolar directa inversa
y13=1./x13;
x14=[3*0.0626i;0.0626i;0.0626i]; %homopolar directa inversa
y14=1./x14;
x24=[3*0.0372i;0.0372i;0.0372i]; %homopolar directa inversa
y24=1./x24;
x34=[3*0.0636i;0.0636i;0.0636i]; %homopolar directa inversa
y34=1./x34;

v=[0 0 0 0;
   1 1 1 1;
   0 0 0 0];%se considera tensiones de prefalta 1 p.u

Yhom=[yg1(1)+y12(1)+y13(1)+y14(1) -y12(1) -y13(1) -y14(1);
      -y12(1) y12(1)+y24(1) 0 -y24(1);
      -y13(1) 0 y13(1)+y34(1) -y34(1);
      -y14(1) -y24(1) -y34(1) yg4(1)+y14(1)+y24(1)+y34(1)];

Ydir=[yg1(2)+y12(2)+y13(2)+y14(2) -y12(2) -y13(2) -y14(2);
      -y12(2) y12(2)+y24(2) 0 -y24(2);
      -y13(2) 0 y13(2)+y34(2) -y34(2);
      -y14(2) -y24(2) -y34(2) yg4(2)+y14(2)+y24(2)+y34(2)];

Yinv=[yg1(3)+y12(3)+y13(3)+y14(3) -y12(3) -y13(3) -y14(3);
      -y12(3) y12(3)+y24(3) 0 -y24(3);
      -y13(3) 0 y13(3)+y34(3) -y34(3);
      -y14(3) -y24(3) -y34(3) yg4(3)+y14(3)+y24(3)+y34(3)];

Zhom=inv(Yhom);  
Zdir=inv(Ydir);
Zinv=inv(Yinv);

q=3;
zf=0;

%Cortocicuito fase-fase
ifaltahom=0;
ifaltadir=v(2,q)/(Zdir(q,q)+Zinv(q,q)+zf);
ifaltainv=-ifaltadir;
ifalta=[ifaltahom;ifaltadir;ifaltainv];%en componentes simétricas

a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];

%Tensiones de falta
ufalta=zeros(3,4);
for p=1:4
  ufalta(:,p)=v(:,p)-diag([Zhom(p,q);Zdir(p,q);Zinv(p,q)])*ifalta;
end

%Corrientes de falta: misma corriente en cada extremo de las líneas
ifalta12=(ufalta(:,1)-ufalta(:,2))./x12;%en componentes simétricas
IFalta12=abs(A*ifalta12) %módulo de las corrientes por fase en p.u.

ifalta13=(ufalta(:,1)-ufalta(:,3))./x13;%en componentes simétricas
IFalta13=abs(A*ifalta13) %módulo de las corrientes por fase en p.u.

ifalta14=(ufalta(:,1)-ufalta(:,4))./x14;%en componentes simétricas
IFalta14=abs(A*ifalta14) %módulo de las corrientes por fase en p.u.

ifalta24=(ufalta(:,2)-ufalta(:,4))./x24;%en componentes simétricas
IFalta24=abs(A*ifalta24) %módulo de las corrientes por fase en p.u.

ifalta34=(ufalta(:,3)-ufalta(:,4))./x34;%en componentes simétricas
IFalta34=abs(A*ifalta34) %módulo de las corrientes por fase en p.u.

e=[0;1;0]; %f.e.m del generador 4
ifaltag4=(e-ufalta(:,4))./xg4;%en componentes simétricas
IFaltag4=abs(A*ifaltag4) %módulo de las corrientes por fase en p.u.