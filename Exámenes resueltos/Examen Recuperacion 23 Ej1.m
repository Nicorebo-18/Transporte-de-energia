%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%     --------- Examen Extraordinario 2023 Pr-1 ---------       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería

disp("\nResultados: \n")


% ------------------- Función de cálculo de potencias y tensiones -------------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_problemaExtraOrd23_1(x)
    global u1 d1 p2 q2 p3 u3 y g     % Variables conocidas compartidas en este script

    n = 3;   % Número de nudos del sistema

    % Copiar y pegar las del script
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


% ----------- Definimos las variables del enunciado -----------

% Variables conocidas del sistema + matrices de módulos (y) y ángulos (g) de Ybus
global u1 d1 p2 q2 p3 u3 y g

% |||||| Definimos Impedancias y Admitancias ||||||

% Linea: 1-2
z12 = 0.02+0.08i;
y12 = 1/z12;
y012 = 0.02i;

% Linea: 2-3
z23 = 0.02+0.08i;
y23 = 1/z23;
y023 = 0.02i;

% Linea: 1-3
z13 = 0.02+0.08i;
y13 = 1/z13;
y013 = 0.02i;


% |||||| Definimos Nudos del sistema ||||||

% Nudo 1 - SLACK
u1 = 1.04;
d1 = 0;
sd1 = 2 + 1i;
pd1 = real(sd1);
qd1 = imag(sd1);

% Nudo 2 - PQ
pg2 = 0.5;
pd2 = 0;
p2 = pg2 - pd2;

qg2 = 1;
qd2 = 0;
q2 = qg2 - qd2;

% Nudo 3 - PV
u3 = 1.04;

sd3 = 1.5+0.6i;
qd3 = imag(sd3);
pg3 = 0;
p3 = pg3 - real(sd3);



% -------------- Cálculos -----------------

% Matriz de admitancias del sistema
Ybus = [y12+y13+y012+y013   -y12    -y13;
        -y12    y12+y23+y012+y023   -y23;
        -y13    -y23    y13+y23+y013+y023];

y = abs(Ybus);
g = angle(Ybus);

% Llamada a función de cálculo

% Establecemos los valores iniciales de los parámetros a calcular
x0 = [1 1 1 0 1 0];  % p1 q1 u2 d2 q3 d3
x = fsolve(@(x)ec_problemaExtraOrd23_1(x), x0);

% Ponemos las variables que tenemos como las hemos definido y el resto como x(nº) donde nº equivale a su posición en x0
u = [u1 x(3) u3];
d = [d1 x(4) x(6)];
p = [x(1) p2 p3];
q = [x(2) q2 x(5)];

% Pérdidas Aparentes totales en las lineas
U = u.*cos(d)+1i*u.*sin(d);
S = p + 1i*q;

i12 = (U(1)-U(2))*y12+U(1)*y012;
i21 = (U(2)-U(1))*y12+U(2)*y012;
s12 = U(1)*conj(i12);
s21 = U(2)*conj(i21);
perd12 = s12+s21;

i13 = (U(1)-U(3))*y13+U(1)*y013;
i31 = (U(3)-U(1))*y13+U(3)*y013;
s13 = U(1)*conj(i13);
s31 = U(3)*conj(i31);
perd13 = s13+s31;

i23 = (U(2)-U(3))*y23+U(2)*y023;
i32 = (U(3)-U(2))*y23+U(3)*y023;
s23 = U(2)*conj(i23);
s32 = U(3)*conj(i32);
perd23 = s23+s32;

disp("Apartado A: \n")
perdreac12 = imag(perd12)
perdreac13 = imag(perd13)
perdreac23 = imag(perd23)


disp("\nApartado B: \n")

% Nudo 3
sd3 = (1.5+0.6i)*1.2;
p3 = pg3 - real(sd3);

% Volvemos a ejecutar la función
x0 = [1 1 1 0 1 0];  % p1 q1 u2 d2 q3 d3
x = fsolve(@(x)ec_problemaExtraOrd23_1(x), x0);

% Ponemos las variables que tenemos como las hemos definido y el resto como x(nº) donde nº equivale a su posición en x0
u = [u1 x(3) u3];
d = [d1 x(4) x(6)];
p = [x(1) p2 p3]
q = [x(2) q2 x(5)];

% Pérdidas Aparentes totales en las lineas
U = u.*cos(d)+1i*u.*sin(d);
S = p + 1i*q;

i12 = (U(1)-U(2))*y12+U(1)*y012;
i21 = (U(2)-U(1))*y12+U(2)*y012;
s12 = U(1)*conj(i12);
s21 = U(2)*conj(i21);
perd12 = abs(s12+s21)

i13 = (U(1)-U(3))*y13+U(1)*y013;
i31 = (U(3)-U(1))*y13+U(3)*y013;
s13 = U(1)*conj(i13);
s31 = U(3)*conj(i31);
perd13 = abs(s13+s31)

i23 = (U(2)-U(3))*y23+U(2)*y023;
i32 = (U(3)-U(2))*y23+U(3)*y023;
s23 = U(2)*conj(i23);
s32 = U(3)*conj(i32);
perd23 = abs(s23+s32)

display(['Flujo línea12 = ',num2str(abs((s12))),' p.u'])
display(['Flujo línea13 = ',num2str(abs((s13))),' p.u'])
display(['Flujo línea23 = ',num2str(abs((s23))),' p.u'])
display(['Sobrecarga línea13 = ',num2str((abs(s13)-1)/1*100),' %'])
display(['Potencia generador1 = ',num2str(abs((p(1)+pd1+q(1)*i+qd1*i))),' p.u'])
display(['Potencia generador2 = ',num2str(abs((p(2)+pd2+q(2)*i+qd2*i))),' p.u'])
display(['Potencia generador3 = ',num2str(abs((pg3+q(3)*i+qd3*i))),' p.u'])

% Posibles soluciones: Poner 2 lineas en paralelo en tramo sobrecargado / Bajar la tensión