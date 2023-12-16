%Ejemplo de solución de flujos de carga en sistema de 5 nudos
clear
clc
global u1 d1 p2 q2 p3 q3 p4 q4 p5 q5 y g%variables conocidas compartidas por este script
%Datos
u1=1;
d1=0;
sd2=0;
sg2=0;
sd3=0;
sg3=0;
sd4=0;
sg4=0.097i;
sd5=0.3+0.1i;
sg5=0;
%
s2=sg2-sd2;
p2=real(s2);
q2=imag(s2);
s3=sg3-sd3;
p3=real(s3);
q3=imag(s3);
s4=sg4-sd4;
p4=real(s4);
q4=imag(s4);
s5=sg5-sd5;
p5=real(s5);
q5=imag(s5);
%
xt=0.128i;
x23=0.35i;
x35=0.24i;
x34=0.18i;
x45=0.3i;
yt=1/xt;
y23=1/x23;
y35=1/x35;
y34=1/x34;
y45=1/x45;
%
Ybus=[yt -yt 0 0 0;
-yt yt+y23 -y23 0 0;
0 -y23 y23+y35+y34 -y34 -y35;
0 0 -y34 y34+y45 -y45;
0 0 -y35 -y45 y35+y45];
y=abs(Ybus);
g=angle(Ybus);
xo=[1 1 1 0 1 0 1 0 1 0 1 0];
x=fsolve(@ec_flujo,xo);
u=[u1 x(3) x(5) x(7) x(9)]
  d=[d1 x(4) x(6) x(8) x(10)]
  p=[x(1) p2 p3 p4 p5]
  q=[x(2) q2 q3 q4 q5]
U=u.*cos(d)+1i*u.*sin(d);  
%
i12=yt*(U(1)-U(2));
i21=yt*(U(2)-U(1));
s12=U(1)*conj(i12)%flujo de potencias de 1 a 2
s21=U(2)*conj(i21);
perd12=s12+s21
%
i23=y23*(U(2)-U(3));
i32=y23*(U(3)-U(2));
s23=U(2)*conj(i23)
s32=U(3)*conj(i32);
perd23=s23+s32
%
i35=y35*(U(3)-U(5));
i53=y35*(U(5)-U(3));
s35=U(3)*conj(i35)
s53=U(5)*conj(i53);
perd35=s35+s53
i34=y34*(U(3)-U(4));
i43=y34*(U(4)-U(3));
s34=U(3)*conj(i34)
s43=U(4)*conj(i43);
perd34=s34+s43
%
i45=y45*(U(4)-U(5));
i54=y45*(U(5)-U(4));
s45=U(4)*conj(i45)
s54=U(5)*conj(i54);
perd54=s45+s54