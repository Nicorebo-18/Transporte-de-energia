%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-3 --------------             %
%                    Clase 18/09/2023                           %
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


% ----------- Cálculos-----------
Zu = Ru + Xu;
Yu = Bu;
gamma = sqrt(Zu*Yu);
Zc = sqrt(Zu/Yu);

A = cosh(gamma*long);
B = Zc*sinh(gamma*long);
C = sinh(gamma*long)/Zc;
D = A;

U20 = U1/A;
I10 = C*U20;
modU20 = abs(U20);
modI10 = abs(I10);


% ----------- Imprimir Resultados -----------
modI10
modU20