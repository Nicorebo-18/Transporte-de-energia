%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 6-1 --------------             %
%                    Clase 30/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

z12 = 0.5i;
y12 = 1/z12;


% ----------- Cálculos -----------

% Definimos la matriz
Ybus = [y12 -y12; -y12 y12];

% Nudo 1 (Nudo SLACK / Referencia)
u1 = 1;
d1 = 0;

% Nudo 2 (Nudo PQ)
pg2 = 0;
pd2 = 0.5;
p2 = pg2 - pd2;

qg2 = 1;
qd2 = 1;
q2 = qg2 - qd2;


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")




% # Herramientas para imprimir en octave #

% printf("",) 
% disp() con [num2str()]

% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------