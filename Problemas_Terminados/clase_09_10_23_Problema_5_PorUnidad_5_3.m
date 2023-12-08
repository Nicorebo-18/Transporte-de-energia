%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       --------- PROBLEMA 5-3 (Por Unidad) -----------         %
%                    Clase 09/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc                         % Borrar toda la Consola / Ventana de comandos
clear                       % Borra todas las variables
format shortEng             % Pone el formato de ingeniería


% ----------- Definir variables -----------
f = 50;                     % Frecuencia de la red
long = 400e3;               % Longitud del cable
U1 = 220e3/sqrt(3);         % Tensión al principio
Ru = 0.125e-3; 			    % Resistencia Unitaria
Xu = 0.4e-3i;               % Reactancia Unitaria
Bu = 2.8e-9i;               % Susceptancia Unitaria

% Bases Principales
Sb = 100e6;   % Pongo la base que quiero, 100MVA
Ub = U1;

% Bases Secundarias
Zb = Ub^2/Sb;
Yb = 1/Zb;
Ib = Sb/(Ub);


% ----------- Cálculos-----------

% Apartado A -----------
zu = (Ru+Xu)/Zb;
yu = Bu/Yb;

gamma = sqrt(zu*yu);
zc = sqrt(zu/yu);

i2 = 0;
u1 = U1/Ub;
U2 = 241.23e3;         % Este valor es el que hay que cambiar
u2 = U2/(Ub*sqrt(3));

A = cosh(gamma*long);
B = zc*sinh(gamma*long);
C = sinh(gamma*long)/zc;
D = A;
ui1 = [A B;C D]*[u2;i2];
I1 = abs(ui1)(2)*Ib;


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
abs(ui1)        % U1 = 1 en pu y nos da U2 = 241.23e3
I1              % 151.3726


% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------