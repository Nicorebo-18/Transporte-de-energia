%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       --------- PROBLEMA 5-Examen Tipo -----------            %
%                    Clase 28/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
U2 = 220e3/sqrt(3);
S = 100e6/3;
fdp2 = 0.8;
Ru = 72.1e-3/1e3;       % Ohm / m
Xu = 1i*423.2e-3/1e3;   % Ohm / m
Bu = 2693e-9/1e3;       % S / m

% ----------- Cálculos-----------
P2 = S * fdp2;
Q2 = P2 * tan(acos(fdp2));
S2 = P2 + 1i*Q2;
I2 = conj(S2/U2);

Zu = Ru + Xu;
Yu = 1i*Bu;
gamma = sqrt(Zu*Yu);
Zc = sqrt(Zu/Yu);
long = 81.817e3;        % Long

A = cosh(gamma*long);
B = Zc * sinh(gamma*long);
C = sinh(gamma*long)/Zc;
D = A;

UI1 = [A B; C D]*[U2; I2];
abs(UI1(1)) * sqrt(3)   % Debe estar entre 209kV < U1 < 231kV
delta = angle(UI1(1))  % 49.128 milirdianes < 30 grados (limite) => Estable

% ----------- Imprimir Resultados -----------
%disp("\nResultados: \n")


% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------