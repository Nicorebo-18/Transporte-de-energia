%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ------------ PROBLEMA 2 Ord-2023 --------------          %
%                    Clase 11/12/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Generadores
xg1 = [0.06i;0.2i;0.12i];
xg4 = [0.66i;0.33i;0.22i];

% Transformadores
xt12 = 0.2i;
h12 = 11;

xt15 = 0.16i;
h15 = 11;

xt34 = 0.225i;
h34 = 11;

xt46 = 0.27i;
h46 = 11;

% Lineas
x23 = [0.3i;0.14i;0.14i];
x56 = [0.6i;0.35i;0.35i];


% ----------- Cálculos -----------

% Definimos tensión prefalta
v = [0 0 0 0;
    1 1 1 1;
    0 0 0 0];

Yhomo = [yg1(1) 0           0           0   0   0;
        0       yt12+x23(1) -y23(1)     0   0   0;
        0       -y23(1)     y23(1)+yt34 0   0   0;
        0 0 0 xg4(1) 0 0;
        0   0   0   0   yt15+y56(1) -y56(1);
        0   0   0   0   -y56(1) yt46+y56(1)];

Ydir = [yg1(2)+yt12+yt15    -yt12   0   0   -yt15;
        -yt12               yt12+y23(2) -y23(2) 0   0   0;
        0                   -y23(2)     y23(2)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(2) 0 yt46;
        -yt15 0 0 0 yt15+y56(2) -y56(2);
        0 0 0 -yt46 -y56(2) y56(2)+yt46(2)];

Yinv = [yg1(3)+yt12+yt15    -yt12   0   0   -yt15;
        -yt12               yt12+y23(3) -y23(3) 0   0   0;
        0                   -y23(3)     y23(3)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(3) 0 yt46;
        -yt15 0 0 0 yt15+y56(3) -y56(3);
        0 0 0 -yt46 -y56(3) y56(3)+yt46(3)];




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