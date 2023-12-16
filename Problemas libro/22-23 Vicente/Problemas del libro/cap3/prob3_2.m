%prob3.2
clc
clear
sg=0.8+0.6i;%en pu
u=1;
zg=0.1+1i;%en pu
i=conj(sg/u);
e1=u;
e2=u+i*zg;
IE1=1e3;
IE2=IE1*abs(e2)/abs(e1)
rend=real(sg)/(real(sg)+(abs(i))^2*real(zg))
%la máxima potencia activa se dará cuando delta=90º
deltamax=pi/2;
pmax=(abs(e2)*abs(u)*(real(zg)*cos(deltamax)+imag(zg)*sin(deltamax))-(abs(u))^2*real(zg))/(abs(zg))^2