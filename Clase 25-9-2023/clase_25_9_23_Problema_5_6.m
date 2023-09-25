%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-6 --------------             %
%                    Clase 25/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
U2 = 275e3/sqrt(3);
P2 = 250e6/3;
fdp2 = 0.85;

% ----------- Cálculos-----------

% Apartado A
A = 0.93 * cos(1.5*pi/180) + 0.93i * sin(1.5*pi/180);
B = 115 * cos(77*pi/180) + 115i * sin(77*pi/180);

S2 = P2 + 1i*P2*tan(acos(fdp2));
I2 = conj(S2/U2);
U1 = abs(A*U2+B*I2) * sqrt(3);

% Apartado B
Z = B;
Y_2 = (A-1)/B;
theta = angle(Z);
psi = angle(Y_2);

P2max = 3*(abs(U1)*abs(U2)/abs(Z) - abs(U2)^2*cos(theta)/abs(Z) - abs(Y_2)*abs(U2)^2*cos(psi));

% Apartado C


% ----------- Imprimir Resultados -----------
%printf("",) 
disp("\nResultados: ")
disp("\nApartado A")
U1
disp("\nApartado B")
P2max                   %695.732e+006
disp("\n")