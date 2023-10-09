%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-4 --------------             %
%                    Clase 18/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
f = 50;                 % Frecuencia de la red
long = 300e3;           % Longitud del cable
U2 = 220e3/sqrt(3);     % Tensión al final de la linea en linea-neutro
P2 = 50e6/3;            % Potencia de la linea monofásica
fdp2 = 0.8; 			% Factor de potencia en retraso
Z = 40 + 25i;           % Impedancia de la linea
Y = 1e-3i;				% Susceptancia de la linea

c = 299792458;          % Velocidad de la luz
u0 = 4e-7*pi;           % Permeabilidad del aire
eps0 = 1/(u0*c^2);      % Espilon 0


% ----------- Cálculos-----------

% Corta
I2 = (P2/(U2*fdp2))*fdp2 - 1i*(P2/(U2*fdp2))*sin(acos(fdp2));
UI1_corta = [1 Z;0 1] * [U2;I2];
U1_corta = abs(UI1_corta(1));
I1_corta = abs(UI1_corta(2));

argU1_corta = angle(UI1_corta(1));
argI1_corta = angle(UI1_corta(2));
desfase_corta = argU1_corta - argI1_corta;
fdp1_corta = cos(desfase_corta);

% Media
I2 = (P2/(U2*fdp2))*fdp2 - 1i*(P2/(U2*fdp2))*sin(acos(fdp2));
UI1_media = [1+Z*Y/2 Z;Y*(1+Z*Y/4) 1+Z*Y/2] * [U2;I2];
U1_media = abs(UI1_media(1));
I1_media = abs(UI1_media(2));

argU1_media = angle(UI1_media(1));
argI1_media = angle(UI1_media(2));
desfase_media = argU1_media - argI1_media;
fdp1_media = cos(desfase_media);

% Larga
Zu = Z/long;
Yu = Y/long;
I2 = (P2/(U2*fdp2))*fdp2 - 1i*(P2/(U2*fdp2))*sin(acos(fdp2));
gamma = sqrt(Zu*Yu);
Zc = sqrt(Zu/Yu);
UI1 = [cosh(gamma*long) Zc*sinh(gamma*long);sinh(gamma*long)/Zc cosh(gamma*long)] * [U2;I2];
U1 = abs(UI1(1));
I1 = abs(UI1(2));

argU1 = angle(UI1(1));
argI1 = angle(UI1(2));
desfase = argU1 - argI1;
fdp1 = cos(desfase);


% ----------- Imprimir Resultados -----------
disp("")
disp("Modelo Linea Corta:")
U1_corta
I1_corta
fdp1_corta
disp("")
disp("Modelo Linea Media:")
U1_media
I1_media
fdp1_media
disp("")
disp("Modelo Linea Larga:")
U1
I1
fdp1
disp("")