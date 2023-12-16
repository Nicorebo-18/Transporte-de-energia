%problema 8.8
clear
clc
%Bases
Sb=100e6;
%Supondremos que todas las tensiones nominales de las máquinas coinciden con las bases de tensión (desconocidas)
SG1=25e6;
xG1=0.15i;
xg1=xG1*(Sb/SG1);
SG2=50e6;
xG2=0.2i;
xg2=xG2*(Sb/SG2);
ST1=100e6;
xT1=0.08i;
xt1=xT1*(Sb/ST1);
ST2=40e6;
xT2=0.1i;
xt2=xT2*(Sb/ST2);
x=2.434i%valor arbitrario de x en p.u. que iremos cambiando hasta que la Scc=3,33 p.u.
%Supondremos que no existe carga y que la tensión es la nominal
%Un sistema de potencia infinita se puede considerar como una fuente de tensión ideal
xinfinito=0i;
%Consideraremos que el sistema tiene 3 nudos (los 2 que ya aparecen en el esquema y el tercero justo a la salida del interruptor)
Ydir=[1/xg1+1/xg2+1/xt1+1/x -1/x -1/xt1;
      -1/x 1/x+1/(xt2+xinfinito) 0;
      -1/xt1 0 1/xt1];
Zdir=inv(Ydir);
%
q=3;%nudo donde se produce el cortocircuito
v=[0 0 0;
1 1 1;
0 0 0];%tensiones prefalta en componentes simétricas
ifaltafff3dir=v(2,q)/Zdir(q,q);
ifaltafff3=[0;ifaltafff3dir;0];
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
Ifaltafff3=A*ifaltafff3;
scc=abs(v(2,q)*conj(Ifaltafff3(1)))
