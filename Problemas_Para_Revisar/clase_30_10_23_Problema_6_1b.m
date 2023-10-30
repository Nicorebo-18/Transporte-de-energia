%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 6-1b --------------            %
%                    Clase 30/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_prob6_1b(x)
    global u1 u2 d1 p2 q2 y g  %variables conocidas compartidas por este script

    n=2;                    %número de nudos
    u = [u1 u2];            %idem que en script principal        
    d = [d1 x(4)];          %idem
    p = [x(1) p2];          %idem
    q = [x(2) x(3)];        %idem

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

global u1 u2 d1 p2 q2 y g  % Variables conocidas compartidas con la función

z12 = 0.5i;
y12 = 1/z12;


% ----------- Cálculos -----------

% Definimos la matriz
Ybus = [y12 -y12; -y12 y12];
y = abs(Ybus);
g = angle(Ybus);

% Nudo 1 (Nudo SLACK / Referencia)
u1 = 1;
d1 = 0;

% Nudo 2 (Nudo PQ)
u2 = 1;
pg2 = 0;
pd2 = 0.5;
p2 = pg2 - pd2;

qg2 = 1;
qd2 = 1;
q2 = qg2 - qd2;

sd2 = pd2 + 1i*qd2;

% Cálculo de los nudos
x0 = [0.5 0 1 0];       % [p1 q1 q2 d2]
x = fsolve(@(x)ec_prob6_1b(x), x0);
u = [u1 u2];
d = [d1 x(4)];
p = [x(1) p2];
q = [x(2) x(3)];

% Cálculo del flujo de potencia
U = u .* cos(d) + 1i*u .* sin(d);       % Símbolo .* significa multiplicar elemento a elemento de 2 matrices

i12 = (U(1)-U(2))/z12;
i21 = (U(2)-U(1))/z12;
s12 = U(1)*conj(i12);
s21 = U(2)*conj(i21);

perd12 = s12 + s21;

S = p + 1i*q;
sg2 = S(2) + sd2;


% ----------- Imprimir Resultados -----------

disp("\nResultados: \n")
x       % 0.5       63.5083e-3      63.5083e-3      -252.6803e-3

s12     % 0.5       63.5083e-3 i
s21     % -0.5      63.5083e-3 i
perd12  % 0         127.0167e-3 i

sg2     % 0         1.0635 i