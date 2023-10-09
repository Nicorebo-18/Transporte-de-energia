%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-2 --------------             %
%                    Clase 18/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
f = 50;                 % Frecuencia de la red
long = 250e3;           % Longitud del cable
U2 = 132e3/sqrt(3);     % Tensión al final
D = 3;                  % Distancia entre cables en metros
r = (1.6e-2)/2;         % Radio efectivo del conductor
fdp2 = 0.8; 			% Factor de potencia en retraso
Ru = 0.11/1e3; 			% Resistencia Unitaria

c = 299792458;          % Velocidad de la luz
u0 = 4e-7*pi;           % Permeabilidad del aire
eps0 = 1/(u0*c^2);      % Espilon 0

S2 = 25e6*fdp2 + 1i*25e6*sin(acos(fdp2));     % Definimos la Potencia


% ----------- Cálculos-----------

% Apartado A
Lu = 2e-7 * log(D/(r*exp(-1/4)));	% Cálculo de la Inductancia
Cu = 2*pi*eps0/log(D/r);		% Calculo de la Capacidad
Z = (Ru + 2i*pi*f*Lu)*long;			% Impedancia Unitaria
Y = 2i*pi*f*Cu*long;				% Susceptancia Unitaria

A = 1 + Z*Y/2;
B = Z;
C = Y*(1+Z*Y/4);
D = A;

T = [A B;C D];      				% Construimos la matriz de transmisión
I2 = conj((S2/3)/(U2));	            % La potencia es trifásica
UI2 = [U2;I2];				        % La tensión que metemos en la matriz debe ser fase-neutro
UI1 = T * UI2;

U1 = abs(UI1(1));					% Hallamos el módulo para el apartado a

% Apartado B
U10 = abs(T * [85.65e3;0]);			% Método de iteración hasta obtener la misma tensión de antes
U20 = 85.65e3; 						% Tensión de vacío aplicada, obtenida del cálculo anterior
PorcentajeU2 = 100*(U20-U2)/U2;	        % Fórmula del enunciado

% ----------- Imprimir Resultados -----------
U1 						% 82.5932e3
U2
U20
PorcentajeU2 			% 12.5%