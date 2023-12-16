%problema 5.5
clc
clear
%
f=50;
long=400e3;
Ru=0.035;%Ohm/km
Lu=1.1e-3;%H/km
Cu=0.012e-6;%F/km
U1=275e3;
P2=0;
%
Ub=U1;
Sb=100e6;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%
r=Ru*long/Zb/1e3;
x=2i*pi*f*Lu*long/Zb/1e3;
y=2i*pi*f*Cu*long/Yb/1e3;
z=r+x;
%matriz de transmisión de la línea
a=1+z*y/2;
b=z;
c=y*(1+z*y/4);
d=a;
abcd_linea=[a b;c d];
%matriz de transmisión del banco de condensadores
L=4;%valor inicial arbitrario de L
yl=(1/2i/pi/f/L)/Yb;
abcd_c=[1 0;yl 1];
%algoritmo de resolución
%Se considera el cuadripolo de la línea en cascada con el del banco de condensadores, como sistema.
ui2=[U1/Ub;0];%la tensión al final es 275 kV y está en vacío
tol=1e-5;
while (1)%bucle infinito
  u1=(a+b*yl)*ui2(1);
    if abs(abs(u1)-abs(ui2(1)))<tol
      break
    else
      if abs(u1)<1
        L=L-1e-3;
        yl=(1/2i/pi/f/L)/Yb;
      else
        L=L+1e-3;
        yl=(1/2i/pi/f/L)/Yb; 
      endif
    endif
endwhile
%
ql=abs(ui2(1))^2*abs(yl);
QL=ql*Sb/1e6%en MVAr