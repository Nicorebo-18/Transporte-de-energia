%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%     ---------- PROBLEMA 9-Examen 2014 (2) -----------         %
%                    Clase 30/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería



% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_villabotijos(x)
    global u1 d1 p2 q2 p3 q3 p4 q4 p5 q5 p6 q6 p7 q7 y g  %variables conocidas compartidas por este script

    n=7;                    %número de nudos
    u = [u1 x(3) x(5) x(7) x(9) x(11) x(13)];
    d = [d1 x(4) x(6) x(8) x(10) x(12) x(14)];
    p = [x(1) p2 p3 p4 p5 p6 p7];
    q = [x(2) q2 q3 q4 q5 q6 q7];

    f(2*n)=0;

    for h=1:n
        sumap=0;                    % Resetea variable a cero
        sumaq=0;                    % Resetea variable a cero

        for k=1:n
            sumap = sumap + (u(k)*y(h,k)*cos(d(h)-d(k)-g(h,k)));
            sumaq = sumaq + (u(k)*y(h,k)*sin(d(h)-d(k)-g(h,k)));
        end

        f(h)  =u(h)*sumap - p(h);   % ecuaciones de potencia activa
        f(h+n)=u(h)*sumaq - q(h);   % ecuaciones de potencia reactiva

    end
end



% ----------- Definir variables -----------

global u1 d1 p2 q2 p3 q3 p4 q4 p5 q5 p6 q6 p7 q7 y g  % Variables conocidas compartidas con la función

% Bases Principales
Sb = 1e6;
Ub1 = 220e3;
Ub2 = 20e3;
Ub5 = 400;
Ub7 = 400;

% Bases secundarias
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;

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
y23 = 1/((3e3*Zu)/Zb2);
y34 = 1/((7e3*Zu)/Zb2);
y36 = 1/((18e3*Zu)/Zb2);

% Transformadores
yt67 = 0.04i;
yt45 = (1/0.04i)*(2.5e6/Sb);
yt12 = (1/0.12i)*(10e6/Sb);


% ----------- Cálculos -----------

Ybus = [yt12    -yt12       0           0           0       0           0;
        -yt12   yt12+y23    -y23        0           0       0           0;
        0       -y23        y23+y34+y36 -y34        0       -y36        0;
        0       0           -y34        y34+yt45    -yt45   0           0;
        0       0           0           -yt45       yt45    0           0;
        0       0           -y36        0           0       y36+yt67    -yt67;
        0       0           0           0           0       -yt67       yt67];

y = abs(Ybus);
g = angle(Ybus);

% Potencias del sistema
u1 = 225e3/Ub1;
d1 = 0;
p2 = 0;
q2 = 0;
p3 = 0;
q3 = 0;
p4 = 0;
q4 = 0;
p5 = -2e6/Sb;
q5 = -1.1e6/Sb;
p6 = 0;
q6 = 0;
p7 = -0.6e6/Sb;
q7 = -0.2e6/Sb;

% Resolvemos el sistema de ecuaciones
x0 = [1 1 1 0 1 0 1 0 1 0 1 0 1 0]; % [p1 q1 u2 d2 u3 d3 u4 d4 u5 d5 u6 d6 u7 d7]
x = fsolve(@(x)ec_villabotijos(x), x0);
u = [u1 x(3) x(5) x(7) x(9) x(11) x(13)]
d = [d1 x(4) x(6) x(8) x(10) x(12) x(14)]
p = [x(1) p2 p3 p4 p5 p6 p7]
q = [x(2) q2 q3 q4 q5 q6 q7]


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