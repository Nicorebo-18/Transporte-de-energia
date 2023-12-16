%problema 8.7
clear
clc
%Bases
Sb=25e6;
Ub=11e3;
Ib=Sb/Ub/sqrt(3);
Zb=Ub^2/Sb;
%
xg1=0.16i;
xg2=xg1;
xg3=xg1;
xg4=xg1;
%
v=[0 1 0];
ifaltafffsinx=[0;v(2)/((xg1)^-1+(xg2)^-1+(xg3)^-1+(xg4)^-1)^-1;0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
Ifaltafffsinx=A*ifaltafffsinx;
scc=v(2)*conj(Ifaltafffsinx(1));
SCC=abs(scc)*Sb/1e6%en MVA
%
x=0.05333i;%valor arbitrario que habrá que ir cambiando hasta conseguir que la nueva Scc=500 MVA
xeq3y4=((xg3)^-1+(xg4)^-1)^-1;
xeq3y4enserieconx=xeq3y4+x;
xeq1y2=((xg1)^-1+(xg2)^-1)^-1;
xeqtotal=((xeq1y2)^-1+(xeq3y4enserieconx)^-1)^-1;
ifaltafffconx=[0;v(2)/xeqtotal;0];
Ifaltafffconx=A*ifaltafffconx;
sccconx=v(2)*conj(Ifaltafffconx(1));
SCCCONX=abs(sccconx)*Sb/1e6%nueva Scc en MVA
%Una vez conseguido que SCCCONX=500, se calcula x en Ohmios
X=x*Zb%en Ohmios