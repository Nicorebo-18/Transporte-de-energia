%problema 6.4
clear
clc
 global u1 d1 p2 u2 p3 q3 y g%variables conocidas compartidas por este script
%Datos
u1=1;
d1=0;
sd1=1;
sd2=1-0.8i;
pg2=0.8;
p2=pg2-real(sd2);
u2=1;
sd3=1+0.6i;
sg3=0;
p3=real(sg3-sd3);
q3=imag(sg3-sd3);
%
z12=0.4i;
z13=0.4i;
z23=0.4i;
y12=1/z12;
y13=1/z13;
y23=1/z23;
%
Ybus=[y12+y13 -y12 -y13;
      -y12 y12+y23 -y23;
      -y13 -y23 y13+y23];
y=abs(Ybus);
g=angle(Ybus);
x0=[1 1 1 0 1 0];%x=[p1 q1 q2 d2 u3 d3]
x=fsolve(@ec_prob6_4,x0);
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
