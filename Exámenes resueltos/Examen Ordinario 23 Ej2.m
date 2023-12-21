%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        --------- Examen Ordinario 2023 Pr-2 ---------         %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería
disp("\nResultados: \n")


% ----------- Definimos las variables del enunciado -----------

%%% TRAFOS %%%

% Trafo: 1-2
zt12 = 0.2i;
yt12 = 1/zt12;

% Trafo: 1-5
zt15 = 0.16i;
yt15 = 1/zt15;

% Trafo: 3-4
zt34 = 0.225i;
yt34 = 1/zt34;

% Trafo: 4-6
zt46 = 0.27i;
yt46 = 1/zt46;


%%% LINEAS %%%

% Linea 2-3
z23 = [0.3i; 0.14i; 0.14i];
y23 = 1./z23;

% Linea 5-6
z56 = [0.6i; 0.35i; 0.35i];
y56 = 1./z56;

%%% GENERADORES %%%

% Generador 1
zg1 = [0.06i;0.2i;0.12i];
yg1 = 1./zg1;

% Generador 4
zg4 = [0.066i;0.33i;0.22i];
yg4 = 1./zg4;


% ----------- Cálculos -----------

% Matriz de admitancias homopolares del sistema
Yhomo = [yg1(1)    0   0   0   0   0;
        0       yt12+y23(1)    -y23(1)    0   0   0;
        0       -y23(1)    y23(1)+yt34    0   0   0;
        0       0   0       yg4(1)    0   0;
        0       0   0       0   yt15+y56(1)    -y56(1);
        0       0   0       0   -y56(1)        y56(1)+yt46];

% Matriz de admitancias directas del sistema
Ydir = [yt12+yg1(2)+yt15    -yt12       0           0                   -yt15       0;
        -yt12               yt12+y23(2) -y23(2)     0                   0           0;
        0                   -y23(2)     y23(2)+yt34 -yt34               0           0;
        0                   0           -yt34       yt34+yt46+yg4(2)    0           -yt46;
        -yt15               0           0           0                   yt15+y56(2) -y56(2);
        0                   0           0           -yt46               -y56(2)     yt46+y56(2)];

% Matriz de admitancias inversas del sistema
Yinv = [yt12+yg1(3)+yt15        -yt12   0   0   -yt15   0;
        -yt12   yt12+y23(3)    -y23(3)  0   0   0;
        0       -y23(3)    y23(3)+yt34  -yt34   0   0;
        0       0       -yt34   yt34+yt46+yg4(3)    0   -yt46;
        -yt15   0   0   0   yt15+y56(3) -y56(3);
        0                   0           0           -yt46               -y56(3)     yt46+y56(3)];

% Matrices de impedancias del sistema
Zhomo = inv(Yhomo);
Zdir = inv(Ydir);
Zinv = inv(Yinv);



%%%%% Cálculo del cortocircuito %%%%%
n = 6;              % Número de nudos
q = 5;              % Nudo donde se está produciendo el cortocircuito

% Tensiones de prefalta en los nudos del sistema
v = [   0       0       0       0       0       0;      % Homopolar
        1       1       1       1       1       1;      % Directa
        0       0       0       0       0       0];     % Inversa

% Calculamos la corriente de falta según la página 309 del libro (Tabla de cortocircuitos - Fila 3)

% Cortocircuito Fase-Tierra (Columna 2)
ifthomo = v(2,q)/(Zdir(q,q)+Zinv(q,q)+Zhomo(q,q));
iftdir = ifthomo;
iftinv = ifthomo;
ift = [ifthomo;iftdir;iftinv];

% Tensiones de falta según fila 3 tabla cortocircuitos
ufalta = zeros(3,n);
for k=1:n
    ufalta(:,k) = v(:,q)-diag([Zhomo(k,q);Zdir(k,q);Zinv(k,q)])*ift;
end

% Conversión de componentes simétricas a componentes de fase - Página 279 Libro
a = -0.5 + 0.5i*sqrt(3);
A = [1  1   1;
    1   a^2 a;
    1   a   a^2];

i56 = (ufalta(:,6)-ufalta(:,5)).*y56; % En componentes simétricas
iATT15 = ift-i56;

% Con Y-Δ o Δ-Y, el resultado está mal ya que va a producirse un desfase en el trafo
h15 = 11;
iBTT15 = iATT15.*[0;cos(-h15*pi/6)+1i*sin(-h15*pi/6);cos(h15*pi/6)+1i*sin(h15*pi/6)];

disp("Apartado A): \n")
IBTT15 = abs(A*iBTT15)

disp("\nApartado B): \n")
i56abc = abs(A*i56)

%///////Apartado C///////

disp("\nApartado C): \n")
% Calculamos el cortocircuito en bornes del generador
w = 1;
ifff = v(2,w)/Zdir(w,w);
iFFF = [0;ifff;0];

ufaltafff = zeros(3,6);
for k=1:n
    ufaltafff(:,k) = v(:,k)-diag([Zhomo(k,w);Zdir(k,w);Zinv(k,w)])*iFFF;
end

e1 = [0;1;0];
igfff = (e1-ufaltafff(:,w)).*yg1;
IGFFF = abs(A*igfff)     % Cortocircuito trifásico

xn1 = 0.0665i;
Yhomocon = [1/(zg1(1)+3*xn1)    0   0   0   0   0;
        0       yt12+y23(1)    -y23(1)    0   0   0;
        0       -y23(1)    y23(1)+yt34    0   0   0;
        0       0   0       yg4(1)    0   0;
        0       0   0       0   yt15+y56(1)    -y56(1);
        0       0   0       0   -y56(1)        y56(1)+yt46];

Zhomocon = inv(Yhomocon);

% Calculamos cortocircuito
ift = v(2,w)/(Zhomocon(w,w)+Zdir(w,w)+Zinv(w,w));
iFT = [ift;ift;ift];

ufaltaft = zeros(3,n);
for k=1:n
    ufaltaft(:,k) = v(:,k)-diag([Zhomocon(k,w);Zdir(k,w);Zinv(k,w)])*iFT;
end

igft = (e1-ufaltaft(:,w))./[(zg1(1)+3*xn1);zg1(2);zg1(3)];
IGFT = abs(A*igft)  % En componentes por fase