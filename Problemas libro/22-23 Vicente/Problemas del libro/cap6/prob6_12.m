%prob 6.12
%X=1; Y=2; Z=3
clear
clc
global u1 d1 p2 q2 p3 u3 y g
Sb=100e6;
Ub=220e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
Y12=25e-3i;
Y23=37.5e-3i;
Y13=30e-3i;
U1=220e3;
U3=242e3;
PD1=200e6;
QD1=0;
PD2=250e6;
QD2=80e6;
QG2=200e6;
PD3=0;
QD3=0;
PG3=200e6;
%
y12=Y12/Yb;
y23=Y23/Yb;
y13=Y13/Yb;
u1=U1/Ub;
d1=0;
u3=U3/Ub;
pd1=PD1/Sb;
qd1=QD1/Sb;
pd2=PD2/Sb;
pg2=0;
qd2=QD2/Sb;
qg2=QG2/Sb;
pd3=PD3/Sb;
pg3=PG3/Sb;
qd3=QD3/Sb;
%
p2=pg2-pd2;
q2=qg2-qd2;
p3=pg3-pd3;
%
Ybus=[y13+y12 -y12 -y13;
      -y12 y12+y23 -y23;
      -y13 -y23 y23+y13];
y=abs(Ybus);
g=angle(Ybus);
z=[1 1 1 0 0 1];%[p1 q1 u2 d2 d3 q3]
x=fsolve(@PV,z);
u=[u1 x(3) u3];
d=[d1 x(4) x(5)];
p=[x(1) p2 p3];
q=[x(2) q2 x(6)];
%
qg1=q(1)+qd1;
qg3=q(3)+qd3;
%
disp(['Tensión en nudo X= ' num2str(u(1)*Ub/1e3) ' kV /__' num2str(d(1)) ' rad'])
disp(['Tensión en nudo Y= ' num2str(u(2)*Ub/1e3) ' kV /__' num2str(d(2)) ' rad'])
disp(['Tensión en nudo Z= ' num2str(u(3)*Ub/1e3) ' kV /__' num2str(d(3)) ' rad'])
disp(['Reactiva generada en X= ' num2str(qg1*Sb/1e6) ' MVAr'])
disp(['Reactiva generada en Z= ' num2str(qg3*Sb/1e6) ' MVAr'])