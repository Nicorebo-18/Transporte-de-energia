%prob 8.4
%Se calcula igual que el 8.3 pero la E del generador será distinta.
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
u=1;%tensión en bornes del generador prefalta (componente directa)
fdp=0.8;%ind
sg=fdp+1i*fdp*tan(acos(fdp));
ig=conj(sg/u);
eg=u+ig*xg;%f.e.m. del generador prefalta (componente directa)
ifaltafffdir=eg/(xg+xt);
ifaltafff=[0;ifaltafffdir;0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
ifaltafff=[0;ifaltafffdir;0];
Ifaltafff=A*ifaltafff;
IFALTAFFF=abs(Ifaltafff)*Ib2/1e3%en kA por fase
