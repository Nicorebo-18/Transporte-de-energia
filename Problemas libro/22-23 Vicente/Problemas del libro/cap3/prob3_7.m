%prob 3.7
clc
clear
%datos
SG=24000e3;
UG=17.32e3;
XG=5i;
%bases
Sb=SG;
Ub=UG;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
%valores en pu
sg=SG/Sb;
ug=UG/Ub;
xg=XG/Zb;
%a)datos
fdp=0.8;%ind
s=sg*fdp+sg*sin(acos(fdp))*i;
ig=conj(s/ug);
e=ug+ig*xg%en pu
disp(['E= ' num2str(abs(e)*Ub/1e3) ' /___' num2str(angle(e)) ' kV'])
%b)datos
e1=13.4e3*sqrt(3)/Ub;
u1=10e3*sqrt(3)/Ub;
delta1=pi/2;
pmax=e1*u1/abs(xg)%en pu
PMAX=pmax*Sb/1e6%en MW
%c)
q1=e1*u1*cos(delta1)/abs(xg)-u1^2/abs(xg);
i1=conj((pmax+q1*i)/u1)%en pu
disp(['I= ' num2str(abs(i1)*Ib) ' /___' num2str(angle(i1)) ' A'])