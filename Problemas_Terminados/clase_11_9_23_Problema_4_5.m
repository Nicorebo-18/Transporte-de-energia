%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 4-5 --------------             %
%                     Clase 11/09/2023                          %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% Definir variables
r = 15e-3;               % Radio del conductor
f = 50;                  % Frecuencia de la red

D_ab = 1;                % Distancia entre fases a y b
D_bc = 1;                % Distancia entre fases b y c
D_ca = 2;                % Distancia entre fases c y a
D_AB = 1;                % Distancia entre fases a' y b'
D_BC = 1;                % Distancia entre fases b' y c'
D_CA = 2;                % Distancia entre fases c' y a'
D_aB = 4;
D_Ab = 2;
D_bC = 4;
D_Bc = 2;
D_cA = 1;
D_Ca = 5;
D_aA = 3;
D_bB = 3;
D_cC = 3;

u0 = 4e-7*pi;             % Permeabilidad del aire
c = 299792458;            % Velocidad de la luz
eps0 = 1/(u0*c^2);        % Permitividad del aire
R_cond = 59.6e-3/1e3;     % Resistencia del conductor (Ohm/m)
n = 2;                    % Número de conductores por fase


% Cálculos
raiz = ((D_ab*D_aB*D_Ab*D_AB)^(1/4)*(D_bc*D_bC*D_Bc*D_BC)^(1/4)*(D_ca*D_cA*D_Ca*D_CA)^(1/4))^(1/3);


R_fase = R_cond/n;        % Resistencia unitaria de la linea por conductor
Lu = (u0/(2*pi))*log(raiz/(sqrt(r*exp(-1/4))*(D_aA*D_bB*D_cC)^(1/6))); % Inductancia
Xu = 2*pi*f*Lu;           % Reactancia Unitaria
Cu = (2*pi*eps0)/log(raiz/(sqrt(r)*(D_aA*D_bB*D_cC)^(1/6))); % Capacidad
Bu = 2*pi*f*Cu;           % Susceptancia Unitaria


% Imprimir Resultados
disp("Resultados:")
Lu                        % Sale muy cercano a 1 microHenrio por metro por lo que tiene sentido
Cu
disp("")
disp("Resultados convertidos: ")
printf("Lu = %d mH/km\n", Lu*1e3*1e3)               % Para pasar a mH/Km
printf("Cu = %d uF/Km\n", Cu*1e6*1e3)               % Para pasar a uF/Km
