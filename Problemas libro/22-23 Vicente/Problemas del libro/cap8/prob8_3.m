%prob 8.3
%Sólo el apartado a)
clear
clc
%Bases
Sb=1300e6;
Ub1=20e3;
Zb1=Ub1^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ub2=500e3;
Ib2=Sb/Ub2/sqrt(3);
%
xg=0.17i;
xt=0.1i;
e=1;
ifaltafffdir=e/(xg+xt);
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
ifaltafff=[0;ifaltafffdir;0];
Ifaltafff=A*ifaltafff;
IFALTAFFF=abs(Ifaltafff)*Ib2/1e3%en kA por fase