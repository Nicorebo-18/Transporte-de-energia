clc
clear
%problema 2.4 del libro
SG=90e6;
UG=22e3;
xG=0.18i;
ST1=50e6;
U1T1=22e3;
U2T1=220e3;
xT1=0.1i;
ST2=40e6;
U1T2=220e3;
U2T2=11e3;
xT2=0.06i;
ST3=40e6;
U1T3=22e3;
U2T3=110e3;
xT3=0.064i;
ST4=40e6;
U1T4=110e3;
U2T4=11e3;
xT4=0.08i;
SM=66.5e6;
UM=10.45e3;
xM=.185i;
Scarga=57e6;
fdpcarga=0.6;%retraso
Ucarga=10.45e3;
XL1=48.4i;
XL2=64.43i;
fdpmotor=0.8;%adelanto
%
UbG=22e3;
Sb=100e6;
UbL1=UbG*U2T1/U1T1;
ZbL1=UbL1^2/Sb;
UbL2=UbG*U2T3/U1T3;
ZbL2=UbL2^2/Sb;
UbM=UbL1*U2T2/U1T2;
%
xg=xG*(Sb/SG)*(UG/UbG)^2;
xt1=xT1*(Sb/ST1)*(U1T1/UbG)^2;
xt2=xT2*(Sb/ST2)*(U1T2/UbL1)^2;
xt3=xT3*(Sb/ST3)*(U1T3/UbG)^2;
xt4=xT4*(Sb/ST4)*(U1T4/UbL2)^2;
xl1=XL1/ZbL1;
xl2=XL2/ZbL2;
xm=xM*(Sb/SM)*(UM/UbM)^2;
%
sm=SM/Sb;
um=UM/UbM;
im=conj((sm*cos(acos(fdpmotor))-1i*sm*sin(acos(fdpmotor)))/um);
scarga=Scarga/Sb;
icarga=conj((scarga*cos(acos(fdpcarga))+1i*scarga*sin(acos(fdpcarga)))/um);
itotal=im+icarga;
x14=xt1+xl1+xt2;
x16=xt3+xl2+xt4;
xeq14=(x14^-1+x16^-1)^-1;
u1=um+itotal*xeq14;%resultado en pu
U1=abs(u1)*UbG
%
eg=u1+itotal*xg;%resultado en pu
Eg=abs(eg)*UbG
%
em=um-im*xm;
Em=abs(em)*UbM
