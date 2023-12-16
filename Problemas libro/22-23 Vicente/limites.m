%límites térmico y de estabilidad de una línea con tensión constante en ambos extremos
%La línea es de un circuito con conductores duplex a 220 kV
%El conductor 337-AL1/44-ST1A (gaviota), según HC, 751 A máx.
%
clear
clc
%
Ru=85.1e-3/2/1e3;%Ohm/m
Xu=0.3014i/1e3;%Ohm/m
Yu=3.7345e-6i/1e3;%S/m
Imax=751;%corriente máxima por conductor en A
U=220e3;%tensión de servicio en V
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
long=linspace(1e3,1000e3);%crea un vector fila con 100 longitudes de línea desde 1 a 1000 km
%
%circuito equivalente exacto de la línea
%
z=zu.*long.*sinh(gamma.*long)./gamma./long;%vector fila con 100 impedancias longitudinales
y=yu.*long.*tanh(gamma./long/2)./(gamma.*long/2)/2;%vector fila con 100 admitancias transversales y/2
%
theta=angle(z);%vector fila de 100 argumentos de z
%
delta0=theta;%límite de estabilidad estática
delta=pi/6;%límite de estabilidad dinámica
u2=abs(u);%tensión al final de la línea igual que al principio
%
p20=abs(u)*u2.*cos(theta-delta0)./abs(z)-u2^2.*cos(theta)./abs(z);%vector fila de 100 valores de p20
p2=abs(u)*u2.*cos(theta-delta)./abs(z)-u2^2.*cos(theta)./abs(z);%vector fila de 100 valores de p2
limtermico=u*2*i;%porque hay dos conductores por fase
%
grid on%activar rejilla
hold on%activar representación de varias figuras en los mismos ejes
plot(long/1e3,p20/abs(sil))%dibuja el límite de potencia activa por estabilidad estática
plot(long/1e3,p2/abs(sil))%dibuja el límite de potencia activa por estabilidad dinámica
plot([1,1000],[limtermico/abs(sil),limtermico/abs(sil)])%dibuja la línea horizontal del límite térmico
title('Potencia activa máxima transportable con U1=U2')
xlabel('long [km]')
ylabel('P2/SIL')
text(400,3.5,'Límite térmico')
text(500,1,'Límite de estabilidad dinámica')
text(400,2.3,'Límite de estabilidad estática')
axis([1,1000,0,4])%ajustar la extensión de los ejes