%problema 2.5
clc
clear
ST=9e6;%VA
UAT=7.2e3;%V
UBT=4.16e3;%V
%Yd
ZT=0.12+0.82i;%Ohm
Scarga=18e6;%VA
fdp=0.8;%ind
Ucarga=4.16e3;%V
%Uprimario?
Sb=ST;
Ub1=UAT*sqrt(3);%por estar en estrella
Zb1=Ub1^2/Sb;
zt=ZT/Zb1;
Ub2=Ub1*UBT/UAT/sqrt(3);
ucarga=Ucarga/Ub2;
scarga=Scarga/Sb;
pcarga=scarga*fdp;
qcarga=pcarga*tan(acos(fdp));
icarga=conj((pcarga+1i*qcarga)/ucarga);
%
uprim=ucarga+icarga*zt;
Uprim=abs(uprim)*Ub1/1000%en kV
