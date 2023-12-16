%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ---------- PROBLEMA 2 Extraord-2023 -----------          %
%                    Clase 11/12/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_extraord_1(x)
    global u1 d1 p2 q2 p3 u3 y g  %variables conocidas compartidas por este script

    n=3;                    %número de nudos
    u = [u1 x(3) u3];
    d = [d1 x(4) x(6)];
    p = [x(1) p2 p3];
    q = [x(2) q2 x(5)];

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

global u1 d1 p2 q2 p3 u3 y g

z = 0.02+0.08i;
yl = 1/z;
y0 = 0.02i;

% Definimos nudos conocidos

% Nudo 1 - SLACK
u1 = 1.04;
d1 = 0;
sd1 = 2+1i;

% Nudo 2 - PQ
sg2 = 0.5+1i;
sd2 = 0;
p2 = real(sg2-sd2);
q2 = imag(sg2-sd2);

% Nudo 3 - PV
u3 = 1.04;
pg3 = 0;
sd3 = (1.5+0.6i);   % Apartado B -> *1.2
p3 = pg3-real(sd3);


% ----------- Cálculos -----------

%///////// APARTADO A /////////

Ybus = [yl+y0+y0+y0 -yl -yl;
        -yl yl+y0+yl+y0 -yl;
        -yl -yl yl+y0+yl+y0];

y = abs(Ybus);
g = angle(Ybus);

% Cálculo de nudos del sistema
x0 = [1 1 1 0 1 0];   % x0 = [p1 q1 u2 d2 q3 d3]
x = fsolve(@(x)ec_extraord_1(x), x0);
u = [u1 x(3) u3];
d = [d1 x(4) x(6)];
p = [x(1) p2 p3];
q = [x(2) q2 x(5)];

U = u.*cos(d)+1i*u.*sin(d);
S = p + 1i*q;

sd = [sd1;sd2;sd3];

i12 = (U(1)-U(2))*yl+U(1)*y0;
i21 = (U(2)-U(1))*yl+U(2)*y0;
s12 = U(1)*conj(i12)
s21 = U(2)*conj(i12)
perd12 = s12+s21

i13 = (U(1)-U(3))*yl+U(1)*y0;
i31 = (U(3)-U(1))*yl+U(3)*y0;
s13 = U(1)*conj(i13)
s31 = U(2)*conj(i13)
perd12 = s13+s31

i32 = (U(3)-U(2))*yl+U(3)*y0;
i23 = (U(2)-U(3))*yl+U(2)*y0;
s32 = U(3)*conj(i32)
s23 = U(2)*conj(i32)
perd12 = s32+s23

%///////// APARTADO B /////////
% Nudo 3 crece un 20%
% sd3 *= 1.2;

sobrecarga = 100*sqrt(real(s13)^2+imag(s31)^2)/1
%sobrecarga = 108%

%///////// APARTADO C /////////


%///////// APARTADO D /////////
% Quitar la linea 2-3 -> Nos cambia la matriz de admitancias
Ybus = [yl+y0+y0+y0 -yl -yl;
        -yl     yl+y0   0;
        -yl     0       yl+y0];

% La tensión en el nudo 2 tiene una sobrecarga (1.12 respecto a 1 p.u.)
% Linea 1-2 sobrecargada
% Pérdidas linea 2-3 son irreales, ya que deberían ser 0

% Posibles soluciones:
% - Bajar la tensión en el nudo 1 (A 0.9 por ejemplo - Tensiones y potencias bien)




% # Herramientas para imprimir en octave #

% printf("",) 
% disp() con [num2str()]

% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------