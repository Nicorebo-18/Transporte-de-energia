%problema 2.6
clc
clear
%transf Yd
ST=400e6;
UAT=240e3;
UBT=24e3;
ZT=1.2+6i;%Ohm
Scarga=400e6;
fdp=0.8;%inductivo
Ucarga=24e3;
Zlinea=0.6+1.2i;%Ohm
%
Sb=400e6;
Ub2=UBT;
Ub1=UAT;
Zb1=Ub1^2/Sb;
zt=ZT/Zb1;
ucarga=Ucarga/Ub2;
scarga=Scarga/Sb;
pcarga=scarga*fdp;
qcarga=pcarga*tan(acos(fdp));
icarga=conj((pcarga+1i*qcarga)/ucarga);
uprim=ucarga+icarga*zt;
Uprim=abs(uprim)*Ub1/1000%en kV
zlinea=Zlinea/Zb1;
uiniciolinea=uprim+icarga*zlinea;
Uiniciolinea=abs(uiniciolinea)*Ub1/1000%en kV
