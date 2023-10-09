%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 4-11 --------------            %
%                     Clase 11/09/2023                          %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería

% Definir variables
S = 190.5e6;              % Potencia Nominal de la linea
U = 220e3;                % Tensión nominal de la linea
long = 63e3;              % Longitud total de la linea
perd = 2.5/100;           % Porcentaje de pérdidas admisibles
rho = 2.84e-8;            % Resistividad eléctrica del conductor

% Cálculos
perdidas_max = perd*S;    % Pérdidas admisibles totales
I = S/(sqrt(3)*U);        % Hallamos la corriente nominal de la linea
r_fase = perdidas_max/(3*I^2)    %Resistencia por fase
diametro = sqrt((rho*long*4)/(pi*r_fase));  %Cálculo del diámetro del conductor

diametro;                 %Imprimimos el resultado



