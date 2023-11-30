%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%     ---------- PROBLEMA 9-Examen 2014 (2) -----------         %
%                Cortocircuito Villabotijos                     %
%                    Clase 30/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Bases Principales
Sb = 1e6;
Ub1 = 220e3;
Ub2 = 20e3;
Ub5 = 400;
Ub7 = 400;

% Bases secundarias
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ib2 = Sb/(Ub2*sqrt(3));

% Otros datos
Dab = 1.75;
Dbc = 1.75;
Dca = 3.38;
diam = 9.45e-3;
Ru20 = 0.6136/1e3;    % Ohm/m
J = 3.7;            % A/mm2

Ru = Ru20*(1+4.03e-3*(50-20));  % Suponemos Tª max = 50ºC
Lu = 2e-7*log((Dab*Dbc*Dca)^(1/3)/(exp(-0.25)*diam/2));
Zu = Ru + 2i*pi*50*Lu;

% Lineas del sistema
y23 = [1/((3e3*Zu*3.5)/Zb2);1/((3e3*Zu)/Zb2);1/((3e3*Zu)/Zb2)];
y34 = [1/((7e3*Zu*3.5)/Zb2);1/((7e3*Zu)/Zb2);1/((7e3*Zu)/Zb2)];
y36 = [1/((18e3*Zu*3.5)/Zb2);1/((18e3*Zu)/Zb2);1/((18e3*Zu)/Zb2)];

% Transformadores
yt67 = 0.04i;
yt45 = (1/0.04i)*(2.5e6/Sb);
yt12 = (1/0.12i)*(10e6/Sb);

% Generadores
zg1 = [1e-6i;   1e-6i;  1e-6i;];
yg1 = 1./zg1;



% ----------- Cálculos -----------

% Calculamos matriz homopolar
Yhomo = [yg1(1)+yt12    0       0                       0       0       0       0;
        0               y23(1)  -y23(1)                 0       0       0       0;
        0               -y23(1) y23(1)+y36(1)+y34(1)    -y34(1) 0       -y36(1) 0;
        0               0       -y34(1)                 y34(1)  0       0       0;
        0               0       0                       -0.001i yt45    0       0;
        0               0       -y36(1)                 0       0       y36(1)  0;
        0               0       0                       0       0       -0.001i yt67];

% Matriz directa
Ydir = [yg1(2)+yt12     -yt12       0                       0           0       0           0;
        -yt12           y23(2)+yt12 -y23(2)                 0           0       0           0;
        0               -y23(2)     y23(2)+y36(2)+y34(2)    -y34(2)     0       -y36(2)     0;
        0               0           -y34(2)                 y34(2)+yt45 -yt45   0           0;
        0               0           0                       -yt45       yt45    0           0;
        0               0           -y36(2)                 0           0       y36(2)+yt67 -yt67;
        0               0           0                       0           0       -yt67       yt67];

% Matriz inversa
Yinv = [yg1(3)+yt12     -yt12       0                       0           0       0           0;
        -yt12           y23(3)+yt12 -y23(3)                 0           0       0           0;
        0               -y23(3)     y23(3)+y36(3)+y34(3)    -y34(3)     0       -y36(3)     0;
        0               0           -y34(3)                 y34(3)+yt45  -yt45  0           0;
        0               0           0                       -yt45       yt45    0           0;
        0               0           -y36(3)                 0           0       y36(3)+yt67 -yt67;
        0               0           0                       0           0       -yt67       yt67];

Zhomo = inv(Yhomo); % Para evitar warnings, en los trafos donde hemos puesto supuestamente 0, vamos a poner un valor bajo
Zdir = inv(Ydir);
Zinv = inv(Yinv);


% Tensiones de prefalta
v = [0 0 0 0 0 0 0;
    1 1 1 1 1 1 1;
    0 0 0 0 0 0 0];
q = 5;

% Cortocircuito Fase Tierra- Pag 309 columna 2
ift = v(2,q)/(Zhomo(q,q)+Zinv(q,q));

ufalta = zeros(3,7);
for k=1:7
    ufalta(:,k) = v(:,k)-diag([Zhomo(k,q);Zdir(k,q);Zinv(k,q)])*[ift;ift;ift];
end

% Tenemos que arreglarlo porque hay desfases en los trafos
ufalta6 = ufalta(:,6) .* [0; cos(11*pi/6)+1i*sin(11*pi/6); cos(-11*pi/6)+1i*sin(11*pi/6)]; % Tensión corregida pero en componentes simétricas
ufalta2 = ufalta(:,2) .* [0; cos(11*pi/6)+1i*sin(11*pi/6); cos(-11*pi/6)+1i*sin(11*pi/6)]; % Tensión corregida pero en componentes simétricas
ufalta3 = ufalta(:,3) .* [0; cos(11*pi/6)+1i*sin(11*pi/6); cos(-11*pi/6)+1i*sin(11*pi/6)]; % Tensión corregida pero en componentes simétricas

% Conversión de componentes simétricas a componentes de fase - Página 279 Libro (pag. 293 PDF)
a = -0.5 + 0.5i*sqrt(3);
A = [1  1   1;
    1   a^2 a;
    1   a   a^2];

ufalta6 = A*ufalta6;         % Tensión en componentes de fase
UFALTA6 = ufalta6*Ub2/1e3;    % Tensiones en kV

% Linea 2-3
i23 = (ufalta2-ufalta3)./Zb2;
I23 = i23*Ib2;

% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
abs(UFALTA6)



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