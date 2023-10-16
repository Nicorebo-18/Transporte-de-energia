%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%    ------ PROBLEMA Trafo Examen (Pág 14 Apuntes) -------      %
%                    Clase 16/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

U1 = 46e3;
Zl = 1 + 4i;
Long = 10e3;

Sc = 4e6;
fdpc = 0.8;     % Inductivo
U3 = 13.2e3;

ST = 12e6;
Pcu = 0.01;
ucc = 0.1;

t = 0.95;  % Si t = 1 estamos en la relación nominal
% No se puede afinar a 46kV porque son tomas discretas

% Definimos bases
Sb = ST;
Ub1 = t * U1;

% Bases secundarias
Ub2 = 13.8e3;
Zb2 = Ub2^2/Sb;

% ----------- Cálculos -----------
rT = Pcu;
zT = ucc;
xT = sqrt(zT^2-rT^2);
zt = (rT + 1i*xT)*(Sb/12e6)*(46e3/Ub1)^2;
zl = Zl/Zb2;

u3 = 13.2e3/Ub2;
Scarga = Sc*fdpc + 1i*Sc*sin(acos(fdpc));
scarga = Scarga/Sb;

i3 = conj(scarga/u3);
u1 = u3 + i3*(zl+zt);
U1 = abs(u1)*Ub1;       % Obtenemos que con t=1 tiene que ser un poco más grande de 46kV


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

U1
disp("\nHay que escoger la toma numero 5\n")


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