%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
% ----- Extraido del problema 2-Trafo,ExamenTrafo,Clase A ----- %
%                    Páginas 15-16 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%% Matriz de Transformación %%%%%%%%%%%

[I1; I2] = [Ycc/(t^2) -Ycc/conj(t); -Ycc/t Ycc] * [U1; U2]; % Pag 15 apuntes


%%%%%%%%%% Transformador de Módulo %%%%%%%%%%%

% Afecta a la potencia Reactiva

% Ejemplo (Clase A)
t = 1.03;
u = 0.97;
u1 = (i2*x12a*x12b+x12b+0.097i)/0.3i;
i12atrm = (u1-u2)/x12a;
i12btrm = (u1-u)/x12b;
s12atrm = u2*conj(i12atrm);
s12btrm = u2*conj(i12btrm);


%%%%%%%%%% Transformador de Fase %%%%%%%%%%%

% Afecta a la potencia Activa

% Ejemplo (Clase A)
utrd = cos(-2*pi/180) + 1i*sin(-2*pi/180);
u1trd = (i2*x12a*x12b+x12b+x12a*utrd)/(x12a+x12b);
i12atrd = (u1trd-u2)/x12a;
i12btrd = (u1trd-utrd)/x12b;
s12atrd = u2*conj(i12atrd);
s12btrd = u2*conj(i12btrd);