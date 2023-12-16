%prob 5.11
clc
clear
A=0.86;
B=130.2i;
C=0.002i;
D=A;
S2=1000e6;
fdp2=0.8;%ind
U2=500e3;
%
Sb=1000e6;
Ub=500e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%
a=A;
b=B/Zb;
c=C/Yb;
d=D;
%
s2=(S2*fdp2+1i*S2*sin(acos(fdp2)))/Sb;
u2=U2/Ub;
%
i2=conj(s2/u2);
Tlinea=[a b;c d];
ui1=Tlinea*[u2;i2];
disp(['Tensión en extremo emisor= ' num2str(abs(ui1(1))*Ub/1e3) ' kV'])
disp(['Corriente en extremo emisor= ' num2str(abs(ui1(2))*Ib) ' A'])
%
xc=-50i/Zb;
Tc=[1 xc;0 1];
Teq=Tc*Tlinea*Tc%en pu
ui1=Teq*[u2;i2];
disp(['Tensión en extremo emisor= ' num2str(abs(ui1(1))*Ub/1e3) ' kV'])
disp(['Corriente en extremo emisor= ' num2str(abs(ui1(2))*Ib) ' A'])
