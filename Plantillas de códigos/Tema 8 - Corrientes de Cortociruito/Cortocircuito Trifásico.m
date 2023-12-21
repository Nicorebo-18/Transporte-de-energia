%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       --------- Extraido de los problemas 8 --------          %
%                    Páginas 21,23 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%% PROCESO GENRAL DE CÁLCULO %%%%%%%%%%%

% ------------------- Parámetros del Enunciado -------------------

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
Z12 = ;
Y012 = ;

z12 = Z12/Zb;
y12 = 1/z12;
y012 = Y012/Yb;

% Ejemplo Trafo: 3-4
S34 = ;
Z34 = ;
zt34 = Z34*(Sb/S34)*(Ub_BT/UBTTrafo);    % Poner o los dos lados de tensión (Tesion Base y del Trafo) del lado de baja o los dos de alta
yt34 = 1/zt34;

% Ejemplo Generador 1
zg1 = () *(Sb/SGen)*(UGen/UbG)^2; % Cambio de base del generador (Si lo necesita)
yg1 = 1/zg1;



% ----------- Cálculos -----------

% Matriz de admitancias del sistema
Ybus = [];

Zbus = inv(Ybus);


% |||||| Ejemplo: Cálculo Cortocircuito en el nudo 1 en sistema de 5 nudos ||||||

n = 5;              % Número de nudos
q = 1;              % Nudo donde se está produciendo el cortocircuito
v = [1 1 1 1 1];    % Tensiones de prefalta en los nudos del sistema

% Calculamos la corriente de falta según la página 309 del libro (Tabla de cortocircuitos - Primera columna)
% En este caso solo miramos la directa (Iaq,f+) ya que es simétrico el cortocircuito
ifaltaFFF(q) = v(q)/Zbus(q,q);

% Tensiones de falta según fila 3 tabla cortocircuitos (Uai,f+)
ufalta = zeros(1,n);
for k=1:n
        ufalta(1,k) = v(1,k)-Zbus(k,q)*ifaltaFFF(q);
end

% Corriente entre dos nudos del sistema - fila 4 tabla cortocircuitos (Ii-j,+)
i23 = abs((ufalta(2)-ufalta(3))*y23);

% Alternativa, sabiendo que los trafos en p.u. son una reactancia y no cambian la corriente
i23 = abs(ifaltaFFF(q));


% |||||| Otras fórmulas ||||||

% Potencia de cortocircuito
scc=abs(v(q)*conj(ifaltaFFF(5)));     % Pág 269 (283) - Fórmula 8.20   


% Corriente de falta con motores funcionando (Problema 8.2)
em = 1;         
ufalta4 = 0;    % Cuando hay cortocircuito, tensión = 0;
eg = 1;
ufalta1 = 1-ifff*Zbus(1,4);      % De la tabla de cortocircuitos
im1 = (em-ufalta4)*ym;
im2 = (eg-ufalta4)*ym;
ig = (eg-ufalta1)*yg;
iB = im1 + im2 + ig;
IB = abs(iB)*Ibm;

% Pico máximo de la corriente 
IpicoB = IB*2*sqrt(2)/1e3;      % Fórmula 8.12 - Corriente de pico (en KA)

% Corriente de un trafo
IT12BT = ifaltaFFF*Ib1/1e3;    % Resultado en KA