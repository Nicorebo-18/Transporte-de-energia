%prob 5.2
clc
clear
%Datos
long=250e3;%m
f=50;%Hz
SCARGA=25e6;%VA
FP2=0.8;%en retraso
S2=SCARGA*FP2+1i*SCARGA*sin(acos(FP2));
U2=132e3;%V
%Línea simétrica
D=3;%m
Rc=0.11/1000;%Ohm/m
diam=1.6e-2;%m
%Parámetros característicos de la línea
eps0=(4e-7*pi*299792458^2)^-1;
Ru=Rc;%Ohm/m
Lu=2e-7*log(D/(diam/2)/exp(-0.25));%H/m
Cu=2*pi*eps0/log(D/(diam/2));%F/m
Zu=Ru+2i*pi*f*Lu;%Ohm/m
Yu=2i*pi*f*Cu;%S/m
Z=Zu*long;
Y=Yu*long;
%Bases
Sb=SCARGA;
Ub=132e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%Conversión a pu
s2=S2/Sb;
u2=U2/Ub;
z=Z/Zb;
y=Y/Yb;
%Matriz de transmisión
T=[1+z*y/2 z;y*(1+z*y/4) 1+z*y/2];
%
i2=conj(s2/u2);
%Solución apartado a
u1i1=T*[u2;i2];
U1=u1i1(1)*Ub;
disp(['U1= ' num2str(abs(U1)/1e3) ' /__ ' num2str(angle(U1)) ' kV'])
%Solución apartado b
u20=u1i1(1)/T(1);
reg=(abs(u20)-abs(u2))/abs(u2);
disp(['Regulación de tensión= ' num2str(reg*100) ' %'])
