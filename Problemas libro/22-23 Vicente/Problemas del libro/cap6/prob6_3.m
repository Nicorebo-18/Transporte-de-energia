%Ejemplo de solución de flujos de carga en sistema de 5 nudos
clear
clc
  global u1 d1 p2 q2 p3 q3 y g%variables conocidas compartidas por este script
%Datos
u1=1;
d1=0;
sd1=1;
sd2=1-0.8i;
sg2=0.8-0.3i;
p2=real(sg2)-real(sd2);
q2=imag(sg2)-imag(sd2);
sd3=1+0.6i;
sg3=0;
p3=real(sg3)-real(sd3);
q3=imag(sg3)-imag(sg3);
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
xo=[1 1 1 0 1 0];%xo=[p1 q1 u2 d2 u3 d3]
x=fsolve(@ec_prob6_3,xo);
u=[u1 x(3) x(5)]
  d=[d1 x(4) x(6)]
  p=[x(1) p2 p3]
  q=[x(2) q2 q3]
U=u.*cos(d)+1i*u.*sin(d);
pg1=p(1)+real(sd1)
qg2=q(1)+imag(sd1)
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
i23=y23*(U(2)-U(3));
i32=y23*(U(3)-U(2));
s23=U(2)*conj(i23)%flujo de potencias de 2 a 3
s32=U(3)*conj(i32);
perd23=s23+s32
