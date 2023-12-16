clc
clear
%problemas 2.2 y 2.3 del libro
%
%Datos del problema
SG=30e6;%potencia aparente nominal del generador
UG=13.8e3;%tensión nominal del generador
xG=0.1i;%reactancia síncrona del generador
SM=20e6;%potencia aparente nominal del motor
UM=13.8e3;%tensión nominal del motor
xM=0.08i;%reactancia síncrona del motor
ST1=20e6;%potencia aparente nominal del transformador 1
U1T1=13.2e3;%tensión nominal primaria del transformador 1
U2T1=132e3;%tensión nominal secundaria del transformador 2
xT1=0.1i;%reactancia de cortocircuito del transformador 1
ST2=15e6;%potencia aparente nominal del transformador 2
U1T2=138e3;%tensión nominal primaria del transformador 2
U2T2=13.8e3;%tensión nominal secundaria del transformador 2
xT2=0.12i;%reactancia de cortocircuito del transformador 2
ZL=20+100i;%impedancia de la línea
%
%bases seleccionadas de forma arbitraria
Sb=100e6;%base de potencia
UbL=132e3;%base de tensión en la zona de línea
%bases derivadas
ZbL=UbL^2/Sb;%impedancia base en la zona de la línea
IbL=Sb/UbL/sqrt(3);%corriente base en la zona de la línea
UbM=UbL*U2T2/U1T2;%tensión base en la zona del motor
ZbM=UbM^2/Sb;%impedancia base en la zona del motor
IbM=Sb/UbM/sqrt(3);%corriente base en la zona del motor
UbG=UbL*U1T1/U2T1;%tensión base en la zona del generador
ZbG=UbG^2/Sb;%impedancia base en la zona del generador
IbG=Sb/UbG/sqrt(3);%corriente base en la zona del generador
%
%Valores en pu del sistema
xg=xG*(UG/UbG)^2*(Sb/SG);%reactancia del generador
xt1=xT1*(U1T1/UbG)^2*(Sb/ST1);%reactancia del transformador 1
zl=ZL/ZbL;%impedancia de la línea
xt2=xT2*(U1T2/UbL)^2*(Sb/ST2);%reactancia del generador
xm=xM*(UM/UbM)^2*(Sb/SM);%reactancia del motor
%
%Datos para calcular la corriente del motor
UMfn=13.2e3;%tensión de funcionamiento del motor
umfn=UMfn/UbM;
PMfn=15e6;%potencia activa de funcionamiento del motor
pmfn=PMfn/Sb;
fdp=0.85;%en adelanto
%Si fdp=cap entonces qmfn tiene que ser negativa
qmfn=-pmfn*tan(acos(fdp));%potencia reactiva de funcionamiento del motor
smfn=pmfn+qmfn*1i;%potencia compleja del motor en funcionamiento en normal
imfn=conj(smfn/umfn);%corriente del motor en funcionamiento normal
IMfn=imfn*IbM;%corriente del motor en funcionamiento en A
disp(['Corriente en el motor= ' num2str(abs(imfn)) '/___' num2str(angle(imfn)) ' p.u.'])
disp(['Corriente en el motor= ' num2str(abs(IMfn)) '/___' num2str(angle(IMfn)) ' A'])
ilfn=imfn;
disp(['Corriente en la línea= ' num2str(abs(ilfn)) '/___' num2str(angle(ilfn)) ' p.u.'])
disp(['Corriente en la línea= ' num2str(abs(ilfn)*IbL) '/___' num2str(angle(ilfn)) ' A'])
ugfn=umfn+ilfn*(xt1+zl+xt2);%tensión en bornes del generadordisp(['Corriente en el motor= ' num2str(abs(imfn)) '/___' num2str(angle(imfn)) ' p.u.'])
disp(['Tensión en bornes del generador= ' num2str(abs(ugfn)) '/___' num2str(angle(ugfn)) ' p.u.'])
disp(['Tensión en bornes del generador= ' num2str(abs(ugfn)*UbG/1e3) '/___' num2str(angle(ugfn)) ' kV'])
u2=umfn+ilfn*(zl+xt2);%tensión al principio de la línea
disp(['Tensión al principio de la línea= ' num2str(abs(u2)) '/___' num2str(angle(u2)) ' p.u.'])
disp(['Tensión al principio de la línea= ' num2str(abs(u2)*UbL/1e3) '/___' num2str(angle(u2)) ' kV'])
sgfn=ugfn*conj(ilfn);%potencia compleja que suministra el generador en funcionamiento normal
disp(['Potencia compleja que suministra el generador= ' num2str(sgfn) ' p.u.'])
disp(['Potencia compleja que suministra el generador= ' num2str(sgfn*Sb/1e6) ' MVA'])
