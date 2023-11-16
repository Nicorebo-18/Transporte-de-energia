%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 8-2 --------------             %
%                    Clase 16/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Bases principales del sistema
Sb = 25e6;
Ubg = 11e3;
UbL = 66e3;
Ubm = 6.6e3;

% Bases derivadas del sistema
ZbL = UbL^2/Sb;
Ibm = Sb/(Ubm*sqrt(3));

% Impedancias y admitancias del sistema
xg = 0.2i;
yg = 1/xg;

xt12 = 0.1i;
yt12 = 1/xt12;

x23 = 0.15i;
y23 = 1/x23;

xt34 = 0.1i;
yt34 = 1/xt34;

xm = 0.25i*(Sb/5e6);
ym = 1/xm;


% ----------- Cálculos -----------

Ybus = [yg+yt12 -yt12       0           0;
        -yt12   yt12+y23    -y23        0;
        0       -y23        y23+yt34    -yt34;
        0       0           -yt34       yt34+3*ym];

Zbus = inv(Ybus);



% Falta del sistema
q = 4;                 % Nudo donde se porduce el fallo
ifff = 1/Zbus(q,q);


em = 1;
ufalta4 = 0;
eg = 1;
ufalta1 = 1-ifff*Zbus(1,4);      % De las tablas maravillosas del tema 9

im1 = (em-ufalta4)*ym;
im2 = (eg-ufalta4)*ym;
ig = (eg-ufalta1)*yg;
iB = im1 + im2 + ig;
IB = abs(iB)*Ibm;


IpicoB = IB*2*sqrt(2)/1000       % Fórmula 8.12 - Corriente de pico (en KA)






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