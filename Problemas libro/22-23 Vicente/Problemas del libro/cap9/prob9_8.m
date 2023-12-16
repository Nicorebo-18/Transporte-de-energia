%problema 9.8
%Para determinar la reactancia X hay que calcular cuál es la máxima corriente cuando se produce un cortocircuito
%en la salida del interruptor M
clear
clc
%Bases
Sb=10e6;
Ub=50e3;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
%
xg1=[0.05i;0.1i;0.1i];
XN1=15i;%Ohmios
xn1=XN1/Zb;
xg2=xg1;
xn2=xn1;
xg3=xg1;
xg4=xg1;
xG5=[0.05i;0.1i;0.1i];%referidas a las bases propias del generador 5
SG5=50e6;
XN5=10i;%Ohmios
xn5=XN5/Zb;
xg5=xG5*(Sb/SG5);
%En un cortocircuito trifásico la única corriente que circula es la directa
%La reactancia que limita el valor de esta corriente es la combinación en paralelo de
%todas las reactancias de los generadores
x=0.080005i;%valor arbitrario de la reactancia X en p.u. para hacer cálculos iterativos
%Debe ser cambiado hasta que scc<=sccmax
xeqdir=((xg1(2))^-1+(xg2(2))^-1+(xg3(2))^-1+(xg4(2))^-1+(xg5(2)+x)^-1)^-1;
v=[0;1;0];%tensión prefalta
ifaltadirfff=v(2)/xeqdir;
ifaltafff=[0;ifaltadirfff;0];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
Ifaltafff=A*ifaltafff;%en p.u. por fase
IFALTAFFF=abs(Ifaltafff)*Ib%en A por fase
%En un cortocircuito fase-tierra, todas las corrientes de secuencia son iguales.
%Suponemos que la reactancia homopolar de la reactancia X es 3 veces la directa y que la inversa es igual que la directa
xeqhom=((xg1(1)+3*xn1)^-1+(xg2(1)+3*xn2)^-1+(xg5(1)+3*xn5+3*x)^-1)^-1;
xeqinv=((xg1(3))^-1+(xg2(3))^-1+(xg3(3))^-1+(xg4(3))^-1+(xg5(3)+x)^-1)^-1;
ifaltahomft=v(2)/(xeqhom+xeqdir+xeqinv);
ifaltaft=[ifaltahomft;ifaltahomft;ifaltahomft];%en componentes simétricas
Ifaltaft=A*ifaltaft;%en p.u. por fase
IFALTAFT=abs(Ifaltaft)*Ib%en A por fase
%En un cortocircuito fase-fase, la corriente inversa es la directa cambiada de signo y la homopolar es nula.
ifaltadirff=v(2)/(xeqdir+xeqinv);
ifaltainvff=-ifaltadirff;
ifaltaff=[0;ifaltadirff;ifaltainvff];%en componentes simétricas
Ifaltaff=A*ifaltaff;%en p.u. por fase
IFALTAFF=abs(Ifaltaff)*Ib%en A por fase
%En un cortocircuito fase-fase-tierra
ifaltadirfft=v(2)/(xeqdir+xeqinv*xeqhom/(xeqinv+xeqhom));
ifaltahomfft=-ifaltadirfft*xeqinv/(xeqinv+xeqhom);
ifaltainvfft=-ifaltadirfft*xeqhom/(xeqinv+xeqhom);
ifaltafft=[ifaltahomft;ifaltadirfft;ifaltainvfft];%en componentes simétricas
Ifaltafft=A*ifaltafft;%en p.u. por fase
IFALTAFFT=abs(Ifaltafft)*Ib%en A por fase
%El mayor cortocircuito es el trifásico
%La potencia de cortocircuito será:
scc=v(2)*abs(Ifaltafff(2))%en p.u. por fase
%Tiene que ser menor o igual que sccmax
SCCMAX=500e6;%potencia de ruptura del interruptor M en VA
sccmax=SCCMAX/Sb%en p.u.
%Se va cambiando x hasta lograrlo.
X=x*Zb%en Ohmios
%La corriente por cada fase en el generador 2 sería
ufalta=v-diag([xeqhom;xeqdir;xeqinv])*ifaltaft;%en componentes simétricas
e=v;%suponemos que en el instante del cortocircuito la f.e.m. del generador es igual a la tensión prefalta
ifaltag2=(e-ufalta)./[xg2(1)+3*xn2;xg2(2);xg2(3)];%en componentes simétricas
Ifaltag2=A*ifaltag2;%en p.u. por fase
IFALTAG2=Ifaltag2*Ib%corrientes por fase en A en el generador 2
