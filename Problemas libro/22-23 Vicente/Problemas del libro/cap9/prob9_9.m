%problema 9.9
clear
clc
%Bases
Sb=500e6;
Ub=22e3;
Zb=Ub^2/Sb;
%
xg=[0.05i;0.15i;0.15i];
xn=0.033333i;%ir cambiando el valor hasta que Ifaltaft=Ifaltafff
v=[0;0.9;0];%tensión prefalta en componentes simétricas
ifaltadirfff=v(2)/xg(2);
ifaltafff=[0;ifaltadirfff;0];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
Ifaltafff=abs(A*ifaltafff)%módulo de las corrientes por fase en p.u.
ifaltadirft=v(2)/(xg(2)+xg(3)+xg(1)+3*xn);
ifaltaft=[ifaltadirft;ifaltadirft;ifaltadirft];%en componentes simétricas
Ifaltaft=abs(A*ifaltaft)%corrientes de falta por fase en p.u.
%La relación pedida es la relación entre la corriente de la fase a en cortocircuito trifásico y
%la corriente de la fase a en cortocircuito fase-tierra cuando xn=0i
XN=xn*Zb%en Ohmios