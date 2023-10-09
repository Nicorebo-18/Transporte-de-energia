%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 2-7 --------------             %
%                    Clase 05/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Datos
S2 = 150e6+60e6i;
S4 = 120e6+60e6i;

UATT1 = 230e3;
UATT2 = UATT1;
UATT3 = UATT1;

UBTT1 = 23e3;
UBTT2 = UBTT1;
UBTT3 = 69e3;

xT1 = 0.1i;
xT2 = xT1;
xT3 = xT1;

ST1 = 150e6;
ST2 = ST1;
ST3 = ST1;

XL = 60i;
U4 = 69e3;

% Bases iniciales
Sb = 100e6;
Ub2 = 220e3;

% Bases derivadas
Ub1 = Ub2*(UBTT1/UATT1);
Ub3 = Ub2*(UBTT3/UATT3);

Zb1 = Ub1^2/Sb;
Zb2 = Ub2^2/Sb;
Zb3 = Ub3^2/Sb;

Ib1 = Sb/(Ub1*sqrt(3));
Ib2 = Sb/(Ub2*sqrt(3));
Ib3 = Sb/(Ub3*sqrt(3));


% ----------- Cálculos -----------

% Conversion de datos a por unidad
s2 = S2/Sb;
s4 = S4/Sb;
u4 = U4/Ub3;
xl = XL/Zb2;

xt1 = xT1*(Sb/ST1)*(UATT1/Ub2)^2;
xt2 = xT1*(Sb/ST2)*(UATT2/Ub2)^2;
xt3 = xT1*(Sb/ST3)*(UATT3/Ub2)^2;

% Cálculo tension nudo u1
i23 = conj(s4/u4);
u2 = u4 + i23*(xl+xt3);

i2 = conj(s2/u2);
i12 = i2+i23;
xeq = (xt1^-1 + xt2^-1)^-1;
u1 = u2 + i12*xeq;
U1 = u1 * Ub1;


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
disp(["Tension en el nudo U1: " num2str(abs(U1)/1e3) " kV |_ " num2str(angle(U1))]) %27.062e3

% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------