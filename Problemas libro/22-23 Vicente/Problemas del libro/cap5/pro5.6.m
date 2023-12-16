%prob5.6
clear
clc
%datos
mod_A=0.93;
arg_A=1.5*pi/180;
mod_B=115;
arg_B=77*pi/180;
A=mod_A*cos(arg_A)+1i*mod_A*sin(arg_A);
B=mod_B*cos(arg_B)+1i*mod_B*sin(arg_B);
U2=275e3;
P2=250e6;
fdp2=0.85;%ind
%
Sb=250e6;
Ub=275e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%
GAMMA_L=acosh(A);
ZC=B/sinh(GAMMA_L);
zc=ZC/Zb;
%
a=A;
b=zc*sinh(GAMMA_L);
%
u2=U2/Ub;
p2=P2/Sb;
q2=p2*tan(acos(fdp2));
s2=p2+1i*q2;
i2=conj(s2/u2);
u1=a*u2+b*i2;
U1=abs(u1)*Ub/1e3;
disp(['|U1|= ' num2str(U1) ' kV'])
%
u1=295e3/Ub;
z=b;
theta=angle(z);
y_2=tanh(GAMMA_L/2)/zc;
psi=angle(y_2);
delta=theta;
p2=abs(u1)*abs(u2)*cos(theta-delta)/abs(z)-abs(u2)^2*cos(theta)/abs(z)-abs(u2)^2*cos(-psi)*abs(y_2);
P2max=p2*Sb/1e6;
disp(['P2 máxima= ' num2str(P2max) ' MW'])
%
s2aparente=400e6/Sb;
fdp2=0.8;%ind
q=-1.2354;
s2=s2aparente*fdp2+1i*(s2aparente*sin(acos(fdp2))+q);
i2=conj(s2/u2);
u1=a*u2+b*i2;
U1=abs(u1)*Ub/1e3
Q=q*Sb/1e6









