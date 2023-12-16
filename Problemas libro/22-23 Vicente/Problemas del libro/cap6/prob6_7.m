%problema 6.7
clear
clc
global u1 d1 p2 u2 p3 q3 y g%variables conocidas compartidas por este script
Sb=100e6;
%Datos
u1=1;
d1=0;
sd1=0;
sd2=0;
pg2=400e6/Sb;
p2=pg2-real(sd2);
u2=1.05;
sd3=(500e6+400e6i)/Sb;
sg3=0;
p3=real(sg3-sd3);
q3=imag(sg3-sd3);
%
y12=-40i;
y13=-20i;
y23=-20i;

%
Ybus=[y12+y13 -y12 -y13;
      -y12 y12+y23 -y23;
      -y13 -y23 y13+y23];
y=abs(Ybus);
g=angle(Ybus);
x0=[1 1 1 0 1 0];%x=[p1 q1 q2 d2 u3 d3]
x=fsolve(@ec_prob6_7,x0);
u=[u1 u2 x(5)]
  d=[d1 x(4) x(6)]
  p=[x(1) p2 p3]
  q=[x(2) x(3) q3]
v=u.*cos(d)+1i*u.*sin(d);
pg1=p(1)+real(sd1)
qg1=q(1)+imag(sd1)
qg2=q(2)+imag(sd2)
%
i12=y12*(v(1)-v(2));
i21=y12*(v(2)-v(1));
s12=v(1)*conj(i12)%flujo de potencias de 1 a 2
s21=v(2)*conj(i21);
perd12=s12+s21
%
i13=y13*(v(1)-v(3));
i31=y13*(v(3)-v(1));
s13=v(1)*conj(i13)%flujo de potencias de 1 a 3
s31=v(3)*conj(i31);
perd13=s13+s31
%
i23=y23*(v(2)-v(3));
i32=y23*(v(3)-v(2));
s23=v(2)*conj(i23)%flujo de potencias de 2 a 3
s32=v(3)*conj(i32);
perd23=s23+s32
