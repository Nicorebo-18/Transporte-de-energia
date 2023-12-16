%l�mites t�rmico y de estabilidad de una l�nea con tensi�n constante en ambos extremos
%La l�nea es de un circuito con conductores duplex a 220 kV
%El conductor 337-AL1/44-ST1A (gaviota), seg�n HC, 751 A m�x.
%
clear
clc
%
Ru=85.1e-3/2/1e3;%Ohm/m
Xu=0.3014i/1e3;%Ohm/m
Yu=3.7345e-6i/1e3;%S/m
Imax=751;%corriente m�xima por conductor en A
U=220e3;%tensi�n de servicio en V
Ib=Imax;%base inicial
Ub=U;%base inicial
Sb=sqrt(3)*Ub*Ib;%base derivada
Zb=Ub^2/Sb;%base derivada
Yb=1/Zb;%base derivada
u=U/Ub;
i=Imax/Ib;
%
zu=(Ru+Xu)/Zb;
yu=Yu/Yb;
zc=sqrt(zu/yu);
gamma=sqrt(zu*yu);
sil=u^2/conj(zc);
%
long=linspace(1e3,1000e3);%crea un vector fila con 100 longitudes de l�nea desde 1 a 1000 km
%
%circuito equivalente exacto de la l�nea
%
z=zu.*long.*sinh(gamma.*long)./gamma./long;%vector fila con 100 impedancias longitudinales
y=yu.*long.*tanh(gamma./long/2)./(gamma.*long/2)/2;%vector fila con 100 admitancias transversales y/2
%
theta=angle(z);%vector fila de 100 argumentos de z
%
delta0=theta;%l�mite de estabilidad est�tica
delta=pi/6;%l�mite de estabilidad din�mica
u2=abs(u);%tensi�n al final de la l�nea igual que al principio
%
p20=abs(u)*u2.*cos(theta-delta0)./abs(z)-u2^2.*cos(theta)./abs(z);%vector fila de 100 valores de p20
p2=abs(u)*u2.*cos(theta-delta)./abs(z)-u2^2.*cos(theta)./abs(z);%vector fila de 100 valores de p2
limtermico=u*2*i;%porque hay dos conductores por fase
%
grid on%activar rejilla
hold on%activar representaci�n de varias figuras en los mismos ejes
plot(long/1e3,p20/abs(sil))%dibuja el l�mite de potencia activa por estabilidad est�tica
plot(long/1e3,p2/abs(sil))%dibuja el l�mite de potencia activa por estabilidad din�mica
plot([1,1000],[limtermico/abs(sil),limtermico/abs(sil)])%dibuja la l�nea horizontal del l�mite t�rmico
title('Potencia activa m�xima transportable con U1=U2')
xlabel('long [km]')
ylabel('P2/SIL')
text(400,3.5,'L�mite t�rmico')
text(500,1,'L�mite de estabilidad din�mica')
text(400,2.3,'L�mite de estabilidad est�tica')
axis([1,1000,0,4])%ajustar la extensi�n de los ejes