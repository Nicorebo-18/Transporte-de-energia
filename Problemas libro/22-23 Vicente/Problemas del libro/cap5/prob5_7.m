%problema 5.7
clc
clear
%
R=3;%Ohm
X=10;%Ohm
P2=2e6;%W
fdp=0.85;%ind
U2=11e3;%V
QC=2.1e6;%VAr
%
Sb=P2;
Ub=U2;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
%
z=(R+X*1i)/Zb;
p2=P2/Sb;
q2=p2*tan(acos(fdp));
qc=QC/Sb;
s2=p2+(q2-qc)*1i;
u2=U2/Ub;
i2=conj(s2/u2);
%
u1=u2+i2*z;
U1=abs(u1)*Ub/1e3
s1=u1*conj(i2);
fdp=cos(angle(s1))
if imag(s1)<0
  disp(['en adelanto'])
else
  disp(['en retraso'])
endif
%
u20=u1;
disp(['Regulación= ' num2str(100*(abs(u20)-abs(u2))/abs(u2)) ' %'])
%
disp(['Rendimiento= ' num2str(100*real(s2)/real(s1)) ' %'])
