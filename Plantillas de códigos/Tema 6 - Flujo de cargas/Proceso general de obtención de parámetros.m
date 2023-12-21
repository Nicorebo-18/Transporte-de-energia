%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       --------- Extraido de los problemas 6 --------          %
%                    Páginas 18-21 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%% PROCESO GENRAL DE CÁLCULO %%%%%%%%%%%

% ------------------- Función de cálculo de potencias y tensiones -------------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_problemaX(x)
    global   % Variables conocidas compartidas en este script

    n = ;   % Número de nudos del sistema

    % Copiar y pegar las del script
    u = [];
    d = [];
    p = [];
    q = [];

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


% ------------------- Parámetros del Enunciado -------------------

% Variables conocidas del sistema + matrices de módulos (y) y ángulos (g) de Ybus
global  y g

% Definimos las bases principales
Sb = ;
Ub = ;

% Definimos las bases secundarias
Zb = (Ub^2)/Sb;         % Impedancia base
Yb = 1/Zb;              % Admitancia base
Ib = Sb/(sqrt(3)*Ub);   % Corriente base

% |||||| Definimos Parámetros (Z e Y) de las Lineas / Generadores / Trafos ||||||

% Ejemplo Linea: 1-2
Z12 = ;
Y012 = ;

z12 = Z12/Zb;
y12 = 1/z12;
y012 = Y012/Yb;

% Ejemplo Trafo: 3-4
S34 = ;
Z34 = ;
z34 = Z34*(Sb/S34)*(Ub_BT/UBTTrafo);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
y34 = 1/z34;

% Ejemplo Generador 1
zg1 = () *(Sb/SGen)*(UGen/UbG)^2; % Cambio de base del generador (Si lo necesita)
yg1 = 1/zg1;



% |||||| Definimos Nudos del Sistema: SLACK / PQ / PV ||||||
% Para las potencias reactivas no ponemos la i, pero para las totales (s) si

% Nudo - SLACK
u = 1;
d = 0;
sd = (P+Qi)/Sb;

% Nudo - PQ
pg = /Sb;
pd = /Sb;
p = pg - pd;

qg = /Sb;
qd = /Sb;
q = qg - qd;

% Nudo - PV
u = ;

pg = /Sb;
pd = /Sb;
p = pg - pd;



% -------------- Cálculos -----------------

% Matriz de admitancias del sistema
Ybus = [];  % Para las Admitancias tranversales (y0 ponerlas solo en las del nudo qq)

y = abs(Ybus);
g = angle(Ybus);



% Llamada a función de cálculo

% Establecemos los valores iniciales de los parámetros a calcular
x0 = [];     % Ponemos las 2 variables de cada nudo que nos falta por calcular (Orden: p - q - u - d)
x = fsolve(@(x)ec_problemaX(x), x0);

% Ponemos las variables que tenemos como las hemos definido y el resto como x(nº) donde nº equivale a su posición en x0
u = [];
d = [];
p = [];
q = [];


% |||||| Otras Fórmulas ||||||

% Potencia generada por nudo 1 en MW
Potgen1 = (p(1) + real(sd1))*Sb/1e6;   % En MW

% Pérdidas totales en las lineas
perd = sum(p);
PERD = sum(p)*Sb/1e6;  % En MW

% Tensiones y Potencias Aparentes del sistema con ángulos
U = u.*cos(d)+1i*u.*sin(d);
S = p + 1i*q;

i12 = (U(1)-U(2))*ylinea12+U(1)*y012;
i21 = (U(2)-U(1))*ylinea12+U(2)*y012;
s12 = U(1)*conj(i12);   % Flujo de Potencia de la linea 12
s21 = U(2)*conj(i21);
perd12 = s12+s21;       % Pérdidas de la linea 12

% Potencia Aparente Generada
potenciagenerador = p(1)+pd1 + q(1)*i+qd1*i;  % Como p1 = pg1-pd1 si le sumamos pd1 nos queda la generada

% Sobrecarga
Sobrecarga_linea13 = (abs(s13)-1)/1*100;    % Posibles soluciones: Poner 2 lineas en paralelo en tramo sobrecargado / Bajar la tensión

% Linea se desconecta
y12=0;
y012=0;