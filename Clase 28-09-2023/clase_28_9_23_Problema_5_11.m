%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA X-X --------------             %
%                    Clase XX/XX/2023                           %
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
Q2 = S2 * tan(acos(fdp2));
S2total = P2 + 1i * Q2;
I2 = conj(S2total/U2);
UI1 = [A B;C D] * [U2;I2];




% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
UI1
abs(UI1(1))*sqrt(3)     % 622.15e3
abs(UI1(2))             % 794.64


% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------