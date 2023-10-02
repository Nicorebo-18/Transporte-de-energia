%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       ------------ PROBLEMA Por Unidad --------------         %
%                    Clase 02/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Bases iniciales
Sb = 23e6;          % Potencia Base
Ub1 = 17e3;         % Tensión Base 1

% Bases derivadas
Ub2 = Ub1 * 132e3/13.2e3;
Ub3 = Ub2 * 69e3/138e3;

Zb1 = Ub1^2/Sb;
Zb2 = Ub2^2/Sb;
Zb3 = Ub3^2/Sb;

Ib1 = Sb/(Ub1*sqrt(3));
Ib2 = Sb/(Ub2*sqrt(3));
Ib3 = Sb/(Ub3*sqrt(3));

% Otros datos
Ugen = 13.2e3;

zT1 = 0.1i;         % En sus bases propias
ST1 = 5e6;
UatT1 = 132e3;
UbtT1 = 13.2e3;

zT2 = 0.08i;         % En sus bases propias
ST2 = 10e6;
UatT2 = 138e3;
UbtT2 = 69e3;

ZL = 10 + 100i;
Zcarga = 300;

% ----------- Cálculos-----------

ugen = Ugen/Ub1;                        % Tension generador en p.u.
zt1 = zT1 * (Sb/ST1) * (UatT1/Ub2)^2;   % Tambien serviría con (UbtT1/Ub1)^2
zt2 = zT2 * (Sb/ST2) * (UatT2/Ub2)^2;   % Tambien serviría con (UbtT2/Ub3)^2
zl = ZL/Zb2;                            % Impedancia por unidad de la linea 2
zcarga = Zcarga/Zb3;                    % Impedancia por unidad de la carga final

isist = ugen/(zt1+zl+zt2+zcarga);       % Corriente del sistema en p.u.
ucarga = isist * zcarga;                % Tensión de la carga en p.u.
Ucarga = ucarga * Ub3;                  % Tension en la carga en su base

Igen = isist * Ib1;
Ilinea = isist * Ib2;
Icarga = isist * Ib3;

scarga = ucarga * conj(isist);
Scarga = scarga * Sb/1e6;

perd = abs(isist)^2*real(zl);
Perd = perd * Sb/1e3;

% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")
disp(['Tension en el generador: ' num2str(Ugen/1e3) ' kV |_ ' num2str(angle(Ugen))])
disp(['Tension en la carga: ' num2str(abs(Ucarga)) ' kV |_ ' num2str(angle(Ucarga))])

% # Herramientas para imprimir en octave #

% printf("",) 
% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------