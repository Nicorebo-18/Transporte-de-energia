%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 9-5 --------------             %
%                    Clase 23/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% Modificación del problema -> Cortocircuito Fase-Tierra en Nudo 6


% ----------- Definir variables -----------

% Bases del sistema
Sb = 1000e6;
UbL = 765e3;

% Bases derivadas
ZbL = UbL^2/Sb;
IbL = Sb/(UbL*sqrt(3));

% Generadores del sistema
UbG = 15e3;
ZbG = UbG^2/Sb;
IbG = Sb/(UbG*sqrt(3));


% Impedancias del sistema

% ---Lineas---
% Forma mas extensa:
    % z23dir = 40i/ZbL;
    % z23inv = z23dir;
    % z23homo = 100i/ZbL;

% Forma mas simplificada:
z23 = [100i;40i;40i]/ZbL; 
z26 = [150i;50i;50i]/ZbL; 
z36 = [100i;40i;40i]/ZbL; 
% [Homopolar; Directa; Inversa]

y23 = 1./z23;
y26 = 1./z26;
y36 = 1./z36;


% ---Tranformadores---
zt12 = 0.1i;
zt34 = 0.12i*(Sb/500e6);
zt35 = 0.11i;
zt67 = 0.1i;

yt12 = 1/zt12;
yt34 = 1/zt34;
yt35 = 1/zt35;
yt67 = 1/zt67;

% ---Generadores---
zg1 = [0.07i;0.18i;0.18i];
zg4 = [0.05i;0.15i;0.15i]*(Sb/500e6)*(13.8e3/UbG)^2;
zg5 = [0.1i;0.3i;0.4i]*(13.8e3/UbG)^2;
zg7 = [0.1i;0.2i;0.2i];

xng4 = 0.05i;       % Impedancia Neutro-Tierra Generador 4
yng4 = 1/xng4;

yg1 = 1./zg1;
yg4 = 1./zg4;
yg5 = 1./zg5;
yg7 = 1./zg7;



% ----------- Cálculos -----------

% Matriz de admitancias homopolares
Yhomo = [yg1(1) 0                   0                       0                   0       0                   0;
        0       yt12+y23(1)+y26(1)  -y23(1)                 0                   0       -y26(1)             0;
        0       -y23(1)             y23(1)+y36(1)+yt35      0                   -yt35   -y36(1)             0;
        0       0                   0                       1/(zg4(1)+3*xng4)   0       0                   0;
        0       0                   -yt35                   0                   yt35    0                   0;
        0       -y26(1)             -y36(1)                 0                   0       yt67+y26(1)+y36(1)  0;
        0       0                   0                       0                   0       0                   1e-6i];


% Matriz de admitancias directas
Ydir = [yg1(2)+yt12 -yt12               0                           0               0           0                   0;
        -yt12       yt12+y23(2)+y26(2)  -y23(2)                     0               0           -y26(2)             0;
        0           -y23(2)             y23(2)+y36(2)+yt35+yt34   -yt34           -yt35       -y36(2)             0;
        0           0                   -yt34                       yt34+yg4(2)     0           0                   0;
        0           0                   -yt35                       0               yt35+yg5(2) 0                   0;
        0           -y26(2)             -y36(2)                     0               0           yt67+y26(2)+y36(2)  -yt67;
        0           0                   0                           0               0           -yt67               yt67+yg7(2)];


% Matriz de admitancias indirectas
Yinv = [yg1(3)+yt12 -yt12               0                           0               0           0                   0;
        -yt12       yt12+y23(3)+y26(3)  -y23(3)                     0               0           -y26(3)             0;
        0           -y23(3)             y23(3)+y36(3)+yt35+yt34     -yt34           -yt35       -y36(3)             0;
        0           0                   -yt34                       yt34+yg4(3)     0           0                   0;
        0           0                   -yt35                       0               yt35+yg5(3) 0                   0;
        0           -y26(3)             -y36(3)                     0               0           yt67+y26(3)+y36(3)  -yt67;
        0           0                   0                           0               0           -yt67               yt67+yg7(3)];

% Matrices de impedancias del sistema
Zhomo = inv(Yhomo);
Zdir = inv(Ydir);
Zinv = inv(Yinv);



% === Cortocircuito en el nudo 4 ===
q = 1;       % Nudo donde se produce el cortocircuito

% Matriz de tensiones de prefalta
v = [0 0 0 0 0 0 0;     % Componente Homopolar
    1 1 1 1 1 1 1;      % Componente Directa
    0 0 0 0 0 0 0];     % Componente Indirecta

% v(:,q) coge todos los elementos de la columna q
iff = [0; v(2,q)/(Zdir(q,q)+Zinv(q,q)); -v(2,q)/(Zdir(q,q)+Zinv(q,q))];      % Columna 3 - Tabla página 309 Libro (pag. 323 PDF)

% Apuntes pág TE26 - Cuarta fila tabla página 309 Libro (pag. 323 PDF)
ufalta = zeros(3,7);
for k=1:7
    ufalta(:,k)=v(:,k)-diag([Zhomo(k,q); Zdir(k,q); Zinv(k,q)])*iff;
end

% Conversión de componentes simétricas a componentes de fase - Página 279 Libro (pag. 293 PDF)
a = -0.5 + 0.5i*sqrt(3);
A = [1  1   1;
    1   a^2 a;
    1   a   a^2];

ufalta4abc = A*ufalta(:,4);
UFALTA4ABC = ufalta4abc*UbG/1e3;    % Tensiones en kV



% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
ufalta4abc
UFALTA4ABC




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