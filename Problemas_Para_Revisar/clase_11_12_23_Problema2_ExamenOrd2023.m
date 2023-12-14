%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ------------ PROBLEMA 2 Ord-2023 --------------          %
%                    Clase 11/12/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Generadores
xg1 = [0.06i;0.2i;0.12i];
xg4 = [0.66i;0.33i;0.22i];
yg1 = 1./xg1;
yg4 = 1./xg4;

% Transformadores
xt12 = 0.2i;
yt12 = 1/xt12;
h12 = 11;

xt15 = 0.16i;
yt15 = 1/xt15;
h15 = 11;

xt34 = 0.225i;
yt34 = 1/xt34;
h34 = 11;

xt46 = 0.27i;
yt46 = 1/xt46;
h46 = 11;

% Lineas
x23 = [0.3i;0.14i;0.14i];
x56 = [0.6i;0.35i;0.35i];
y23 = 1./x23;
y56 = 1./x56;


% ----------- Cálculos -----------

%///////Apartado A////////

% Definimos tensión prefalta
v = [0 0 0 0 0 0;
    1 1 1 1 1 1;
    0 0 0 0 0 0];

Yhomo = [yg1(1) 0           0           0   0   0;
        0       yt12+x23(1) -y23(1)     0   0   0;
        0       -y23(1)     y23(1)+yt34 0   0   0;
        0 0 0 yg4(1) 0 0;
        0   0   0   0   yt15+y56(1) -y56(1);
        0   0   0   0   -y56(1) yt46+y56(1)];

Ydir = [yg1(2)+yt12+yt15    -yt12   0   0   -yt15       0;
        -yt12               yt12+y23(2) -y23(2) 0   0   0;
        0                   -y23(2)     y23(2)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(2) 0 yt46;
        -yt15 0 0 0 yt15+y56(2) -y56(2);
        0 0 0 -yt46 -y56(2) y56(2)+yt46];

Yinv = [yg1(3)+yt12+yt15    -yt12   0   0   -yt15       0;
        -yt12               yt12+y23(3) -y23(3) 0   0   0;
        0                   -y23(3)     y23(3)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(3) 0 yt46;
        -yt15 0 0 0 yt15+y56(3) -y56(3);
        0 0 0 -yt46 -y56(3) y56(3)+yt46];

Zhomo = inv(Yhomo);
Zdir = inv(Ydir);
Zinv = inv(Yinv);

% Calculo del cortocircuito
q = 5;
ift = v(2,q)/(Zhomo(q,q)+Zdir(q,q)+Zinv(q,q));
IFT = [ift;ift;ift];

% Necesitamos hallar la IT15 y la I56 para la ift
ufalta = zeros(3,6);
for k=1:6
    ufalta(:,k) = v(:,k)-diag([Zhomo(k,q);Zdir(k,q);Zinv(k,q)])*IFT;
end

i56 = (ufalta(:,6)-ufalta(:,5)).*y56; % En componentes simétricas
iATT15 = IFT-i56;

% Corriente de baja tension del trafo en componentes simétricas:
% - Corriente homopolar (Trafo no permite que pase); Componente Directa (Se retrasa 330º); Componente Inversa (Se adelanta 330º)
iBTT15 = iATT15.*[0;cos(-h15*pi/6)+1i*sin(-h15*pi/6);cos(h15*pi/6)+1i*sin(h15*pi/6)];
a = -0.5+0.5i*sqrt(3);
A = [1 1 1;
     1 a^2 a;
     1 a a^2];

IBTT15 = abs(A*iBTT15)  % Módulo del vector de las corrientes por fase
% Bien


%///////Apartado B////////
I56 = A*i56     % Expresado en componentes por fase
% Bien


%///////Apartado C///////
% Calculamos el cortocircuito en bornes del generador
w = 1;
ifff = v(2,w)/Zdir(w,w);
iFFF = [0;ifff;0];

ufaltafff = zeros(3,6);
for k=1:6
    ufaltafff(:,k) = v(:,k)-diag([Zhomo(k,w);Zdir(k,w);Zinv(k,w)])*iFFF;
end

e1 = [0;1;0];
igfff = (e1-ufaltafff(:,w)).*yg1;
IGFFF = A*igfff
% revisar


%///////Apartado D///////
xn1 = 0.0665i;
Yhomocon = [1/(xg1(1)+3*xn1) 0   0     	0   0   0;
        	0   yt12+x23(1) -y23(1)     0   0   0;
        	0   -y23(1)     y23(1)+yt34 0   0   0;
        	0   0 	0 	yg4(1) 			0 	0;
        	0   0   0   0   yt15+y56(1) -y56(1);
        	0   0   0   0   -y56(1) yt46+y56(1)];

Zhomocon = inv(Yhomocon);

% Calculamos cortocircuito
ift = v(2,w)/(Zhomo(w,w)+Zdir(w,w)+Zinv(w,w));
iFT = [ift;ift;ift];

ufaltaft = zeros(3,6);
for k=1:6
    ufaltaft(:,k) = v(:,k)-diag([Zhomocon(k,w);Zdir(k,w);Zinv(k,w)])*iFT;
end

igft = (e1-ufaltaft(:,w))./[(xg1(1)+3*xn1);xg1(2);xg1(3)];
IGFT = abs(A*igft) % En componentes por fase
% 4.1234
% 570.25e-3
% 570.25e-3


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")




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