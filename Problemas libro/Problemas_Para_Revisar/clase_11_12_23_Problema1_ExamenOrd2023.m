%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ------------ PROBLEMA 1 Ord-2023 --------------          %
%                    Clase 11/12/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería

% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_probOrd23(x)
    global u1 d1 p2 q2 p3 q3 p4 u4 y g  %variables conocidas compartidas por este script

    n=4;                    %número de nudos
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




function f = ec_probOrd23_apc_metodoB(x)
    global p1 d1 p2 q2 p3 q3 p4 u4 y g  %variables conocidas compartidas por este script

    n=4;                    %número de nudos
    u = [u1 x(3) x(5) u4];
    d = [x(2) x(4) x(6) d4];   
    p = [p1 p2 p3 x(7)]; 
    q = [x(1) q2 q3 x(8)];

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

global u1 d1 p2 q2 p3 q3 p4 u4 y g  % Variables conocidas compartidas con la función


% Bases principales del sistema
Sb = 100e6;
Ub = 230e3;

% Bases derivadas del sistema
Zb = Ub^2/Sb;
Yb = 1/Zb;
Ib = Sb/(Ub*sqrt(3));

% Impedancias del sistema

% Linea 1-2
Z12 = 5.3323+26.6616i;
z12 = Z12/Zb;
y12 = 1/z12;
y012 = 48.44e-6i/Yb;

% Linea 1-3
Z13 = 3.9358+19.6788i;
z13 = Z13/Zb;
y13 = 1/z13;
y013 = 36.626e-6i/Yb;

% Linea 2-4
Z24 = Z13;
z24 = z13;
y24 = 1/z24;
y024 = y013;

% Linea 3-4
Z34 = 6.7289+33.6444i;
z34 = Z34/Zb;
y34 = 1/z34;
y034 = 60.255e-6i/Yb;


% Potencias y tensiones
u1 = 1;
d1 = 0;
sd1 = (50e6+30.99e6i)/Sb;
p2 = -170e6/Sb;
q2 = -105.35e6/Sb;
p3 = -200e6/Sb;
q3 = -123.94e6/Sb;
p4 = (318e6-80e6)/Sb;
u4 = 1.02;


% ----------- Cálculos -----------

% Matriz de admitancias
Ybus = [y12+y012+y13+y013   -y12                -y13                0;
        -y12                y12+y012+y24+y024    0                  -y24;
        -y13                0                   y13+y013+y34+y034   -y34;
        0                   -y24                -y34                y24+y024+y34+y034];

y = abs(Ybus);
g = angle(Ybus);

x0 = [1 1 1 0 1 0 1 0]; %p1 q1 u2 d2 u3 d3 q4 d4
x = fsolve(@(x)ec_probOrd23(x), x0);
u = [u1 x(3) x(5) u4];
d = [d1 x(4) x(6) x(8)];   
p = [x(1) p2 p3 p4]
q = [x(2) q2 q3 x(7)];


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

disp("Apartado a):")
% Tension en el nudo de Virulandia (Nudo 1)
pg1 = p(1)+real(sd1);
PG1 = pg1*Sb/1e6        % En MW   -> 186.9139MW

disp("\nApartado b):")
% Pérdidas de Silvania - Libro pag. 170 (184)
perd = sum(p);
PERD = perd*Sb/1e6  % En MW   ->  4.9139MW


disp("\nApartado c):")

% Método A

sd1 = (50e6+30.99e6i)*1.2/Sb;
p2 = -170e6*1.2/Sb;
q2 = -105.35e6*1.2/Sb;
p3 = -200e6*1.2/Sb;
q3 = -123.94e6*1.2/Sb;
p4 = (421e6-80e6*1.2)/Sb;

x0 = [1 1 1 0 1 0 1 0]; %p1 q1 u2 d2 u3 d3 q4 d4
x = fsolve(@(x)ec_probOrd23(x), x0);
u = [u1 x(3) x(5) u4];
d = [d1 x(4) x(6) x(8)];   
p = [x(1) p2 p3 p4]; 
q = [x(2) q2 q3 x(7)];

pg1 = p(1)+real(sd1);
PG1 = pg1*Sb/1e6;        % Hay que buscar el 186,91
disp(["Metodo A -> p4 = ",num2str(421)," MW"])






% Método B

%sd1 = (50e6+30.99e6i)*1.2/Sb;
%u1 = 1;
%p1 = 186.9139e6/Sb-real(sd1);
%p2 = -170e6*1.2/Sb;
%q2 = -105.35e6*1.2/Sb;
%p3 = -200e6*1.2/Sb;
%q3 = -123.94e6/Sb;
%u4 = 1.02;
%d4 = 0;
%
%% Matriz de admitancias
%Ybus = [y12+y012+y13+y013   -y12                -y13                0;
%        -y12                y12+y012+y24+y024    0                  -y24;
%        -y13                0                   y13+y013+y34+y034   -y34;
%        0                   -y24                -y34                y24+y024+y34+y034];
%
%y = abs(Ybus);
%g = angle(Ybus);
%
%x0 = [1 0 1 0 1 0 1 1]; %q1 d1 u2 d2 u3 d3 q4 d4
%x = fsolve(@(x)ec_probOrd23_apc_metodoB(x), x0);
%u = [u1 x(3) x(5) u4];
%d = [x(2) x(4) x(6) d4];   
%p = [p1 p2 p3 x(7)]; 
%q = [x(1) q2 q3 x(8)];
%
%pg4 = p(4)+real(sd4);
%PG4 = pg4*Sb/1e6;
%disp(["Metodo B -> p4 = ",num2str(PG4)," MW"])