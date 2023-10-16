%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ---------- PROBLEMA Ensayo -------------             %
%                    Clase 16/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

Ucc = 6.61; % V
Icc = 7.87; % A
P = 80.9;   % W

%Definimos Bases
Ub = 220;
Sb = 3e3;

% Bases secundarias
Zb = Ub^2/Sb;
Ib = Sb/(Ub*sqrt(3));

% ----------- Cálculos -----------
ucc = Ucc/Ub;
zcc = ucc;
corriente = Icc/Ib;
p = P/Sb;

r = p;
z = ucc/corriente;
x = sqrt(z^2-r^2);
zt = r + 1i*x;

Zt = zt * Zb;

Zcc = zcc*Zb;

% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
Zt      % Valor Real
abs(Zt)

Zcc     % Aproximación ucc = zcc



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