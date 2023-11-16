%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 8-6 --------------             %
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
Ub1 = 10e3;
Ub2 = 138e3;
Ub5 = 15e3;

% Bases Derivadas
Zb2 = Ub2^2/Sb;


xg1 = 0.2i*(Sb/50e6)*(12e3/Ub1)^2;
yg1 = 1/xg1;
xg5 = 0.2i*(Sb/100e6)*(15e3/Ub5)^2;
yg5 = 1/xg5;
xt12 = 0.1i*(Sb/50e6)*(138e3/Ub2)^2;
yt12 = 1/xt12;
xt45 = 0.1i*(Sb/100e6)*(138e3/Ub2)^2;
yt45 = 1/xt45;
x23 = 40i/Zb2;
y23 = 1/x23;
x34 = 40i/Zb2;
y34 = 1/x34;


% ----------- Cálculos -----------

Ybus = [yg1+yt12    -yt12       0           0           0;
        -yt12       yt12+y23    -y23        0           0;
        0           -y23        y23+y34     -y34        0;
        0           0           -y34        y34+yt45    -yt45;
        0           0           0           -yt45       yg5+yt45];

Zbus = inv(Ybus)


v = 1;
ifff5 = v/Zbus(5,5)
eg5 = 1;
ig5 = eg5*yg5
ig1 = ifff5-ig5



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