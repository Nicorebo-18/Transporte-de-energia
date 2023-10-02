%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA X-X --------------             %
%                    Clase 02/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Bases iniciales
Sb = 150e6;         % Potencia Base
Ub1 = 69e3;         % Tensión Base 1

% Bases derivadas
Ub2 = Ub1 * 132e3/13.2e3;
Ub3 = Ub2 * 69e3/138e3;

Zb1 = Ub1^2/Sb;
Zb2 = Ub2^2/Sb;
Zb3 = Ub3^2/Sb;

Ib1 = Sb/(Ub1*sqrt(3));
Ib2 = Sb/(Ub2*sqrt(3));
Ib3 = Sb/(Ub3*sqrt(3));

% Otros datos
Ugen = 13.2e3;

zT1 = 0.1i;         % En sus bases propias
ST1 = 5e6;
UatT1 = 132e3;
UbtT1 = 13.2e3;

zT2 = 0.08i;         % En sus bases propias
ST2 = 10e6;
UatT2 = 138e3;
UbtT2 = 69e3;

ZL = 10 + 100i;
Zcarga = 300;


% ----------- Cálculos-----------



% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")


% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------