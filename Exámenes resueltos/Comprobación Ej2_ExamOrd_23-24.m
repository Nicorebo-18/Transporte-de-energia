%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          -------------- PROBLEMA 2 --------------             %
%                     Examen Ordinario                          %
%                   Nicolás Rebollo Ugarte                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería

disp("\nResultados: \n")  % Imprimimos los resultados


% ----------- Definimos las variables del enunciado -----------

% Definimos las bases principales
Sb = 100e6;
Ub = 220e3;

% Otras bases
Sb5 = 318e6;
Sb6 = 318e6;
Ub5 = 15.75e3;
Ub6 = 15.75e3;

% Definimos las bases secundarias
Zb = (Ub^2)/Sb;         % Impedancia base
Yb = 1/Zb;              % Admitancia base
Ib = Sb/(sqrt(3)*Ub);   % Corriente base


% |||||| Definimos Parámetros de las Lineas / Generadores / Trafos ||||||

%%%%% Lineas %%%%%

% Linea 1-2
Z12 = 0.01405 + 0.05193i;
z12 = [2.5*Z12; Z12; Z12];
y12 = 1./z12;
y012 = 251.3e-6i;

% Linea 1-3
Z13 = 0.00439 + 0.01622i;
z13 = [2.5*Z13; Z13; Z13];
y13 = 1/z13;
y013 = 78.54e-6i;

% Linea 2-3
Z23 = 0.00878 + 0.02596i;
z23 = [2.5*Z23; Z23; Z23];
y23 = 1/z23;
y023 = 157.1e-6i;

% Linea 2-4
Z24 = 0.00703 + 0.02596i;
z24 = [2.5*Z24; Z24; Z24];
y24 = 1/z24;
y024 = 125.7e-6i;

% Linea 3-4
Z34 = 0.01054 + 0.03895i;
z34 = [2.5*Z34; Z34; Z34];
y34 = 1/z34;
y034 = 188.5e-6i;

%%%%% Transformadores %%%%%

% Trafo: 3-5
S35 = 250e6;
Z35 = 0.1267i;
zt35 = Z35*(Sb/S35);
yt35 = 1/zt35;

% Trafo: 4-6
S46 = 250e6;
Z46 = 0.1267i;
zt46 = Z46*(Sb/S46); 
yt46 = 1/zt46;

%%%%% Generadores %%%%%

% Generador 1
zg1 = [0.0104i; 0.026i; 0.026i];    % En bases del Sistema
yg1 = 1./zg1;

% Generador 3
SbG3 = 318e6;
zg3 = [0.098i; 0.187i; 0.276i].*(Sb/SbG3);
yg3 = 1./zg3;

% Generador 4
SbG4 = 318e6;
zg4 = [0.098i; 0.187i; 0.276i].*(Sb/SbG4); 
yg4 = 1./zg4;

% ----------- Cálculos -----------

% Despreciamos todas las admitancias y cargas transversales (y0__)

% Matriz de admitancias del sistema
Ydir = [yg1(2)+y12(2)+y13(2)    -y12(2)                 -y13(2)                     0                   0           0;
        -y12(2)                 y12(2)+y24(2)+y23(2)    -y23(2)                     -y24(2)             0           0;
        -y13(2)                 -y23(2)                 y23(2)+y13(2)+y34(2)+yt35   -y34(2)             -yt35       0;
        0                       -y24(2)                 -y34(2)                     y24(2)+y34(2)+yt46  0           yt46;
        0                       0                       -yt35                       0                   yt35+yg3(2) 0;
        0                       0                       0                           -yt46               0           yt46+yg4(2)];

Zdir = inv(Ydir);


% |||||| Cálculo Cortocircuito en el nudo 3 ||||||

n = 6;                          % Número de nudos
q = 3;                          % Nudo donde se está produciendo el cortocircuito
upf = 242e3/Ub;                 % Tensión de prefalta en por unidad
v = [upf upf upf upf upf upf];  % Tensiones de prefalta en los nudos del sistema

% Calculamos la corriente de falta según la página 309 del libro (Tabla de cortocircuitos - Primera columna)
% En este caso solo miramos la directa (Iaq,f+) ya que es simétrico el cortocircuito
ifaltaFFF(q) = v(q)/Zdir(q,q);

% Tensiones de falta según fila 3 tabla cortocircuitos (Uai,f+)
ufalta = zeros(1,n);
for k=1:n
    ufalta(1,k) = v(1,k)-Zdir(k,q)*ifaltaFFF(q);
end

% Corriente entre dos nudos del sistema - fila 4 tabla cortocircuitos (Ii-j,+)
i13 = abs((ufalta(1)-ufalta(3))*y13(2))
i23 = abs((ufalta(2)-ufalta(3))*y23(2));
i34 = abs((ufalta(3)-ufalta(4))*y34(2));

display(['Corriente de pico linea 1-3 = ',num2str(i13*Ib*2*sqrt(2)/1e3),' kA'])
display(['Corriente de pico linea 2-3 = ',num2str(i23*Ib*2*sqrt(2)/1e3),' kA'])
display(['Corriente de pico linea 3-4 = ',num2str(i34*Ib*2*sqrt(2)/1e3),' kA'])




%% Calculamos el cortocircuito en bornes del generador
%w = 1;
%ifff = v(2,w)/Zdir(w,w);
%iFFF = [0;ifff;0];
%
IfaltaFFF = [0; v(q)/Zdir(q,q); 0];
ufaltafff = zeros(3,6);
for k=1:n
    ufaltafff(:,k) = v(:,k)-diag([0;Zdir(k,q);0])*IfaltaFFF;
end

a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
   1 a^2 a;
   1 a a^2];

Ib5 = Sb5/(sqrt(3)*Ub5);   % Corriente base zona generador 3

ifaltag3=IfaltaFFF-i13-i23-i34;%en componentes simétricas
IFaltag3=abs(A*ifaltag3); %módulo de las corrientes por fase en p.u.
IFaltag3(1)*Ib5*2*sqrt(2)/1e3







