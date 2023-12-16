%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 8-8 --------------             %
%                    Clase 16/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Definimos las bases
Sb = 100e6;

xG1 = 0.15i;
SG1 = 25e6;
xg1 = xG1*(Sb/SG1);
yg1 = 1/xg1;

xG2 = 0.2i;
SG2 = 50e6;
xg2 = xG2*(Sb/SG2);
yg2 = 1/xg2;

xt34 = 0.08i;
yt34 = 1/xt34;

xT12 = 0.19i;
ST12 = 40e6;
xt12 = xT12*(Sb/ST12);
yt12 = 1/xt12;

x = 2.8i;             % Valor para ir probando
y = 1/x;
yinf = 1e24;        % No usar inf, sino un numero grande
sccmax = 333e6/Sb;


% ----------- Cálculos -----------


Ybus = [yinf+yt12   -yt12       0               0;
        -yt12       yt12+y      -y              0;
        0           -y          yt34+yg1+yg2+y -yt34;
        0           0           -yt34           yt34];

Zbus = inv(Ybus);


ifff4 = 1/Zbus(4,4)
scc = 1*conj(ifff4)         % Pág 269 - Fórmula 8.20



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