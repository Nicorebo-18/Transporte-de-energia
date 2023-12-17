%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      --------- Extraido del problema 4-11 ----------          %
%                     Páginas 3-4 Apuntes                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

S = ;              % Potencia Nominal de la linea
U = ;                % Tensión nominal de la linea
long = ;              % Longitud total de la linea
perd = ;           % Porcentaje de pérdidas admisibles
rho = ;            % Resistividad eléctrica del conductor

% ----------- Cálculos -----------

perdidas_max = perd*S;                      % Pérdidas admisibles totales
I = S/(sqrt(3)*U);                          % Hallamos la corriente nominal de la linea
r_fase = perdidas_max/(3*I^2)               % Resistencia por fase
diametro = sqrt((rho*long*4)/(pi*r_fase));  % Cálculo del diámetro mínimo del conductor
