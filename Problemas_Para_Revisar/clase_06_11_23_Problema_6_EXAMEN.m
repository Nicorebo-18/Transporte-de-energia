%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%      ------------ PROBLEMA 6-Examen --------------         %
%                    Clase 06/11/2023                        %
%                  Nicolás Rebollo Ugarte                    %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_prob6_Ex(x)
    global u1 d1 p2 q2 p3 q3 y g  % Variables conocidas compartidas por este script

    n=3;                    %número de nudos
    %u = 
    %d = 
    %p = 
    %q = 

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

global u1 d1 p2 q2 p3 q3 y g

% Definimos las Bases del sistema
Sb = 100e6;
Ub1 = 110e3;
Ub2 = 66e3;

Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ib1 = Sb/Ub1/sqrt(3);

Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ib2 = Sb/Ub2/sqrt(3);


% Linea 1-2 a (223km)
Ru12a_20 = 0.2423/1e3;                  % Ohm/m a 20ºC
Ru12a = Ru12a_20*(1 + 4.02e-3*(80-20));    % Ohm/m a 80ºC

long12a = 223e3;
diam = 15.75e-3;
r = diam/2;
Dab = 4.4;
Dbc = 3.8;
Dca = 8.4;

u0 = 4e-7*pi;
c = 299792458;
eps0 = 1/(u0*c^2);

Lu12a = 2e-7*log((Dab*Dbc*Dca)^(1/3)/(exp(-0.25))/r)   % 1.3485e-6
Cu12a = 2*pi*eps0/log((Dab*Dbc*Dca)^(1/3)/r)         % 8.5689e-12

z12a = (Ru12a + 2*pi*50*Lu12a)*long12a/Zb1;
y012a = 2*pi*50*Cu12a/Yb1;






% Nudo 1 - SLACK
% Nudo 2 - PV
% Nudo 3 - PQ



% ----------- Cálculos -----------




% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")




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