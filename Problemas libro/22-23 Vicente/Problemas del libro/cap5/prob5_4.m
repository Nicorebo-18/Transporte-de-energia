%Problema 5.4
clear
clc
%Bases iniciales
Ub=220e3;
Sb=100e6;
%Bases derivadas
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%
f=50;
long=300e3;
Z=40+25i;%Ohmios
B=1e-3i;%Siemens
P2=50e6;%W
fdp2=0.8;%inductivo
U2=220e3;
%
z=Z/Zb;
y=B/Yb;
p2=P2/Sb;
u2=U2/Ub;
%
phi=acos(fdp2);
q2=p2*tan(phi);
s2=p2+1i*q2;
i2=conj(s2/u2);
%
zu=z/long;
yu=y/long;
zc=sqrt(zu/yu);
gamma=sqrt(zu*yu);
%
%soluciones linea corta
disp(['Línea modelada como corta'])
u1=u2+i2*z;
i1=i2;
U1corta=abs(u1)*Ub/1e3
I1corta=abs(i1)*Ib
s1=u1*conj(i1);
fdpcorta=cos(angle(s1))
if imag(s1)<0
  disp(['en adelanto'])
else
  disp(['en retraso'])
endif
%soluciones línea media
disp(['Línea modelada como media'])
u1=(1+z*y/2)*u2+z*i2;
i1=y*(1+z*y/4)*u2+(1+z*y/2)*i2;
U1media=abs(u1)*Ub/1e3
I1media=abs(i1)*Ib
s1=u1*conj(i1);
fdpmedia=cos(angle(s1))
if imag(s1)<0
  disp(['en adelanto'])
else
  disp(['en retraso'])
endif
%soluciones linea larga
disp(['Línea modelada como larga'])
u1=u2*cosh(gamma*long)+zc*sinh(gamma*long)*i2;
i1=sinh(gamma*long)*u2/zc+i2*cosh(gamma*long);
U1larga=abs(u1)*Ub/1e3
I1larga=abs(i1)*Ib
s1=u1*conj(i1);
fdplarga=cos(angle(s1))
if imag(s1)<0
  disp(['en adelanto'])
else
  disp(['en retraso'])
endif
