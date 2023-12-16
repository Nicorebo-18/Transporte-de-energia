%Ejemplo de solución de flujos de carga en sistema de 5 nudos
clear
clc
global u1 d1 p2 u2 y g%variables conocidas compartidas por este script
%Datos
u1=1;
d1=0;
sd2=0.5+1i;
u2=1;
%
p2=-real(sd2);
%
z12=0.5i;
y12=1/z12;
%
Ybus=[y12 -y12;-y12 y12];
y=abs(Ybus);
g=angle(Ybus);
xo=[1 1 1 0];%xo=[p1 q1 q2 d2]
x=fsolve(@ec_prob6_2,xo);
u=[u1 u2]
  d=[d1 x(4)]
  p=[x(1) p2]
  q=[x(2) x(3)]
U=u.*cos(d)+1i*u.*sin(d);
qg2=q(2)+imag(sd2)
%
i12=y12*(U(1)-U(2));
i21=y12*(U(2)-U(1));
s12=U(1)*conj(i12)%flujo de potencias de 1 a 2
s21=U(2)*conj(i21);
perd12=s12+s21
