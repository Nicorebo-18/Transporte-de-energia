%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-11 --------------            %
%                    Clase 28/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
A = 0.86;
B = 130.2i;
C = 0.002i;
D = A;
S2 = 1000e6/3;
U2 = 500e3/sqrt(3);
fdp2 = 0.8;     % En retraso


% ----------- Cálculos-----------

% Apartado A
P2 = S2 * fdp2;
Q2 = P2 * tan(acos(fdp2)); % KTZ -> Poner Para la tangente la pot activa no la total
S2total = P2 + 1i * Q2;
I2 = conj(S2total/U2);
UI1_a = [A B;C D] * [U2;I2];

% Apartado B
Xc = -50i;
Tc = [1 Xc; 0 1];
TL = [A B; C D];
UI1_b = Tc * TL * Tc * [U2;I2];


% ----------- Imprimir Resultados -----------
disp("Resultados:")

disp("\nApartado A")
%UI1_a
abs(UI1_a(1))*sqrt(3)     % 622.15e3
abs(UI1_a(2))             % 794.64

disp("\nApartado B")
%UI1_b
abs(UI1_b(1))*sqrt(3)     % 530.75e3
abs(UI1_b(2))             % 891.1416

% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------