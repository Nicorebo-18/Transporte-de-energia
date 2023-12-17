%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%    ------- Extraido del problema 5-6,7,10,11,Ex --------      %
%                     Páginas 8-10 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%%%%%%%%%%%%% COMENTARIOS GENERALES %%%%%%%%%%%%%%%%%%%%%%%
% Límite: delta < 30 grados (limite) => Estable

% Si nos dan Beta y Rc (Pág 10 apuntes):
    % gamma = 1i*beta;
    % Zc = Rc;


%%%%%%%%%%%%%%%%%%%%% POSIBLES PROBLEMAS %%%%%%%%%%%%%%%%%%%%%%%

% |||||||||||||||||| Potencia Máxima Transmisible ||||||||||||||||||
% Obtenemos los parámetros a partir del modelo de linea media
Z = B;
Y_2 = (A-1)/B;

% Obtenemos los respectivos ángulos
theta = angle(Z);
psi0 = angle(Y_2);

% Para maximizar la potencia, coseno debe ser máximo e igual a 1
% Tensiones deben ser por fase (En p.u. da igual) y Ptot = 3*Pfase
P2max = 3*(abs(U1/sqrt(3))*abs(U2)/abs(Z) - abs(U2)^2*cos(theta)/abs(Z) - abs(Y_2)*abs(U2)^2*cos(psi0));

% |||||||||||||||||| Potencia Reactiva Adicional  ||||||||||||||||||
fdpcarga = 0.8;      % Inductivo
P2 = 400e6*fdpcarga/3;
Qcarga = 1i*P2*tan(acos(fdpcarga));
Q2 = -68.75e6i/3;      % Iteración de potencia reactiva hasta mantener la tensión deseada

I2 = conj((P2+Q2)/U2);
U1 = abs(A*U2+B*I2) * sqrt(3)   % Iteración hasta mantener la tensión deseada
Qc = Q2 - Qcarga;
modQc = abs(Qc*3) 

% |||||||||||||||||| Compensación de la linea ||||||||||||||||||

% Condensador en serie:
% Tc = [1 Zc;0 1]

% Condensador en paralelo:
% Tc = [1 0;Yc 1]

% Ecuación matricial (Antes->Serie, Después->Paralelo):
% [U1;I1] = [1 Zc;0 1]*[A B;C D]*[1 0;Yc 1] * [U2;I2]

% ----------- Otras fórmulas -------------

% Rendimiento
    % η = 100*P2/P1 en %
