%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        --------- Extraido del problema 3-3 ---------          %
%                    Páginas 16-17 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%% PARÁMETROS DE LA MÁQUINA SÍNCRONA %%%%%%%%%%%

% Corriente de excitación
ig = conj(s * fdp + 1i * s * sin(acos(fdp))) / u;

% Fem interna
e0 = u + ig * xg;

% Ángulo de fase de la fem interna
delta0 = angle(e0);

% Cálculos relacionados con la corriente y la potencia
delta1 = asin((p * abs(xg)) / (abs(e0) * abs(u)));
q1 = (abs(e0) * abs(u) * cos(delta1) - abs(u)^2) / abs(xg); % Hay que usar los módulos, tanto en la P como en la Q
s1 = p + 1i * q1;
i1 = conj(s1 / u);
fdp1 = cos(angle(i1));

% Valores máximos de potencia, corriente y aparente
pmax = abs(e0) * abs(u) / abs(xg);
qmax = -(abs(u))^2 / abs(xg);

% Potencias máximas en unidades específicas
Pmax = pmax * Sb / 1e6; % MegaWatts
Imax = abs(imax * Ib);   % Amperios