%prob 3.4
clc
clear
%datos
XG=9i;
U=30e3;
SG=50e6;
Sb=SG;
UG=30e3;
Ub=UG;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
xg=XG/Zb;
PG=40e6;
pg=PG/Sb;
ug=UG/Ub;
%condiciones iniciales del prob 3.3
fdp0=0.8;%ind
sg=SG/Sb;
s0=sg*fdp0+sg*sin(acos(fdp0))*i;
i0=conj(s0/ug);
e0=ug+i0*xg;
%
modeg1=0.792*abs(e0);
deltag1=asin(pg*abs(xg)/modeg1/ug)
eg1=modeg1*cos(deltag1)+modeg1*sin(deltag1)*1i;
ig1=(eg1-ug)/xg%en pu
IG1=abs(ig1)*Ib%módulo en A
fdpg1=cos(angle(ug*conj(ig1)))
if imag(ig1)>0
  disp(['cap'])
  endif
%
modeg2=0.5927*abs(e0);%la otra pregunta igual pero con 0,5927 en vez de 0,792
deltag2=asin(pg*abs(xg)/modeg2/ug)
eg2=modeg2*cos(deltag2)+modeg2*sin(deltag2)*1i;
ig2=(eg2-ug)/xg%en pu
IG2=abs(ig2)*Ib%módulo en A
fdpg2=cos(angle(ug*conj(ig2)))
if imag(ig2)>0
  disp(['cap'])
  endif
%
e=pg*abs(xg)/ug/sin(pi/2);
iex=e/abs(e0);
disp(['Corriente de excitación mínima= ' num2str(100*iex) '% de la inicial'])
