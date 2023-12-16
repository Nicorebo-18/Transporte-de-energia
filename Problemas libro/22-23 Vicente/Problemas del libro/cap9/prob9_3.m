%problema 9.3
clear
clc
%
xg1=[0.05i;0.2i;0.15i];
xt=[0.12i;0.12i;0.12i];
xl=[0.5i;0.3i;0.3i];
x=0.41892i;%valor arbitrario de x que habrá que ir cambiando hasta cumplir con las condiciones
xg2=[0.05i;x;x];
%Para poder calcular cómodamente cualquier cosa, añado el nudo 3 a la salida del transformador
Yhom=[1/xg1(1) 0 0;
      0 1/xl(1)+1/xg2(1) -1/xl(1);
      0 -1/xl(1) 1/xt(1)+1/xl(1)];
Ydir=[1/xg1(2)+1/xt(2) 0 -1/xt(2);
      0 1/xl(2)+1/xg2(2) -1/xl(2);
      -1/xt(2) -1/xl(2) 1/xt(2)+1/xl(2)];
Yinv=[1/xg1(3)+1/xt(3) 0 -1/xt(3);
      0 1/xl(3)+1/xg2(3) -1/xl(3);
      -1/xt(3) -1/xl(3) 1/xt(3)+1/xl(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
q=2;%nudo donde se produce el cortocircuito
v=[0 0 0;
   1 1 1;
   0 0 0];%en componentes simétricas
ifaltadirfff=v(2,q)/Zdir(q,q);
ifaltafff=[0;ifaltadirfff;0];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
%cambiar x hasta que Ifalta=4
Ifaltafff=abs(A*ifaltafff)%módulo de las corrientes de falta por fase en p.u.
%Con el valor calculado de x, calcular la corriente de falta FT en el mismo nudo
ifaltadirft=v(2,q)/(Zhom(q,q)+Zdir(q,q)+Zinv(q,q));
ifaltaft=[ifaltadirft;ifaltadirft;ifaltadirft];%en componentes simétricas
Ifaltaft=abs(A*ifaltaft)%módulo de las corrientes de falta por fase en p.u.
