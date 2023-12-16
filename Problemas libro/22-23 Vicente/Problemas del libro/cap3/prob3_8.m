%prob 3.8
clc
clear
%datos
SG=50e6;
UG=10e3;
xG=1.65;
rG=0.1;
U=UG;
MODI=2e3;
fdp=0.9;%cap
%bases
Ub=UG;
Sb=SG;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
%valores en pu
sg=SG/Sb;
ug=UG/Ub;
u=U/Ub;
zg=(rG+xG*i)*(UG/Ub)^2*(Sb/SG);
ig=MODI*fdp/Ib+MODI*sin(acos(fdp))*i/Ib;
%a) calcular E y delta
s=u*conj(ig);
e=u+ig*zg;
disp(['delta= ' num2str(angle(e)) ' rad'])
disp(['|E|= ' num2str(abs(e)*Ub/1e3) ' kV'])
%b) tensión en vacío
disp(['La tensión en vacío es |E|= ' num2str(abs(e)*Ub/1e3) ' kV'])
%c) Icc?
icc=e/zg%en pu
ICC=abs(icc)*Ib/1e3;%en kA
disp(['Corriente de cortocircuito= ' num2str(ICC) ' kA'])
