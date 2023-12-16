%prob 4.4
clc
clear
diam=30e-3;
d=0.5;
Dab=15;
Dbc=15;
Dca=30;
f=50;
Lu=2e-7*log((Dab*Dbc*Dca)^(1/3)/sqrt(diam*d*exp(-0.25)/2));
Xu=2*pi*f*Lu;
eps0=1/4e-7/pi/299792458^2;
Cu=2*pi*eps0/log((Dab*Dbc*Dca)^(1/3)/sqrt(diam*d/2));
Bu=2*pi*f*Cu;
disp(['Inductancia por unidad de longitud= ' num2str(Lu*1e6) ' uH/m'])
disp(['Reactancia por unidad de longitud= ' num2str(Xu*1e3) ' mOhm/m'])
disp(['Capacidad por unidad de longitud= ' num2str(Cu*1e12) ' pF/m'])
disp(['Susceptancia por unidad de longitud= ' num2str(Bu*1e9) ' nS/m'])
