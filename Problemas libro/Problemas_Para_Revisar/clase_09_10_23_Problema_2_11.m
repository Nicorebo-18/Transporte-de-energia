%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 2-11 --------------            %
%                    Clase 09/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Datos Trafo 1
ST1 = 80e6;
UBTT1 = 12.2e3;
UATT1 = 161e3;
xT1 = 0.1i;

% Datos Trafo 2
ST2 = 40e6;
UBTT2 = 13.8e3;
UATT2 = 161e3;
xT2 = 0.1i;

% Definimos bases
Sb = 100e6;
Ub2 = 132e3;

% Bases secundarias
Ub1 = Ub2*(UBTT1/UATT1);
xt1 = xT1*(Sb/ST1)*(UATT1/Ub2)^2;
Ub3 = Ub2*(UBTT2/UATT2);
xt2 = xT2*(Sb/ST2)*(UATT2/Ub2)^2;

Zb2 = Ub2^2/Sb;
Ib2 = Sb/(Ub2*sqrt(3));
Zb3 = Ub3^2/Sb;
Ib3 = Sb/(Ub3*sqrt(3));

% ----------- Cálculos -----------

% Paso parámetros a por unidad
Z24 = 40 + 60i;
Z23 = 20 + 80i;
Z34 = 20 + 80i;

z24 = Z24/Zb2;
z23 = Z23/Zb2;
z34 = Z34/Zb2;

SCARGA = 50e6;
fdp = 0.8;   %  ╔═══ En Retraso (+) -> Si fuese en adelanto sería (-)
U3 = 154e3;  %  V
S3 = SCARGA*fdp + 1i*SCARGA*sin(acos(fdp));
s3 = S3/Sb;
u3 = U3/Ub3;

% Calculo de reactancia de los generadores
SG1 = 50e6;
UG1 = 12.2e3;
xG1 = 0.15i;
xg1 = xG1*(Sb/SG1)*(UG1/Ub1)^2;

SG2 = 20e6;
UG2 = 13.8e3;
xG2 = 0.15i;
xg2 = xG2*(Sb/SG2)*(UG2/Ub3)^2;

% Apartado a
i3 = conj(s3/u3);
zeq = xt1 + ((z24+z34)^-1 + z23^-1)^-1;
u1 = u3 + i3*zeq;
U1 = abs(u1)*Ub1/1e3;   % En kV

% Apartado b
zcarga = abs(u3)^2/conj(s3);
Zcarga = zcarga*Zb3;


% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

disp(["Tension en el nudo U1: " num2str(U1) " kV "]) %254.1173e3
disp(["Impedancia por unidad de carga: " num2str(zcarga) " Ohm en p.u. "]) %379.26+284.45i
disp(["Impedancia de la carga: " num2str(Zcarga) " Ohm "]) 




% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------