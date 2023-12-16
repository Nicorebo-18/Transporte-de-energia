%prob6.16
clc
clear
global u1 d1 p2 u2 p3 q3 p4 q4 y g
u1=1;
d1=0;
pd2=0.2;
qd2=0.15;
pg2=0.5;
p2=pg2-pd2;
u2=1;
p3=0;
q3=0;
pd4=1;
qd4=0.75;
pg4=0;
qg4=0;
p4=pg4-pd4;
q4=qg4-qd4;
%
Ub=220e3;
Sb=100e6;
Zb=Ub^2/Sb;
Yb=1/Zb;
Zu=(0.0721+0.4232i)/1e3;
Yu=2.693e-9i/1e3/2;
long12=100e3;
long13=200e3;
long23=150e3;
z12=(Zu*long12)/Zb;
y012=(Yu*long12)/Yb;
z13=(Zu*long13)/Zb;
y013=(Yu*long13)/Yb;
z23=(Zu*long23)/Zb;
y023=(Yu*long23)/Yb;
xT=0.1i;
xt=xT*(220e3/Ub)^2*(Sb/150e6);
yt=1/xt;
t=0.9428;
yt33=yt/t^2;
yt34=yt/t;
yt43=yt/t;
yt44=yt;
%
Ybus=[1/z12+1/z13+y012+y013 -1/z12 -1/z13 0;
-1/z12 1/z12+1/z23+y012+y023 -1/z23 0;
-1/z13 -1/z23 1/z13+1/z23+yt33+y013+y023 -yt34;
0 0 -yt43 yt44];
y=abs(Ybus);
g=angle(Ybus);
x0=[1 1 1 0 1 0 1 0];%x=[p1 q1 q2 d2 u3 d3 u4 d4]
x=fsolve(@ec_prob6_16,x0);
u=[u1 u2 x(5) x(7)]
d=[d1 x(4) x(6) x(8)]
p=[x(1) p2 p3 p4]
q=[x(2) x(3) q3 q4]
v=u.*cos(d)+1i*u.*sin(d);
%flujos de potencia en las líneas
i12=(v(1)-v(2))*(1/z12)+v(1)*y012;
i21=(v(2)-v(1))*(1/z12)+v(2)*y012;
s12=v(1)*conj(i12)
s21=v(2)*conj(i21)
perd12=s12+s21
i13=(v(1)-v(3))*(1/z13)+v(1)*y013;
i31=(v(3)-v(1))*(1/z13)+v(3)*y013;
s13=v(1)*conj(i13)
s31=v(3)*conj(i31)
perd13=s13+s31
i23=(v(2)-v(3))*(1/z23)+v(2)*y023;
i32=(v(3)-v(2))*(1/z23)+v(3)*y023;
s23=v(2)*conj(i23)
s32=v(3)*conj(i32)
perd23=s23+s32
%flujo de potencias en transformador 34
i34=yt33*v(3)-yt34*v(4);
i43=-yt43*v(3)+yt44*v(4);
s34=v(3)*conj(i34)
s43=v(4)*conj(i43)
perd34=s34+s43
