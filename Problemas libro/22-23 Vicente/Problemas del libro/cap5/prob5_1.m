%problema 5.1
clc
clear
f=50;
P=5000e3;
fdp=0.707;%inductivo
long=20e3;
Ru=0.0195/1e3;%Ohm/m
Lu=0.63e-3/1e3;%H/m
U=10e3;
%
Sb=P;
Ub=U;
Zb=Ub^2/Sb;
z=(Ru+2i*pi*f*Lu)*long/Zb;
p=P/Sb;
q=p*tan(acos(fdp));
u=U/Ub;
corriente=conj((p+1i*q)/u);
uprincipio=u+corriente*z;
Uprincipio=abs(uprincipio)*Ub/1000;%en kV
cdt=(abs(uprincipio)-abs(u))/abs(u);
disp(['Tensión al principio de la línea= ' num2str(Uprincipio) ' kV'])
disp(['Caída de tensión= ' num2str(cdt*100) ' %'])
