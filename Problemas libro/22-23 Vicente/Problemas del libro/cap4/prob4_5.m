%problema 4.5
clc
clear
u0=4e-7*pi;
c=299792458;
eps0=(u0*c^2)^-1;
Dab=1;
DaB=4;
DAb=2;
DAB=1;
Dbc=1;
DbC=4;
DBc=2;
DBC=1;
Dca=2;
DcA=1;
DCa=5;
DCA=2;
DaA=3;
DbB=3;
DcC=3;
r=1.5e-2;
Lu=u0*log(((Dab*DaB*DAb*DAB)^(1/4)*(Dbc*DbC*DBc*DBC)^(1/4)*(Dca*DcA*DCa*DCA)^(1/4))^(1/3)/sqrt(r*exp(-0.25))/(DaA*DbB*DcC)^(1/6))/2/pi%en H/m
Cu=2*pi*eps0/log(((Dab*DaB*DAb*DAB)^(1/4)*(Dbc*DbC*DBc*DBC)^(1/4)*(Dca*DcA*DCa*DCA)^(1/4))^(1/3)/sqrt(r)/(DaA*DbB*DcC)^(1/6))%en F/m
