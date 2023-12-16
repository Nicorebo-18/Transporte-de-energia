%problema 2.8
clc
clear
%
ST=40e6;
U2=400e3;
U1=20e3;
Z1=0.9+1.8i;
Z2=128+288i;
%
Sb=ST;
Ub1=U1;
Zb1=Ub1^2/Sb;
z1=Z1/Zb1;
Ub2=U2;
Zb2=Ub2^2/Sb;
z2=Z2/Zb2;
zt=z1+z2
