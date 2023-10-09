%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-1 --------------             %
%                    Clase 14/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% Definir variables
f = 50;                 % Frecuencia de la red
P2 = 5000e3;            % Potencia final de la linea
fdp2 = 0.707;           % Factor de potencia en retraso
long = 20e3;            % Longitud de la linea
Ru = 0.0195/1e3;        % Resistencia unitaria
Lu = 0.63e-3/1e3;       % Inductancia unitaria
U2 = 10e3;              % Tensión final de la linea


% Cálculos
%I21 = P2*fdp2/(U2*fdp2) + 1i*P2*sin(acos(fdp2))/(U2*fdp2);      % Corriente al final de la linea
I2 = conj((P2 + P2*tan(acos(fdp2))*1i)/U2);                     % Manera alternativa de calcular 
Zu = Ru + 2i*pi*f*Lu;    % Impedancia por unidad de long de la linea
Z = Zu * long;          % Impedancia total de la linea

U_I1 = [1 Z;0 1] * [U2;I2]; % Ecuacion matricial
U1 = abs( U_I1(1) );        % Obtención del módulo del 1er elemento
Delta_U = 100*(U1/U2-1);    % Obtención de la caida en la linea

% Imprimir Resultados
U1
Delta_U