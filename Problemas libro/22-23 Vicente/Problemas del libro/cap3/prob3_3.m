%problema 3.3
clear
clc
S=50e6;
U=30e3;
fdp=0.8;%ind
X=9i;
%
Sb=50e6;
Ub=30e3;
Zb=Ub^2/Sb;
Ib=Sb/Ub/sqrt(3);
%
u=U/Ub;
s=(S*fdp+1i*S*sin(acos(fdp)))/Sb;
x=X/Zb;
%
ig=conj(s/u);
e=u+ig*x;%tensión de vacío
disp(['Tensión de vacío= ' num2str(abs(e)*Ub/1e3) ' kV'])
disp(['Angulo de potencia= ' num2str(angle(e)) ' rad'])
%
P=25e6;
p=P/Sb;
delta=asin(p*abs(x)/abs(e)/u);
q=abs(e)*abs(u)*cos(delta)/abs(x)-(abs(u))^2/abs(x);
sg=p+1i*q;
iG=conj(sg/u);
disp(['Corriente por el estator= ' num2str(abs(iG)*Ib) ' A'])
disp(['Factor de potencia= ' num2str(cos(angle(iG))) ' inductivo'])
%
pmax=abs(e)*abs(u)/abs(x);%máxima potencia activa
disp(['Máxima potencia activa= ' num2str(pmax*Sb/1e6) ' MW'])
qmax=-(abs(u))^2/abs(x);
smax=pmax+1i*qmax;
imax=conj(smax/u);
disp(['Corriente a potencia máxima= ' num2str(abs(imax)*Ib) ' A'])
