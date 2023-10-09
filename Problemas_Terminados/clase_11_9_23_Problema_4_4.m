%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 4-4 --------------             %
%                     Clase 11/09/2023                          %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% Definir variables
U = 500e3;                % Tensión nominal de la linea
f = 50;                   % Frecuencia de la red
diam = 30e-3;             % Diámetro del conductor
d = 0.5;                  % Distancia del Haz
D_ab = 15;                % Distancia entre fases a y b
D_bc = 15;                % Distancia entre fases b y c
u0 = 4e-7*pi;             % Permeabilidad del aire
c = 299792458;            % Velocidad de la luz
eps0 = 1/(u0*c^2);        % Permitividad del aire
D_ca = D_ab + D_bc;       % Distancia entre fases
r = diam/2;               % Radio del conductor
R_cond = 59.6e-3/1e3;     % Resistencia del conductor (Ohm/m)
n = 2;                    % Número de conductores


% Cálculos
R_fase = R_cond/n;        % Resistencia unitaria de la linea por fase (2 fases)
Lu = (u0/(2*pi))*log(((D_ab*D_bc*D_ca)^(1/3))/(n*r*exp(-1/4)*d/(2*sin(pi/n)))^(n-1)); % Inductancia
Xu = 2*pi*f*Lu;           % Reactancia Unitaria
Cu = (2*pi*eps0)/log(((D_ab*D_bc*D_ca)^(1/3))/(n*r*exp(-1/4)*d/(2*sin(pi/n)))^(n-1)); % Capacidad
Bu = 2*pi*f*Cu;           % Susceptancia Unitaria


% Imprimir Resultados
Lu                        % Sale muy cercano a 1 microHenrio por emtro por lo que tiene sentido
Xu
Cu
Bu



