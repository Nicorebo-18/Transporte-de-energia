%problema 9.5
clc
clear
%Datos
SG1=1000e6;
UG1=15e3;
xG1=[0.07i 0.18i 0.18i];
%
SG4=1000e6;
UG4=15e3;
xG4=[0.1i 0.2i 0.2i];
%
SG6=500e6;
UG6=13.8e3;
xG6=[0.05i 0.15i 0.15i];
xN6=0.05i;
%
SG7=750e6;
UG7=13.8e3;
xG7=[0.1i 0.3i 0.4i];
%
ST12=1000e6;
UAT12=765e3;
UBT12=15e3;
xT12=0.1i;
h12=11;
%
ST34=1000e6;
UAT34=765e3;
UBT34=15e3;
xT34=0.1i;
h34=11;
%
ST56=500e6;
UAT56=765e3;
UBT56=15e3;
xT56=0.12i;
h56=0;
%
ST57=1000e6;
UAT57=765e3;
UBT57=15e3;
xT57=0.11i;
h57=0;
%
X23=[150i 50i 50i];
X25=[100i 40i 40i];
X35=[100i 40i 40i];
%Bases
Sb=100e6;
Ubg1=15e3;%zona generador 1
Ublin=765e3;%zona líneas
Ubg4=15e3;%zona generador 4
Ubg6=15e3;%zona generador 6
Ubg7=15e3;%zona generador 7
Zblin=Ublin^2/Sb;
Ibg4=Sb/Ubg4/sqrt(3);
%Conversión a pu y cambios de base
xg1=xG1*(Sb/SG1)*(UG1/Ubg1)^2;
xg4=xG4*(Sb/SG4)*(UG4/Ubg4)^2;
xg6=xG6*(Sb/SG6)*(UG6/Ubg6)^2;
xg7=xG7*(Sb/SG7)*(UG7/Ubg7)^2;
xn6=xN6*(Sb/SG6)*(UG6/Ubg6)^2;
xt12=xT12*(Sb/ST12)*(UAT12/Ublin)^2;
xt34=xT34*(Sb/ST34)*(UAT34/Ublin)^2;
xt56=xT56*(Sb/ST56)*(UAT56/Ublin)^2;
xt57=xT57*(Sb/ST57)*(UAT57/Ublin)^2;
x23=X23/Zblin;
x25=X25/Zblin;
x35=X35/Zblin;
%
Yhom=[1/xg1(1) 0 0 0 0 0 0;
      0 1/xt12+1/x25(1)+1/x23(1) -1/x23(1) 0 -1/x25(1) 0 0;
      0 -1/x23(1) 1/x23(1)+1/xt34+1/x35(1) 0 -1/x35(1) 0 0;
      0 0 0 -0.000001i 0 0 0;%si se pone el elemento (4,4)=0, matriz singular
      0 -1/x25(1) -1/x35(1) 0 1/x25(1)+1/x35(1)+1/xt57 0 0;
      0 0 0 0 0 1/(xg6(1)+3*xn6) 0;
      0 0 0 0 -1/xt57 0 1/xt57];
Ydir=[1/xg1(2)+1/xt12 -1/xt12 0 0 0 0 0;
      -1/xt12 1/xt12+1/x25(2)+1/x23(2) -1/x23(2) 0 -1/x25(2) 0 0;
      0 -1/x23(2) 1/x23(2)+1/x35(2)+1/xt34 -1/xt34 -1/x35(2) 0 0;
      0 0 -1/xt34 1/xt34+1/xg4(2) 0 0 0;
      0 -1/x25(2) -1/x35(2) 0 1/x25(2)+1/x35(2)+1/xt56+1/xt57 -1/xt56 -1/xt57;
      0 0 0 0 -1/xt56 1/xt56+1/xg6(2) 0;
      0 0 0 0 -1/xt57 0 1/xt57+1/xg7(2)];
Yinv=[1/xg1(3)+1/xt12 -1/xt12 0 0 0 0 0;
      -1/xt12 1/xt12+1/x25(3)+1/x23(3) -1/x23(3) 0 -1/x25(3) 0 0;
      0 -1/x23(3) 1/x23(3)+1/x35(3)+1/xt34 -1/xt34 -1/x35(3) 0 0;
      0 0 -1/xt34 1/xt34+1/xg4(3) 0 0 0;
      0 -1/x25(3) -1/x35(3) 0 1/x25(3)+1/x35(3)+1/xt56+1/xt57 -1/xt56 -1/xt57;
      0 0 0 0 -1/xt56 1/xt56+1/xg6(3) 0;
      0 0 0 0 -1/xt57 0 1/xt57+1/xg7(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
%cortocircuito FF en nudo 2
u=[0 0 0 0 0 0 0;1 1 1 1 1 1 1;0 0 0 0 0 0 0];%se supone tensión nominal en todos los nudos antes del cc
q=2;%nudo donde se produce el cc
ifaltaff2=[0;u(2,q)/(Zdir(q,q)+Zinv(q,q));-u(2,q)/(Zdir(q,q)+Zinv(q,q))];%en componentes simétricas
%
ufalta=zeros(3,7);%inicializa
for m=1:7
  ufalta(:,m)=u(:,m)-diag([Zhom(m,q);Zdir(m,q);Zinv(m,q)])*ifaltaff2;%tensiones de falta en todos los nudos
endfor
%todas las tensiones están calculadas sin tener en cuenta los desfases de los transformadores
%Por tanto, las tensiones en los nudos 1 y 4 no son correctas
%La tensión del devanado de BT se retrasa h*pi/6 rad con respecto a la tensión del devanado de AT (en secuencia directa)
ufalta4=ufalta(:,4).*[0;cos(-h34*pi/6)+1i*sin(-h34*pi/6);cos(h34*pi/6)+1i*sin(h34*pi/6)];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;1 a^2 a;1 a a^2];
uFALTA4=A*ufalta4;
UFALTA4=abs(uFALTA4)*Ubg4/1e3%en kV en cada fase
%si no se hubiera tenido en cuenta el desfase
UFALTA4sindesfase=abs(A*ufalta(:,4))*Ubg4/1e3
%Pero pregunta por las tensiones de falta en el generador 7
UFALTA7=abs(A*ufalta(:,7))*Ubg7/1e3%en kV en cada fase
