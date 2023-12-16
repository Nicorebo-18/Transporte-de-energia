%prob 5.10
P=3600e6;
n=4;%número de lÃ­neas
f=50;
long=300e3;
Beta=9.46e-4;%rad/km
beta=Beta/1e3;%rad/m
Rc=343;%Ohm
modulo_u1=1;%pu
modulo_u2=0.9;%pu
delta=36.87*pi/180;
%tensiÃ³n nominal de la línea?
U=[20e3 66e3 132e3 220e3 400e3];
Sb=P/4;
for j=1:5
Ub(j)=U(j);%tensión de prueba
Zb(j)=Ub(j)^2/Sb;
z(j)=1i*Rc*sin(beta*long)/Zb(j);
pmax(j)=modulo_u1*modulo_u2*cos(pi/2-delta)/abs(z(j));
end
disp(['Máxima potencia transmisible según tensión'])
disp('kV     MW')
fprintf(1,'%3.0f  %5.1f\n',[U/1e3;4*pmax*Sb/1e6])
disp(['Aproximadamente, serviría con 400 kV'])
