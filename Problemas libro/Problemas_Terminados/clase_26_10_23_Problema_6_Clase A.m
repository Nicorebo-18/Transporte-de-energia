%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        ---------- PROBLEMA 6 - Clase A ----------             %
%                    Clase 26/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

Sb = 100e6;

% Transformador 1-2
S12 = 600e6;
Z12 = 0.003+0.0226i;
z12 = Z12*(Sb/S12);
y12 = 1/z12;

% Linea 1-3
z13 = 0.00092+0.01044i;
y13 = 1/z13;
y013 = 0.39839i/2;

% Linea 2-5
z25 = 0.0046+0.0238i;
y25 = 1/z25;
y025 = 0.0666i/2;

% Transformador 1-2
S34 = 600e6;
Z34 = 0.003+0.0226i;
z34 = Z34*(Sb/S34);
y34 = 1/z34;

% Linea 4-5
z45 = 0.00289+0.01653i;
y45 = 1/z45;
y045 = 0.02742i/2;

% Linea 5-6
z56 = 0.0079+0.0249i;
y56 = 1/z56;
y056 = 0.0687i/2;



% ------------ Linea 5-6 b ------------------
% Sólo me tengo que fijar en aquellos en los que están involucrados el 5 o el 6

%z56b = 0.0079+0.0249i;
%y56b = 1/z56b;
%y056b = 0.0687i/2;


% ------------ Linea 1-7 + Trafo -------------

% Transformador 1-7
S17 = 600e6;
Z17 = 0.003+0.0226i;
z17 = Z17*(Sb/S17);
y17 = 1/z17;

% Linea 5-6
z67 = 0.0079+0.0249i;
y67 = 1/z67;
y067 = 0.0687i/2;




% ----------- Cálculos -----------

% Construcción de la matriz de admitancias
Y11 = y12 + y13 + y013 + y17;                   % Añadimos Trafo 1-7
Y12 = -y12;
Y13 = -y13;
Y14 = 0;                                        % No hay conexión directa
Y15 = 0;
Y16 = 0;
Y17 = -y17;

Y21 = Y12;
Y22 = y12 + y25 + y025;
Y23 = 0;
Y24 = 0;
Y25 = -y25;
Y26 = 0;
Y27 = 0;

Y31 = Y13;
Y32 = Y23;
Y33 = y13 + y013 + y34;
Y34 = -y34;
Y35 = 0;
Y36 = 0;
Y37 = 0;                                        % Añadimos Elementos 1-7

Y41 = Y14;
Y42 = Y24;
Y43 = Y34;
Y44 = y45 + y045 + y34;
Y45 = -y45;
Y46 = 0;
Y47 = 0;                                        % Añadimos Elementos 1-7

Y51 = Y15;
Y52 = Y25;
Y53 = Y35;
Y54 = Y45;
Y55 = y25 + y025 + y45 + y045 + y56 + y056;     % + y56b + y056b;    =>    % Añadimos el elemento 5-6 b
Y56 = -y56;                                     % -(y56 + y56b);    =>    % Añadimos el elemento 5-6 b
Y57 = 0;

Y61 = Y16;
Y62 = Y26;
Y63 = Y36;
Y64 = Y46;
Y65 = Y56;
Y66 = y56 + y056;                               % + y56b + y056b;    =>    % Añadimos el elemento 5-6 b
Y67 = -y67;

% Añadimos fila 7
Y71 = Y17;
Y72 = Y27
Y73 = Y37
Y74 = Y47
Y75 = Y57
Y76 = Y67
Y77 = y17 + y67 + y067;



% Construimos la matriz
Ybus = [Y11 Y12 Y13 Y14 Y15 Y16 Y17;
        Y21 Y22 Y23 Y24 Y25 Y26 Y27;
        Y31 Y32 Y33 Y34 Y35 Y36 Y37;
        Y41 Y42 Y43 Y44 Y54 Y46 Y47;
        Y51 Y52 Y53 Y54 Y55 Y56 Y57;
        Y61 Y62 Y63 Y64 Y65 Y66 Y67;
        Y71 Y72 Y73 Y74 Y75 Y76 Y77];




% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
Ybus



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