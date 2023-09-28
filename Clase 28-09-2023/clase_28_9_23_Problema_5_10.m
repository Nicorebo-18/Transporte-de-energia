%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-10 --------------            %
%                    Clase 28/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
P2 = 3600e6/3;          % Vatios
freq = 50;              % Hercios
dist = 300e3;           % Metros
beta0 = 9.46e-4/1e3;    % rad/metro
Rc = 343;               % Ohm
U1pu = 1;
U2pu = 0.9;
delta = 36.8696;          % Grados

% ----------- Cálculos-----------
gamma = 1i*beta0;
Zc = Rc;
fdp2 = cos(delta*pi/180);
Q2 = P2 * tan(delta);
S2 = P2 + 1i*Q2;

A = cosh(gamma*dist);
B = Zc * sin(gamma*dist);



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