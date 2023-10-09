%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 5-3 --------------             %
%                    Clase 21/09/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc                         % Borrar toda la Consola / Ventana de comandos
clear                       % Borra todas las variables
format shortEng             % Pone el formato de ingeniería


% ----------- Definir variables -----------
f = 50;                     % Frecuencia de la red
long = 400e3;               % Longitud del cable
U1 = 220e3/sqrt(3);         % Tensión al principio
Ru = 0.125e-3; 			    % Resistencia Unitaria
Xu = 0.4e-3i;               % Reactancia Unitaria
Bu = 2.8e-9i;               % Susceptancia Unitaria


% ----------- Cálculos-----------

% Apartado A -----------

Zu = Ru + Xu;
Yu = Bu;
gamma = sqrt(Zu*Yu);
Zc = sqrt(Zu/Yu);

A = cosh(gamma*long);
B = Zc*sinh(gamma*long);
C = sinh(gamma*long)/Zc;
D = A;

U20 = U1/A;
I10 = C*U20;
modU20 = abs(U20)
modI10 = abs(I10)

% Apartado B ------------

%tol = 0.1;
%while abs(modU20 - 235e3) > tol
%    if modU20 > 235e3
%        long -= 0.1;
%    else
%        long += 0.1;
%    end
%
%    A = cosh(gamma*long);
%    U20 = U1/A;
%    modU20 = abs(U20) * sqrt(3);
%    printf("Módulo U20 = %d; Long = %d\n", modU20, long)
%end

% Apartado C ------------

% Como la frecuencia va a cambiar, hay que ajustar los parámetros
%Lu = Xu / (2*pi*f);         % Cálculo de la Inductancia por unidad de longitud
%Cu = Bu / (2*pi*f);         % Cálculo de la Capacidad por unidad de longitud
%
%tol = 1e-3;
%while abs(modU20 - 250e3) > tol
%    if modU20 > 250e3
%        f -= 0.01;
%    else
%        f += 0.01;
%    end
%
%    xu = 2i*pi*f*Lu;
%    yu = 2i*pi*f*Cu;
%    zu = Ru + xu;
%
%    Gamma = sqrt(zu*yu);
%
%    a = cosh(Gamma*long);
%    U20 = U1/a;
%    modU20 = abs(U20) * sqrt(3)
%    f
%end


% ----------- Imprimir Resultados -----------