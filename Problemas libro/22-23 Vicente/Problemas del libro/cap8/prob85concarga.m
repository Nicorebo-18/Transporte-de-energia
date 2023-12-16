%prob 8.5 teniendo en cuenta carga previa y las impedancias de carga
clc
clear
global u1 d1 p2 q2 p3 u3 p4 u4 y g
%Bases
Sb=1000e6;
Ub1=13.8e3;
Ub2=500e3;
Ub3=20e3;
Ub4=18e3;
Zb2=Ub2^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ib2=Sb/Ub2/sqrt(3);
Ib3=Sb/Ub3/sqrt(3);
Ib4=Sb/Ub4/sqrt(3);
%Datos generador nudo 1
Snomg1=500e6;
Unomg1=13.8e3;
xg1=0.2i*(Sb/Snomg1)*(Unomg1/Ub1)^2;
%Datos transf nudo 1
Snomt1=500e6;
Unomprimt1=13.8e3;
Unomsect1=500e3;
xt1=0.12i*(Sb/Snomt1)*(Unomprimt1/Ub1)^2;
%Datos líneas
x12=50i/Zb2;
x23=x12;
x24=x12;
%Datos transf nudo 3
Snomt3=1000e6;
Unomprimt3=20e3;
Unomsect3=500e6;
xt3=0.1i*(Sb/Snomt3)*(Unomprimt3/Ub3)^2;
%Datos generador nudo 3
Snomg3=1000e6;
Unomg3=20e3;
xg3=0.17i*(Sb/Snomg3)*(Unomg3/Ub3)^2;
%Datos transf nudo 4
Snomt4=750e6;
Unomprimt4=18e3;
Unomsect4=500e3;
xt4=0.1i*(Sb/Snomt4)*(Unomprimt4/Ub4)^2;
%Datos generador nudo 4
Snomg4=750e6;
Unomg4=18e3;
xg4=0.18i*(Sb/Snomg4)*(Unomg4/Ub4)^2;
%Resolución flujo de cargas
%Datos nudo 1
u1=525e3/Ub2;
d1=0;
sd1=0.1+0.05i;
%Datos nudo 2
sd2=0.2+0.1i;
sg2=0;
p2=real(sg2-sd2);
q2=imag(sg2-sd2);
%Datos nudo 3
u3=525e3/Ub2;
sd3=0.8+0.2i;
pg3=0.5;
p3=pg3-real(sd3);
%Datos nudo 4
u4=525e3/Ub2;
sd4=0.3+0.2i;
pg4=0.3;
p4=pg4-real(sd4);
%Suponemos los transformadores integrados en los generadores
Ybus=[1/x12 -1/x12 0 0;
-1/x12 1/x12+1/x23+1/x24 -1/x23 -1/x24;
0 -1/x23 1/x23 0;
0 -1/x24 0 1/x24];
y=abs(Ybus);
g=angle(Ybus);
%
x0=[1 1 1 0 1 0 1 0];%x=[p1 q1 u2 d2 q3 d3 q4 d4]
x=fsolve(@ec_prob8_5_concarga,x0);
u=[u1 x(3) u3 u4];
d=[d1 x(4) x(6) x(8)];
p=[x(1) p2 p3 p4];
q=[x(2) q2 x(5) x(7)];
v=u.*cos(d)+1i*u.*sin(d);
s=p+1i*q;
%Impedancias equivalentes de las cargas
zd1=u(1)^2/conj(sd1);
zd2=u(2)^2/conj(sd2);
zd3=u(3)^2/conj(sd3);
zd4=u(4)^2/conj(sd4);
%
Ydir=[1/(xg1+xt1)+1/x12+1/zd1 -1/x12 0 0;
-1/x12 1/x12+1/x23+1/x24+1/zd2 -1/x23 -1/x24;
0 -1/x23 1/x23+1/(xg3+xt3)+1/zd3 0;
0 -1/x24 0 1/x24+1/(xg4+xt4)+1/zd4];
Zdir=inv(Ydir);
%cortocircuito trifásico en nudo 1
%
%fem generador 1
sg1=s(1)+sd1;
i1=conj(sg1/v(1));
e1=v(1)+i1*(xg1+xt1);
%
i1fallo=e1/Zdir(1,1);%en pu
I1fallo=i1fallo*Ib2/1000;%en kA
disp(['Corriente de falta: ' num2str(abs(I1fallo)) ' kA'])
%
