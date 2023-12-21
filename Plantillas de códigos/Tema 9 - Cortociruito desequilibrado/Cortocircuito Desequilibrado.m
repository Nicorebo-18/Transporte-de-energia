%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       --------- Extraido de los problemas 9 --------          %
%                    Páginas 22-30 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%% PROCESO GENRAL DE CÁLCULO %%%%%%%%%%%

% ------------------- Parámetros del Enunciado -------------------

% Variables conocidas del sistema + matrices de módulos (y) y ángulos (g) de Ybus
global  y g

% Definimos las bases principales
Sb = ;
Ub1 = ;
Ub2 = ;
Ub3 = ;

% Definimos las bases secundarias
Zb = (Ub^2)/Sb;         % Impedancia base
Yb = 1/Zb;              % Admitancia base
Ib = Sb/(sqrt(3)*Ub);   % Corriente base


% |||||| Definimos Parámetros (Z e Y) de las Lineas / Generadores / Trafos ||||||

% Ejemplo Linea: 1-2
Z12 = [ ; ; ];
Y012 = [ ; ; ];

z12 = Z12./Zb;
y12 = 1./z12;
y012 = Y012./Yb;

% Ejemplo Trafo: 3-4
S34 = ;
Z34 = [ ; ; ];
z34 = Z34*(Sb/S34)*(Ub_BT/UBTTrafo);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
y34 = 1./z34;

% Ejemplo Generador 1
zg1 = [ ; ; ]*(Sb/SGen)*(UGen/UbG)^2; % Cambio de base del generador (Si lo necesita)
yg1 = 1./zg1;

% Fuente de potencia infinita (Mantiene Tensión)
xni = 1e-120;



% ----------- Cálculos -----------

% Matriz de admitancias homopolares del sistema
Yhomo = [];

% Matriz de admitancias directas del sistema
Ydir = [];

% Matriz de admitancias inversas del sistema
Yinv = [];

% Matrices de impedancias del sistema
Zhomo = inv(Yhomo);
Zdir = inv(Ydir);
Zinv = inv(Yinv);


% |||||| Ejemplo: Cálculo Cortocircuito en el nudo 1 en sistema de 5 nudos ||||||

n = 5;              % Número de nudos
q = 1;              % Nudo donde se está produciendo el cortocircuito

% Tensiones de prefalta en los nudos del sistema
% Si nos dicen que las tensiones de prefalta son nominales = 1
% Sino, mirar si nos piden la corriente de cortocircuito máxima -> Pag. 261
v = [   0       0       0       0;      % Homopolar
        1       1       1       1;      % Directa
        0       0       0       0];     % Inversa

% Calculamos la corriente de falta según la página 309 del libro (Tabla de cortocircuitos - Fila 3)

% Columnas de la tabla: 
% Cc. Trifásico | 2ºCc. Fase-Tierra | Cc. Fase-Fase | Cc. Fase-Fase-Tierra


%   Ejemplo: Cortocircuito fase-fase-tierra (Columna 4)
ifftdir = v(2,q)/(Zdir(q,q)+(Zinv(q,q)*Zhomo(q,q)/(Zinv(q,q)+Zhomo(q,q))));
iffthomo = -ifftdir*Zinv(q,q)/(Zinv(q,q)+Zhomo(q,q));
ifftinv = -ifftdir*Zhomo(q,q)/(Zinv(q,q)+Zhomo(q,q));
ifft = [iffthomo;ifftdir;ifftinv];

% Tensiones de falta según fila 3 tabla cortocircuitos
ufalta = zeros(3,n);
for k=1:4
    ufalta(:,k) = v(:,q)-diag([Zhomo(k,q);Zdir(k,q);Zinv(k,q)])*ifft;
end

% Conversión de componentes simétricas a componentes de fase - Página 279 Libro
a = -0.5 + 0.5i*sqrt(3);
A = [1  1   1;
    1   a^2 a;
    1   a   a^2];



% |||||||||||||| Consideración: NO hay desfase producido por Transformador ||||||||||||||

% En los trafos Δ-Δ o Y-Y no se produce ningún desfase
ufalta1abc = A*ufalta(:,1);         % Tensión en el nudo 1 después del cortocircuito en componentes de fase
UFALTA1ABC = ufalta1abc*UbG/1e3;    % Tensiones en kV



% |||||||||||||| Consideración: Desfase producido por Transformador ||||||||||||||

% Con Y-Δ o Δ-Y, el resultado está mal ya que va a producirse un desfase en el trafo
h12 = 11;                           % Índice horario típico (Por si no nos dan si es un Yd11 o Dy7)
ufalta1 = A*ufalta(:,1).*[0; cos(h12*pi/6)+1i*sin(h12*pi/6); cos(-h12*pi/6)+1i*sin(-h12*pi/6)];
UFALTA1ABC_CON = ufalta1*Ub/1e3;   % Tensiones en kV