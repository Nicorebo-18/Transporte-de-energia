%problema 6.17 del libro
clc
clear
%
global u1 d1 p2 q2 p3 u3 y g%todos los datos que compartan
Sb=100e6
%
%Nudo 1
u1=1.1;
d1=0
%
%Nudo 2
pg2=0;
pd2=1;
p2=pg2-pd2;
qd2=0.4;
qg2=0;
q2=qg2-qd2;
%
%Nudo 3
pg3=0.6;
pd3=0.2;
p3=pg3-pd3;
qd3=0.05;
u3=1.05;
%
%Línea 12
z12=0.03+0.3i;
y12=1/z12;
%Línea 23
z23=0.06+0.2i;
y23=1/z23;
%
Ybus=[y12 -y12 0;-y12 y12+y23 -y23;0 -y23 y23]
%
y=abs(Ybus);
g=angle(Ybus);
x0=[1 1 1 0 1 0];%x=[p1 q1 u2 d2 q3 d3]
x=fsolve(@ec_prob6_17,x0);
%
u=[u1 x(3) u3]
d=[d1 x(4) x(6)]
p=[x(1) p2 p3]
q=[x(2) q2 x(5)]
%
qg3=q(3)+qd3;
disp(['Potencia reactiva del generador 3= ' num2str(qg3*Sb/1e6) ' MVAr'])
