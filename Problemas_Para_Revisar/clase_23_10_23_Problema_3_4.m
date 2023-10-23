%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 3-4 --------------             %
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


% Apartado A-1
xg = xG/Zb;
u = UG/Ub;
s = SG/Sb;

ig = conj(s*fdp + 1i*s*sin(acos(fdp)))/u;
e0 = u + ig*xg;
e1 = 0.792*abs(e0); % Si no se cambia la máquina la relacion de corriente = la de tensión
p1 = 40e6/Sb;

delta1 = asin(p1*abs(xg)/(e1*abs(u)));

q1 = (e1*abs(u)*cos(delta1)-abs(u)^2)/abs(xg);
s1 = p1 + 1i*q1;
i1 = conj(s1/u);

I1 = abs(i1)*Ib;
fdp1 = cos(angle(i1));


% Apartado A-2
e2 = 0.5927*abs(e0); % Si no se cambia la máquina la relacion de corriente = la de tensión
p2 = 40e6/Sb;

delta2 = asin(p2*abs(xg)/(e2*abs(u)));

q2 = (e2*abs(u)*cos(delta2)-abs(u)^2)/abs(xg);
s2 = p2 + 1i*q2;
i2 = conj(s2/u);

I2 = abs(i2)*Ib;
fdp2 = cos(angle(i2));


% Apartado B
emin = p1*abs(xg)/abs(u);
porc = 100*emin/abs(e0);



% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

disp("\nApartado A-1:")
I1
fdp1

disp("\nApartado A-2:")
I2
fdp2

disp("\nApartado B:")
porc




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