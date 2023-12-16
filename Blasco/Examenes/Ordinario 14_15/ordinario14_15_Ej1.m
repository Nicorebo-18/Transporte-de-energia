%Examen ordinario 2014/15 Iñaki Orradre
clear
clc
format shortEng
% Problema 1: Cálculo de los parámetros de una línea con las características dadas.
%Bases del sistema por unidad
Sb = 100e6;
Ub = 66e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
%Constantes empleadas en el cálculo de parámetros de la líneas
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Línea áerea trifásica asimétrica de un circuito, 1 conductor por fase
long = 54e3; %Longitud de la línea
Dab = sqrt((2*1.9)^2+2^2);
Dbc = sqrt((1.9+2.3)^2+2^2);
Dac = sqrt((2.3-1.9)^2+4^2); %Distancias entre conductores
radio = 17.28e-3/2; %Radio de los conductores
Rc = 0.19e-3*(1+(80-20)*3.93e-3); %Resistencia del conductor por unidad de longitud Ohm/m a 80 ºC
R = Rc; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/(radio*exp(-0.25)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/radio); %Capacidad de la línea por unidad de longitud C/m
r = R*long/Zb; %Resistencia de la línea, en pu
x = 2*pi*f*L*long*1i/Zb; %Reactancia de la línea, en pu
c = long/(2*pi*f*C*1i)/Zb; %Capacidad de la línea, en pu
%Visualización de resultados
disp(['Resistencia total de la línea (expresada en por unidad): ' num2str(r)])
disp(['Reactancia inductiva total de la línea (expresada en por unidad): ' num2str(x)])
disp(['Capacidad paralelo total de la línea (expresada en por unidad): ' num2str(c)])