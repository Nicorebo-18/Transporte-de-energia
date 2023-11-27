%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       ---------- PROBLEMA 9-Examen 2014 -----------           %
%                    Clase 27/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Generador del sistema 
xg = [0.05i;0.1i;0.1i];
xng = 0.05i;

% Trafo 1-2
xt12 = 0.05i;

% Reactancia linea 2-3
x23 = [0.4i;0.2i;0.2i;];

% Trafo 3-4
xt34 = xt12;

% Motor
xm = xg;
xnm = xng;



% ----------- Cálculos -----------

% Matrices de admitancias del circuito hoopolar
Yhomo = [1/(xg(1)+3*xng)    0               0               0;
        0                   1/xt12+1/x23(1) -1/x23(1)       0;
        0                   -1/x23(1)       1/x23(1)+1/xt34 0;
        0                   0               0               1/(xm(1)+3*xnm)];

Ydir = [1/xg(2)+1/xt12  -1/xt12         0                   0;
        -1/xt12         1/xt12+1/x23(2) -1/x23(2)           0;
        0               -1/x23(2)       -1/x23(2)+1/xt34    -1/xt34;
        0               0               -1/xt34             1/xt34+1/xm(2)];

Yinv = [1/xg(3)+1/xt12  -1/xt12         0                   0;
        -1/xt12         1/xt12+1/x23(3) -1/x23(3)           0;
        0               -1/x23(3)       -1/x23(3)+1/xt34    -1/xt34;
        0               0               -1/xt34             1/xt34+1/xm(3)];

Zhomo = inv(Yhomo);
Zdir = inv(Ydir);
Zinv = inv(Yinv);


% Producimos la falta en el nudo 2
q = 2;
v = [0 0 0 0;
    1 1 1 1;
    0 0 0 0];

ifftdir = v(2,q)/(Zdir(q,q)+(Zinv(q,q)*Zhomo(q,q)/(Zinv(q,q)+Zhomo(q,q))));   % Tabla Página 309 (Columna 4)
iffthomo = -ifftdir*Zinv(q,q)/(Zinv(q,q)+Zhomo(q,q));
ifftinv = -ifftdir*Zhomo(q,q)/(Zinv(q,q)+Zhomo(q,q));
ifft = [iffthomo;ifftdir;ifftinv];

ufalta = zeros(3,4);
for k=1:4
    ufalta(:,k) = v(:,q)-diag([Zhomo(k,q);Zdir(k,q);Zinv(k,q)])*ifft;
end

i23 = (ufalta(:,3)-ufalta(2)) ./ x23;
it12AT = ifft-i23;

h12 = 11;
it12BT = it12AT.*[0;cos(-h12*pi/6)+1i*sin(-h12*pi/6);cos(h12*pi/6)+1i*sin(h12*pi/6)];
ig = it12BT;        % Expresado en componentes simétricas

% Conversión de componentes simétricas a componentes de fase - Página 279 Libro (pag. 293 PDF)
a = -0.5 + 0.5i*sqrt(3);
A = [1  1   1;
    1   a^2 a;
    1   a   a^2];

iG = A*ig;
Ibg = 1.2e6/(600*sqrt(3));
IG = abs(iG)*Ibg;



% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
ifftdir
iffthomo
ifftinv

IG  % 7.2584 | 7.6980 | 7.2584 1e3



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