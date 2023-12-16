%prob 2.11
clc
clear
%Datos
UG=12.2e3;
SG=50e6;
xG=0.15i;
%
U1T1=12.2e3;
U2T1=161e3;
ST1=80e6;
xT1=0.1i;
%
ZL23=40+60i;
ZL34=20+80i;
ZL42=20+80i;
%
SCARGA=50e6;
U3=154e3;
FPCARGA=0.8;%ind
P3=SCARGA*FPCARGA;
Q3=SCARGA*sin(acos(FPCARGA));
S3=P3+Q3*1i;
%
Sb=100e6;
UbL=132e3;
%
UbG=UbL*U1T1/U2T1;
ZbL=UbL^2/Sb;
%
xg=xG*(Sb/SG)*(UG/UbG)^2;
xt1=xT1*(Sb/ST1)*(U1T1/UbG)^2;
zl23=ZL23/ZbL;
zl34=ZL34/ZbL;
zl42=ZL42/ZbL;
s3=S3/Sb;
u3=U3/UbL;
%
i3=conj(s3/u3);
zeq=xt1+((zl23+zl34)^-1+(zl42)^-1)^-1;
u1=u3+i3*zeq;
U1=u1*UbG;
disp(['Tensión en bornes del generador 1= ' num2str(abs(U1)/1e3) ' /__' num2str(angle(U1)) ' kV'])
%
zcarga=u3^2/conj(s3);%impedancia equivalente de carga
disp(['Impedancia equivalente serie de carga= ' num2str(zcarga) ' p.u.'])
disp(['Impedancia equivalente serie de carga= ' num2str(zcarga*ZbL) ' Ohm'])
