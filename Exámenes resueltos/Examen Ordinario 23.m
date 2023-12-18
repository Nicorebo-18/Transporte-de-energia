%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        --------- Examen Ordinario 2023 Pr-1 ---------         %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_problema1Ord23(x)
    global u1 d1 p2 q2 p3 q3 p4 u4 y g  %variables conocidas compartidas por este script

    n=4;
    u = [u1 x(3) x(5) u4];
    d = [d1 x(4) x(6) x(8)];
    p = [x(1) p2 p3 p4];
    q = [x(2) q2 q3 x(7)];

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


global u1 d1 p2 q2 p3 q3 p4 u4 y g  %variables conocidas compartidas por este script

% Definimos las bases principales
Sb = 100e6;
Ub = 230e3;

% Definimos las bases secundarias
Zb = (Ub^2)/Sb;         % Impedancia base
Yb = 1/Zb;              % Admitancia base
Ib = Sb/(sqrt(3)*Ub);   % Corriente base

% Parámetros

% Linea 1-2
Z12 = 5.3323+26.6616i;
Y2_12 = 48.44e-6i;

z12 = Z12/Zb;
y12 = 1/z12;
y2_12 = Y2_12/Yb;

% Linea 1-3
Z13 = 3.9358+19.6788i;
Y2_13 = 36.626e-6i;

z13 = Z13/Zb;
y13 = 1/z13;
y2_13 = Y2_13/Yb;

% Linea 2-4
Z24 = 3.9358+19.6788i;
Y2_24 = 36.626e-6i;

z24 = Z24/Zb;
y24 = 1/z24;
y2_24 = Y2_24/Yb;

% Linea 3-4
Z34 = 6.7289+33.6444i;
Y2_34 = 60.255e-6i;

z34 = Z34/Zb;
y34 = 1/z34;
y2_34 = Y2_34/Yb;


% ---------- Cálculos -------------

% Matriz de admitancias
Ybus = [y12+y2_12+y13+y2_13 -y12                -y13                0;
        -y12                y12+y2_12+y24+y2_24 0                   -y24;
        -y13                0                   y13+y2_13+y34+y2_34 -y34;
        0                   -y24                -y34                y34+y2_34+y24+y2_24];

y = abs(Ybus);
g = angle(Ybus);

f = 1.2;    % Apartado c)

% Nudo 1 - SLACK
u1 = 1;
d1 = 0;
sd1 = f*(50e6+30.99e6i)/Sb;

% Nudo 2 - PQ
pgen2 = 0;
pdem2 = 170e6/Sb;
p2 = pgen2 - pdem2*f;

qgen2 = 0;
qdem2 = 105.36e6/Sb;
q2 = qgen2 - qdem2*f;

% Nudo 3 - PQ
pgen3 = 0;
pdem3 = 200e6/Sb;
p3 = pgen3 - pdem3*f;

qgen3 = 0;
qdem3 = 123.94e6/Sb;
q3 = qgen3 - qdem3*f;

% Nudo 4 - PV
u4 = 1.02;

%pgen4 = 318e6/Sb;  % Apartado a) y b)
pgen4 = 421e6/Sb;   % Apartado c)
pdem4 = 80e6/Sb;
p4 = pgen4-pdem4*f;


x0 = [1 1 1 0 1 0 1 0]; % p1 q1 u2 d2 u3 d3 q4 d4
x = fsolve(@(x)ec_problema1Ord23(x), x0);
u = [u1 x(3) x(5) u4];
d = [d1 x(4) x(6) x(8)];
p = [x(1) p2 p3 p4]
q = [x(2) q2 q3 x(7)];


disp("\nResultados: \n")

disp("Apartado a):")
PotViru = (p(1)+real(sd1))*Sb/1e6   % En MW

disp("\nApartado b):")
perd = sum(p);
PERD = perd*Sb/1e6  % En MW

disp("\nApartado c):")
pg1 = p(1)+real(sd1);
PG1 = pg1*Sb/1e6;        % Hay que buscar el 186,91

disp(["Potencia Generada nudo 4 = ",num2str(421)," MW"])