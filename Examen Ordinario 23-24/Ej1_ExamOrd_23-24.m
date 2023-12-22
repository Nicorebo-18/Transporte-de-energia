%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------- PROBLEMA 1 ---------------             %
%                    Examen Ordinario                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería

disp("\nResultados: \n")  % Imprimimos los resultados


% --------------- Definimos las variables del enunciado --------------

% Definimos bases del sistema
Ub=400e3;
Sb=100e6;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);

U1 = 400e3;                  % Tensión nominal de la linea
f = 50;                     % Frecuencia de la red

diam = 25.4e-3;             % Diámetro del conductor
r = diam/2;                 % Radio del conductor

u0 = 4e-7*pi;               % Permeabilidad del aire
c = 299792458;              % Velocidad de la luz
eps0 = 1/(u0*c^2);          % Permitividad del aire

Ru = 85.1/1e6;              % Resistencia del conductor a Tª nominal (mOhm/km -> Ohm/m)
n = 3;                      % Número de conductores por fase

long0 = 400.5e3/2;          % Distancia del punto medio de la linea en metros

d = 0.4;                  % Distancia del Haz (Entre cables de la msima fase)
D_ab = 10.8;
D_bc = 10.8;
D_ca = 15.3;


% ------------------ Cálculos de los apartados ------------------

% Suponemos que es una linea asimétrica triplex
Rc = Ru/n;
Lu = (u0/(2*pi))*log(((D_ab*D_bc*D_ca)^(1/3))/((r*exp(-1/4)*d^2)^(1/3))); % Inductancia
Cu = (2*pi*eps0)/log(((D_ab*D_bc*D_ca)^(1/3))/((r*d^2)^(1/3)));           % Capacidad

Xu = 2i*pi*f*Lu;      %Ohm
Yu = 2i*pi*f*Cu;      %S
Zu = Ru+Xu;           %Ohm/m

% Pasamos todo a por unidad
zu = Zu/Zb;
yu = Yu/Yb;
u1 = U1/Ub;

zc = sqrt(zu/yu);
gamma = sqrt(zu*yu);

u2 = u1/cosh(gamma*long0);        % Tensión extremo receptor en vacío en pu
disp(['Tension en mitad de la linea en vacio = ' num2str(abs(u2)*Ub/1e3) ' kV'])

% Por si no se ejecuta, salida de octave:
%
% Resultados:
%
% Tension en mitad de la linea en vacio = 409.1326 kV  