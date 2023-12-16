%prob 8.1
clear
clc
Sb=10e6;
Ub1=11e3;
Zb1=Ub1^2/Sb;
Ib1=Sb/Ub1/sqrt(3);
Ub2=33e3;
Zb2=Ub2^2/Sb;
Ib2=Sb/Ub2/sqrt(3);
Ub3= 6.6e3;
Zb3=Ub3^2/Sb;
Ib3=Sb/Ub3/sqrt(3);
%
xg1=0.1i;%componente directa
yg1=1/xg1;
xg2=0.125i;
yg2=1/xg2;
xt12=0.1i;
yt12=1/xt12;
z23=30*(0.27+0.36i)/Zb2;
y23=1/z23;
xt34=0.08i*(Sb/5e6);
yt34=1/xt34;
z45=3*(0.135+0.08i)/Zb3;
y45=1/z45;
%
Ydir=[yg1+yg2+yt12 -yt12 0 0 0;
      -yt12 yt12+y23 -y23 0 0;
      0 -y23 y23+yt34 -yt34 0;
      0 0 -yt34 yt34+y45 -y45;
      0 0 0 -y45 y45];
Zdir=inv(Ydir);
q=5;%nudo donde se produce el cc
u=[0 0 0 0 0;
   1 1 1 1 1;
   0 0 0 0 0];%tensiones prefalta
ifaltafff=[0;u(2,q)/Zdir(q,q);0];
ufaltafff1=u(2,1)-Zdir(1,q)*ifaltafff(2);
ufaltafff2=u(2,2)-Zdir(2,q)*ifaltafff(2);
ufaltafff3=u(2,3)-Zdir(3,q)*ifaltafff(2);
ufaltafff4=u(2,4)-Zdir(4,q)*ifaltafff(2);
ufaltafff5=u(2,5)-Zdir(5,q)*ifaltafff(2);
disp(['Corriente de falta trifásica= ' num2str(abs(ifaltafff(2))*Ib3/1e3) ' kA'])
disp(['Tensión en falta en nudo 1= ' num2str(abs(ufaltafff1)*Ub1/1e3) ' kV'])