%Problema 6.11
clear
clc
global p1 u1 u2 d2 p3 u3 y g%variables conocidas compartidas por este script
%Nudo PV (A)
u1=1;
sd1=0;
pg1=50/100;
p1=pg1-real(sd1);
%Nudo de referencia (B)
sd2=0;
u2=1;
d2=0;
%Nudo PV (C)
u3=1;
sd3=(100+50i)/100;
pg3=0;
p3=pg3-real(sd3);
%
z12=0.1i;
z13=0.1i;
z23a=0.1i;
z23b=0.1i;
y023a=0.01i;
y023b=0.01i;
y12=1/z12;
y13=1/z13;
y23a=1/z23a;
y23b=1/z23b;
%
Ybus=[y12+y13 -y12 -y13;
      -y12 y12+y23a+y023a+y23b+y023b -(y23a+y23b);
      -y13 -(y23a+y23b) y13+y23a+y023a+y23b+y023b];
y=abs(Ybus);
g=angle(Ybus);
xo=[1 0 1 1 1 0];%xo=[q1 d1 p2 q2 q3 d3]
x=fsolve(@ec_prob6_11,xo);
u=[u1 u2 u3]
  d=[x(2) d2 x(6)]
  p=[p1 x(3) p3]
  q=[x(1) x(4) x(5)]
U=u.*cos(d)+1i*u.*sin(d);
pg2=p(2)+real(sd2)
qg2=q(2)+imag(sd2)
qg3=q(3)+imag(sd3)
pg1=p(1)+real(sd1)
qg1=q(1)+imag(sd1)
%
i12=y12*(U(1)-U(2));
i21=y12*(U(2)-U(1));
s12=U(1)*conj(i12)%flujo de potencias de 1 a 2
s21=U(2)*conj(i21);
perd12=s12+s21
%
i13=y13*(U(1)-U(3));
i31=y13*(U(3)-U(1));
s13=U(1)*conj(i13)%flujo de potencias de 1 a 3
s31=U(3)*conj(i31);
perd13=s13+s31
%
i23a=y23a*(U(2)-U(3))+U(2)*y023a;
i32a=y23a*(U(3)-U(2))+U(3)*y023a;
s23a=U(2)*conj(i23a)%flujo de potencias de 2 a 3
s32a=U(3)*conj(i32a);
perd23a=s23a+s32a
%
i23b=y23b*(U(2)-U(3))+U(2)*y023b;
i32b=y23b*(U(3)-U(2))+U(3)*y023b;
s23b=U(2)*conj(i23b)%flujo de potencias de 2 a 3
s32b=U(3)*conj(i32b);
perd23a=s23b+s32b