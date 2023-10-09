%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        ------------ PROBLEMA 2-Regalo --------------          %
%                    Clase 09/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
ST12 = 15e6;
UBT = 13.8e3;
UAT = 69e3;
U1 = 69e3;
Z23 = 0.19138 + 0.12119i;
Zcarga_Y = 34.45 + 91.125i;
Ucc = 0.08;

% Bases Principales
Sb = 100e6;
Ub1 = 20e3;

% Bases Derivadas
Ub2 = Ub1*(UBT/UAT);
Zb2 = Ub2^2/Sb;
Ib2 = Sb/(Ub2*sqrt(3));


% ----------- Cálculos -----------

% Variables en por unidad
zcarga = Zcarga_Y/Zb2;
z23 = Z23/Zb2;

zcc = Ucc;
rcc = zcc/sqrt(65);
xcc = sqrt(zcc^2 - rcc^2);
zT12 = rcc + 1i*xcc;
zt12 = zT12*(Sb/ST12)*(UAT/Ub1)^2;

% Cálculo de la tension en la carga
u1 = U1/Ub1;
itotal = u1/(zt12+z23+zcarga);
u3 = itotal*zcarga;
U3 = abs(u3)*Ub2/1e3;   % En kV

% Cálculo de pérdidas en la linea
perd = abs(itotal)^2*real(z23);
Pperd = perd*Sb;

% Potencia de la carga
scarga = u3*conj(itotal);
Scarga = scarga*Sb/1e3;     % En kVA

% Potencia del transformador
perdtrans = abs(itotal)^2*real(zt12);
PTrans = perdtrans*Sb/1e3;  % En kW

% Potencia del generador
pgen = real(scarga) + perd + PTrans/Sb; % Ver xq no funciona con perdtrans
Pgen = pgen*Sb;     % En W 



% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
U3
Pperd
Scarga
PTrans      % 2.4684
Pgen        % 678.7466



% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------