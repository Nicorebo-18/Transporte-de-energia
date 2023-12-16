%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 6-5 --------------            %
%                    Clase 06/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_prob6_5(x)
    global u1 d1 p2 q2 p3 q3 p4 q4 p5 u5 y g  %variables conocidas compartidas por este script

    n=3;                    %número de nudos
    u = [u1 x(3) x(5) x(7) u5]; 
    d = [d1 x(4) x(6) x(8) x(10)];
    p = [x(1) p2 p3 p4 p5];
    q = [x(2) q2 q3 q4 x(9)]; 

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

global u1 d1 p2 q2 p3 q3 p4 q4 p5 u5 y g  % Variables conocidas compartidas con la función

Sb = 100e6;

y12 = 1/0.066i;
y14 = 1/0.1i;
y25 = 1/0.05i;
y35 = 1/0.0625i;
y45 = 1/0.055i;

ycc23 = 1/0.04i;

% TRM - Trafo Regulacion Módulo
%t = 0.975;

% TRD - Trafo Regulacion Fase (Genérico)
theta = 5*pi/180;
relacion = 0.975;
t = relacion*cos(theta) + 1i*relacion*sin(theta);


% ----------- Cálculos -----------

yt22 = ycc23/abs(t)^2;
yt23 = ycc23/conj(t);
yt32 = ycc23/t;
yt33 = ycc23;

Ybus = [y12+y14 -y12 0 -y14 0;          % Se cumple simetría porque es de módulo
        -y12 y12+y25+yt22 -yt23 0 -y25;
        0 -yt32 y35+yt33 0 -y35;
        -y14 0 0 y14+y45 -y45;
        0 -y25 -y35 -y45 y25+y35+y45];

y = abs(Ybus);
g = angle(Ybus);

u1 = 1.01;
d1 = 0;

sg2 = 0;
sd2 = (60e6+35e6i)/Sb;
p2 = real(sg2 - sd2);
q2 = imag(sg2 - sd2);

sg3 = 0;
sd3 = (70e6 + 42e6i)/Sb;
p3 = real(sg3 - sd3);
q3 = imag(sg3 - sd3);

sg4 = 15e6i/Sb;
sd4 = (80e6+50e6i)/Sb;
p4 = real(sg4 - sd4);
q4 = imag(sg4 - sd4);

pg5 = 190e6/Sb;
sd5 = (65e6 + 36e6i)/Sb;
p5 = pg5 - real(sd5);
u5 = 1;

% Cálculo de soluciones
x0 = [1 1 1 0 1 0 1 0 1 0];
x = fsolve(@(x)ec_prob6_5(x), x0);
u = [u1 x(3) x(5) x(7) u5];      % 1.01      0.9862      1.001       0.9906      1
d = [d1 x(4) x(6) x(8) x(10)];   % 0         -0.0318     -0.0415     -0.0370     -0.0132
p = [x(1) p2 p3 p4 p5];          % 0.85      -0.6        -0.7        -0.8        1.25
q = [x(2) q2 q3 q4 x(9)];        % 0.5749    -0.35       -0.24       -0.35       0.4469




% Cálculo de flujos de potencias

U = u .* cos(d) + 1i*u .* sin(d);   % Vector de módulos con argumentos

% Linea 1-2
i12 = y12*(U(1)-U(2));
i21 = y12*(U(2)-U(1));
s12 = U(1)*conj(i12);
s21 = U(2)*conj(i21);
perd12 = s12 + s21;

% Linea 1-4
i14 = y14*(U(1)-U(4));
i41 = y14*(U(4)-U(1));
s14 = U(1)*conj(i14);
s41 = U(4)*conj(i41);
perd14 = s14 + s41;

% Linea 2-5
i25 = y25*(U(2)-U(5));
i52 = y25*(U(5)-U(2));
s25 = U(2)*conj(i25);
s52 = U(5)*conj(i52);
perd25 = s25 + s52;

% Linea 3-5
i35 = y35*(U(3)-U(5));
i53 = y35*(U(5)-U(3));
s35 = U(3)*conj(i35);
s53 = U(5)*conj(i53);
perd35 = s35 + s53;

% Linea 4-5
i45 = y45*(U(4)-U(5));
i54 = y45*(U(5)-U(4));
s45 = U(4)*conj(i45);
s54 = U(5)*conj(i54);
perd45 = s45 + s54;



% Linea 2-3 (TRAFO)     ->     Ecuación 2.33 - libro pág 55
i23 = yt22*U(2) - yt23*U(3);
i32 = yt32*U(2) + yt33*U(3);
s23 = U(2)*conj(i23);
s32 = U(3)*conj(i32);
perd23 = s23 + s32;



% ----------- Imprimir Resultados -----------

disp("\nResultados: \n")

u
d
p
q