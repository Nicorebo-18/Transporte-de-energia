%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        --------- Examen Ordinario 2014 Pr-1 ---------         %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería

disp("\nResultados: \n")  % Imprimimos los resultados


% ----------- Definimos las variables del enunciado -----------

U = 220e3;                % Tensión nominal de la linea
f = 50;                   % Frecuencia de la red

diam = 9.45e-3;             % Diámetro aparente del conductor
r = diam/2;               % Radio del conductor

u0 = 4e-7*pi;             % Permeabilidad del aire
c = 299792458;            % Velocidad de la luz
eps0 = 1/(u0*c^2);        % Permitividad del aire

Ru20 = 0.6136/1e3;            % Resistencia del conductor (Ohm/m)
n = 1;                    % Número de conductores

Dab = 1.75;
Dbc = 1.75;
Dca = 3.38;

% ----------- Cálculos -----------

disp("\nApartado A: Impedancia Longitudinal de la Linea")  % Apartado A

% Impedancia Longitudinal
Ru = Ru20*(1+4.03e-3*(50-20));  % Suponemos Tª max = 50ºC
Lu = (u0/(2*pi))*log(((Dab*Dbc*Dca)^(1/3))/(r*exp(-1/4)));
Xu = 2*pi*f*Lu;           % Reactancia Unitaria
Zu = Ru + 1i*Xu

% Impedancia Transversal
%Cu = (2*pi*eps0)/log(((Dab*Dbc*Dca)^(1/3))/r);
%Bu = 2*pi*f*Cu           % Susceptancia Unitaria


disp("\nApartado B: Tensiones en Nudos del Sistema ")   % Apartado B

% Definimos las bases del sistema
Sb = 10e6;
Ubg = 220e3;
Ubl = 20e3;
Ubc = 400;

% Definimos las bases secundarias
Zbl = (Ubl^2)/Sb;         % Impedancia base
Ybl = 1/Zbl;              % Admitancia base
Ibl = Sb/(sqrt(3)*Ubl);   % Corriente base

Zbc = (Ubc^2)/Sb;         % Impedancia base
Ybc = 1/Zbc;              % Admitancia base
Ibc = Sb/(sqrt(3)*Ubc);   % Corriente base


% Parámetros conocidos
Ru20 = 1/1e3;                   % Resistencia del conductor (Ohm/m)
Ru = Ru20*(1+4.03e-3*(50-20));  % Suponemos Tª max = 50ºC

Lu = 1/(1e6*1e3);               % Inductancia del conductor (H/m)
Xu = 2*pi*f*Lu;                 % Reactancia Unitaria

Zu = Ru + 1i*Xu;
zu = Zu/Zbl;

%%%% Lineas del sistema %%%%

% Linea 1-2
long12 = 21e3;
z12 = zu*long12;

% Linea 1-3
long13 = 10e3;
z13 = zu*long13;

%%%% Trafos del sistema %%%%

% Trafo 1
ST1 = 10e6;
ZT1 = 0.12;
Ub_AT1 = Ubg;
UATTrafo1 = 225e3;

zt1 = ZT1*(Sb/ST1)*(Ub_AT1/UATTrafo1);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
yt1 = 1/zt1;

% Trafo 2
ST2 = 1e6;
ZT2 = 0.04;
Ub_AT2 = Ubl;
UATTrafo2 = 225e3*(20/220);

zt2 = ZT2*(Sb/ST2)*(Ub_AT2/UATTrafo2);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
yt2 = 1/zt2;

% Trafo 3
ST3 = 2.5e6;
ZT3 = 0.04;
Ub_AT3 = Ubl;
UATTrafo3 = 225e3*(20/220);

zt3 = ZT3*(Sb/ST3)*(Ub_AT3/UATTrafo3);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
yt3 = 1/zt3;


% |||||| Definimos Nudos del Sistema ||||||

% Nudo 1 - SLACK
U1 = 225e3;
u1 = U1/Ubg;
d1 = 0;


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