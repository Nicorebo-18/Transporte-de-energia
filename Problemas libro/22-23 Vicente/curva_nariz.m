%Curvas de nariz
%Evaluación de carga máxima para una determinada caída de tensión y límite de estabilidad de tensión
%Línea de distribución radial en media tensión
%
clear
clc
%
%Conductor 47-AL1/8-ST1A
%199,3 A de corriente máxima admisible (202 A según Iberdrola)
%0,6136 Ohm/km en corriente continua a 20ºC
%1 hilo de acero + 6 hilos de aluminio de diámetros 3,15 mm cada uno
%diámetro del conductor 9,45 mm
%coeficiente para radio medio geométrico 0,7256
%coeficiente efecto pelicular 1,00013 de 50 a 85ºC
%
Ru=0.6136*(1+4.03e-3*(85-20))*1.00013/1e3;%Ohm/m
Xu=405.95e-6i;%Ohm/m
Yu=2.8465e-9i;%S/m
long=30e3;%longitud de la línea m
Imax=199.3;%corriente máxima por conductor A
U1=13.2e3;%tensión de servicio V
Ib=199.3;%base inicial
Ub=13.2e3;%base inicial
Sb=sqrt(3)*Ub*Ib;%base derivada
Zb=Ub^2/Sb;%base derivada
Yb=1/Zb;%base derivada
u1=U1/Ub;
im=Imax/Ib;
limtermico=u1*im;
zu=(Ru+Xu)/Zb;
yu=Yu/Yb;
zc=sqrt(zu/yu);
gamma=sqrt(zu*yu);
z=zc*sinh(gamma*long);%impedancia longitudinal
y=tanh(gamma*long/2)/zc;%admitancia transversal y/2
theta=angle(z);
%
p2=linspace(0/Sb,10e6/Sb)
fdp=1;
q2=p2.*tan(acos(fdp));
%
a=1/abs(z)^2-abs(y)*sin(theta)/abs(z)+abs(y)^2/2;
b=2*p2.*cos(theta)./abs(z)+2*q2.*(sin(theta)/abs(z)+abs(y)/2)-abs(u1)^2/abs(z)^2;
c=p2.^2+q2.^2;
u221=(-b+sqrt(b.^2-4*a.*c))/2./a;
u222=(-b-sqrt(b.^2-4*a.*c))/2./a;
%
u2a=sqrt(u221)
u2c=sqrt(u222)
%
grid on
hold on
title('Curva u2-p2 con tensión cte en extremo emisor')
text(1,1.3,['Sb= ' num2str(Sb/1e6) ' MW'])
text(1,1.1,['Ub= ' num2str(Ub/1e3) ' kV'])
%text(1,1,'texto')
xlabel('p2 (p.u.)')
ylabel('u2 (p.u.)')
plot(p2,u2a)
plot(p2,u2c)
plot([limtermico,limtermico],[0,u1])
text(0.6,0.5,'Límite térmico')
