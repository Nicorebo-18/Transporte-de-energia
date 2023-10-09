%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-7 --------------             %
%                    Clase 25/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
R = 3;
X = 10i;
P2 = 2e6/3;
fdp2 = 0.85; %Inductivo
U2 = 11e3/sqrt(3);
Qc = -2.1e6i/3;     % Carga recativa negativa

% ----------- Cálculos-----------
Qcarga = 1i*P2*tan(acos(fdp2));
Q2 = Qcarga + Qc;
S2 = P2 + Q2;
I2 = conj(S2/U2);
I1 = I2;
Z = R + X;

% Tensión al principio de la linea
U1 = U2 + I2*Z;
absU1 = abs(U1)*sqrt(3);

% Rendimiento de la linea
S1 = U1*conj(I1);
rendimiento = 100*(P2/real(S1));

% ----------- Imprimir Resultados -----------
%printf("",) 
disp("\nResultados: \n")

absU1
rendimiento

disp("\n")