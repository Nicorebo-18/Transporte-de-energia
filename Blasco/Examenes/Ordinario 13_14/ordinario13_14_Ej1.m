%Examen ordinario 2013/14 Iñaki Orradre
clear
clc
format shortEng
%Valores asignados transformadores
Snt12 = 10e6;
UATt12 = 220e3;
UBTt12 = 20e3;
Snt34 = 2.5e6;
UATt34 = 20e3;
UBTt34 = 0.4e3;
Snt56 = 1e6;
UATt56 = 20e3;
UBTt56 = 0.4e3;
%Bases del sistema por unidad
Sb = 100e6;
Ub1 = 220e3; %entrada a la subestación
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ub2 = Ub1*UBTt12/UATt12; %líneas de media tensión
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ub3 = Ub2*UBTt34/UATt34; %puntos de consumo
Ib3 = Sb/Ub3/sqrt(3);
Zb3 = Ub3^2/Sb;
Yb3 = 1/Zb3;
% Problema 1: Cálculo de los parámetros de las líneas de distribución
%Se trata de una línea aérea trifásica asimétrica de un circuito y un
%conductor por fase
%Constantes empleadas para el cálculo
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Datos de la línea
Dab = sqrt(((3.36/2-(0.55+0.673/cosd(15)))/sind(15)+0.673/sind(15))^2+3.36^2);
Dbc = Dab;
Dac = 3.36; %Distancias entre conductores
radio = sqrt(30/pi)*1e3/2; %Radio de los conductores, equivalente en cobre
Rc = 0.6136e-3*(1+(3.93e-3*(80-20))); %Resistencia del conductor por unidad de longitud Ohm/m, a 80 ºC

R = Rc; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/(radio*exp(-0.25)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/radio); %Capacidad de la línea por unidad de longitud C/m
X = R + 2i*pi*f*L; %Impedancia de la línea por unidad de longitud, Ohm/m
B = 2i*pi*f*C;
disp(['Impedancia de la línea por unidad de longitud: ' num2str(X) ' Ohmios/m'])
disp(['Susceptacia capacitiva de la línea por unidad de longitud: ' num2str(B) ' Siemens/m'])