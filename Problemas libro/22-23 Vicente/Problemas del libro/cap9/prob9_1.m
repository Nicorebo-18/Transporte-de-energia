%problema 9.1
%Se considera que el sistema tiene 4 nudos. Se produce un cortocircuito FFT en el nudo 3.
clear
clc
xg1=[0.05i;0.35i;0.25i];%reactancias homopolar, directa e inversa del generador 1
xt1=[0.1i;0.1i;0.1i];%idem del transformador 1
x23a=[0.8i;0.4i;0.4i];%idem de la línea 23a
x23b=x23a;%idem de la línea 23b
xt2=xt1;%idem del transformador 2
xg2=[0.04i;0.3i;0.2i];%idem del generador 2
%
Yhom=[1/xg1(1)+1/xt1(1) -1/xt1(1) 0 0;
      -1/xt1(1) 1/xt1(1)+1/x23a(1)+1/x23b(1) -(1/x23a(1)+1/x23b(1)) 0;
      0 -(1/x23a(1)+1/x23b(1)) 1/x23a(1)+1/x23b(1)+1/xt2(1) -1/xt2(1);
      0 0 -1/xt2(1) 1/xt2(1)];
Ydir=[1/xg1(2)+1/xt1(2) -1/xt1(2) 0 0;
      -1/xt1(2) 1/xt1(2)+1/x23a(2)+1/x23b(2) -(1/x23a(2)+1/x23b(2)) 0;
      0 -(1/x23a(2)+1/x23b(2)) 1/x23a(2)+1/x23b(2)+1/xt2(2) -1/xt2(2);
      0 0 -1/xt2(2) 1/xt2(2)+1/xg2(2)];
Yinv=[1/xg1(3)+1/xt1(3) -1/xt1(3) 0 0;
      -1/xt1(3) 1/xt1(3)+1/x23a(3)+1/x23b(3) -(1/x23a(3)+1/x23b(3)) 0;
      0 -(1/x23a(3)+1/x23b(3)) 1/x23a(3)+1/x23b(3)+1/xt2(3) -1/xt2(3);
      0 0 -1/xt2(3) 1/xt2(3)+1/xg2(3)];
Zhom=inv(Yhom);
Zdir=inv(Ydir);
Zinv=inv(Yinv);
q=3;%nudo donde se produce el cortocircuito
v=[0 0 0 0;
   1 1 1 1;
   0 0 0 0];%tensiones prefalta en todos los nudos
ifaltadir=v(2,q)/(Zdir(q,q)+Zinv(q,q)*Zhom(q,q)/(Zinv(q,q)+Zhom(q,q)));
ifaltahom=-ifaltadir*Zinv(q,q)/(Zinv(q,q)+Zhom(q,q));
ifaltainv=-ifaltadir*Zhom(q,q)/(Zinv(q,q)+Zhom(q,q));
ifalta=[ifaltahom;ifaltadir;ifaltainv];%en componentes simétricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];
Ifalta=A*ifalta;%en p.u. por fase
IFalta=abs(Ifalta)%módulo de las corrientes de falta por fase en p.u.
%Ya estaría resuelto el problema, pero vamos a calcular cuánto viene de cada lado
ufalta=zeros(3,4);
for m=1:4
  ufalta(:,m)=v(:,m)-diag([Zhom(m,q);Zdir(m,q);Zinv(m,q)])*ifalta;%tensiones de falta en componentes simétricas
endfor
ifalta23a=(ufalta(:,2)-ufalta(:,3))./x23a;
ifalta23b=ifalta23a;
ifaltat2=ifalta-(ifalta23a+ifalta23b);
Ifalta23a=A*ifalta23a
Ifalta23b=A*ifalta23b
Ifaltat2=A*ifaltat2