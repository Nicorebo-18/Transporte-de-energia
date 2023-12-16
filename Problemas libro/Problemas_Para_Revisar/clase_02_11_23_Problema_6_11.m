%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 6-11 --------------            %
%                    Clase 02/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_prob6_11(x)
    global p1 u1 u2 u3 d2 p3 y g  %variables conocidas compartidas por este script

    n=3;                    %número de nudos
    u = [u1 u2 u3];
    d = [x(2) d2 x(6)];
    p = [p1 x(3) p3];
    q = [x(1) x(4) x(5)];

    f(2*n)=0;

    for h=1:n
        sumap=0;                    % Resetea variable a cero
        sumaq=0;                    % Resetea variable a cero

        for k=1:n
            sumap = sumap + (u(k)*y(h,k)*cos(d(h)-d(k)-g(h,k)));
            sumaq = sumaq + (u(k)*y(h,k)*sin(d(h)-d(k)-g(h,k)));
        end

        f(h)  =u(h)*sumap - p(h);   % ecuaciones de potencia activa
        f(h+n)=u(h)*sumaq - q(h);   % ecuaciones de potencia reactiva

    end
end


% ----------- Definir variables -----------

global p1 u1 u2 u3 d2 p3 y g  % Variables conocidas compartidas con la función

Sb = 100e6;

% Revisar variables...
y13 = 1/0.1i;
y12 = 1/0.1i;
y23a = 1/0.01i;
y023a = 0.01i;
y23b = 1/0.01i;
y023b = 0.01i;

% ----------- Cálculos -----------

Ybus = [y12+y13 -y12 -y13;
        -y12 y12+y23a+y23b+y023a+y023b -(y23a+y23b);
        -y13 -(y23a+y23b) y13+y23a+y23b+y023a+y023b];

y = abs(Ybus);
g = angle(Ybus);


% ALTERNATIVA 1
%% Nudo 1 - SLACK
%u1 = 1;
%d1 = 0;
%p1 = 1;
%
%% Nudo 3 - PV
%sd3 = (100e6+50e6i)/Sb;
%pg3 = 0;
%p3 = pg3 - real(sd3);
%u3 = 1;
%
%% Nudo 2 - PV
%pg2 = real(sd3) - p1;
%pd2 = 0;
%p2 = pg2 - pd2;

% ALTERNATIVA 2
% Nudo 1 - PV
p1 = 50e6/Sb;
u1 = 1;

% Nudo 3 - PV
sd3 = (100e6+50e6i)/Sb;
pg3 = 0;
p3 = pg3 - real(sd3);
u3 = 1;

% Nudo 2 - SLACK
u2 = 1;
d2 = 0;

% Cálculo de soluciones
x0 = [0.5 0 0.5 -0.0105 -0.003 0];   %x0 = [1 0 1 1 1 0];     % x0 = [q1 d1 p2 q2 q3 d3]
x = fsolve(@(x)ec_prob6_11(x), x0);
u = [u1 u2 u3]         % 1         1           1
d = [x(2) d2 x(6)]     % 0.01      0           -0.03
p = [p1 x(3) p3]       % 0.5       0.5         -1
q = [x(1) x(4) x(5)]   % 0.085     -0.0105     -0.03

qg3 = q(3) + imag(sd3);


% Cálculo del flujo de potencia
U = u.*cos(d) + 1i*u.*sin(d);

%   Linea 1-3
i13 = y13 * (U(1) - U(3));
i31 = y13 * (U(3) - U(1));
s13 = U(1)*conj(i13);
s31 = U(1)*conj(i31);
perd13 = s13 + s31;

%   Linea 1-2
i12 = y13 * (U(1) - U(2));
i21 = y13 * (U(2) - U(1));
s12 = U(1)*conj(i12);
s21 = U(1)*conj(i21);
perd12 = s12 + s21;

%   Linea 2-3 a
i23a = y23a * (U(2) - U(3)) + y023a*U(2);
i32a = y23a * (U(3) - U(2)) + y023a*U(3);
s23a = U(2) * conj(i23a);
s32a = U(3) * conj(i32a);
perd23a = s23a + s32a;

%   Linea 2-3 b
i23b = y23b * (U(2) - U(3)) + y023b*U(2);
i32b = y23b * (U(3) - U(2)) + y023b*U(3);
s23b = U(2) * conj(i23b);
s32b = U(3) * conj(i32b);
perd23b = s23b + s32b;


% ----------- Imprimir Resultados -----------

disp("\nResultados: \n")

% Respuestas del problema
d       % Delta i

p(1)
q(1)

p(2)
q(2)

qg3     % 0.497


% Flujo de Potencias
s13     % 0.4 + 0.008i
s31     % -0.4 + 0.008i
perd13  % 0 + 0.016i

s23a     % 0.3 - 0.0055i
s32a     % -0.3 - 0.0055i
perd23a  % 0 - 0.011i

s23b     % 0.3 - 0.0055i
s32b     % -0.3 - 0.0055i
perd23b  % 0 - 0.011i


