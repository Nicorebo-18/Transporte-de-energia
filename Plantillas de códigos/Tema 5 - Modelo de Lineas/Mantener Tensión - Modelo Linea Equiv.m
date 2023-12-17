%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      --------- Extraido del problema 5-1,2,3 ---------        %
%                       Página 6 Apuntes                        %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Variables Generales -----------

f = ;                 % Frecuencia de la red
P2 = ;            % Potencia final de la linea
fdp2 = ;           % Factor de potencia en retraso
long = ;            % Longitud de la linea (m)
Ru = /1e3;        % Resistencia unitaria (Ohm/m)
Lu = /1e3;       % Inductancia unitaria (H/m)
U2 = ;              % Tensión final de la linea
Xu = 2*pi*f*Lu;      % Reactancia Unitaria
Bu = 2*pi*f*Cu;      % Susceptancia Unitaria


%%%%%%%%%%%%%% PROCESO DE CÁLCULO %%%%%%%%%%%%%%

% 1º Elegimos modelo de linea que vamos a usar (Corta - Media - Larga)

    % ||||||||||| MODELO LINEA CORTA (< 100Km) |||||||||||
    %T = [1 Z;0 1];

    % ||||||||||| MODELO LINEA MEDIA / Modelo π nominal (100Km < Long < 200Km) |||||||||||
    %A = 1 + Z*Y/2;
    %B = Z;
    %C = Y*(1+Z*Y/4);
    %D = A;
    %T = [A B;C D];

    % ||||||||||| MODELO LINEA LARGA (> 200Km) |||||||||||
    %Zu = Ru + Xu;
    %Yu = Bu;
    %gamma = sqrt(Zu*Yu);
    %Zc = sqrt(Zu/Yu);
    %A = cosh(gamma*long);
    %B = Zc*sinh(gamma*long);
    %C = sinh(gamma*long)/Zc;
    %D = A;
    %T = [A B;C D];


% 2º Calculamos los parámetros que nos faltan de la ecuación matricial y que podemos conocer

    I2 = conj((P2 + P2*tan(acos(fdp2))*1i)/U2); % Manera alternativa de calcular 
    Zu = Ru + 2i*pi*f*Lu;                       % Impedancia por unidad de long de la linea
    Z = Zu * long;                              % Impedancia total de la linea


% 3º Aplicamos el modelo correspondiente y obtenemos los parámetros que nos faltan

    % Ecuación matricial:   [U1; I1] = T * [U2; I2]

    T = [1 Z;0 1];              % Matriz de transmisión
    U_I1 = T * [U2;I2];         % Ecuacion matricial

    U1 = abs(U_I1(1));        % Obtención del módulo del 1er elemento
    Delta_U = 100*(U1/U2-1);    % Obtención de la caida en la linea en porcentaje


% ----------- Otras fórmulas -------------

% Regulación
    % Reg = (U2vacío-U2)/U2

% Bucles de iteración
    %tol = 1e-3;                            % Tolerancia máxima
    %while abs(modU20 - 250e3) > tol        % Bucle de iteración
    %    if modU20 > 250e3                  % Condición de iteración para acercarse al valor
    %        f -= 0.01;
    %    else
    %        f += 0.01;
    %    end
    %     (...)
    %end