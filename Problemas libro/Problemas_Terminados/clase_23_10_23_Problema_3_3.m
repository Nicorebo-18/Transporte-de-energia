%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 3-3 --------------             %
%                    Clase 23/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

SG = 50e6;
UG = 30e3;
f = 50;
xG = 9i;
fdp = 0.8; % Inductivo

% Establecemos las bases
Sb = SG;
Ub = UG;

% Otras bases
Zb = Ub^2/Sb;
Ib = Sb/(Ub*sqrt(3));


% ----------- Cálculos -----------


% Apartado A
xg = xG/Zb;
u = UG/Ub;
s = SG/Sb;

ig = conj(s*fdp + 1i*s*sin(acos(fdp)))/u;
e0 = u + ig*xg;

E0 = abs(e0) * Ub;
delta0 = angle(e0);


% Apartado B
P = 25e6;
p = P/Sb;

delta1 = asin((p*abs(xg))/(abs(e0)*abs(u)));
q1 = (abs(e0)*abs(u)*cos(delta1)-abs(u)^2)/abs(xg);
s1 = p + 1i*q1;
i1 = conj(s1/u);
I1 = abs(i1)*Ib;
fdp1 = cos(angle(i1));


% Apartado C
pmax = abs(e0)*abs(u)/abs(xg)
qmax = -(abs(u))^2/abs(xg);
smax = pmax + 1i*qmax;
imax = conj(smax/u);

Pmax = pmax * Sb/1e6;
Imax = abs(imax * Ib);


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

disp("\nApartado A:")
E0
delta0

disp("\nApartado B:")
I1
fdp1

disp("\nApartado C:")
Pmax
Imax

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