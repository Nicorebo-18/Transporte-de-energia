%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%      ------------ PROBLEMA 6-Examen --------------         %
%                    Clase 09/11/2023                        %
%                  Nicolás Rebollo Ugarte                    %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ------------ Funciones ------------
% - Para ejecutarlo en Octave, poner esta sección al principio del script
% - Para ejecutarlo en Matlab, poner esta sección al final del script

function f = ec_prob6_Ex(x)
    global u1 d1 p2 q2 p3 q3 p4 q4 y g  % Variables conocidas compartidas por este script

    n=4;                    %número de nudos
    u = [u1 x(3) x(5) x(7)];
    d = [d1 x(4) x(6) x(8)];
    p = [x(1) p2 p3 p4];
    q = [x(2) q2 q3 q4];

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

global u1 d1 p2 q2 p3 q3 p4 q4 y g

%%%%% Definimos las Bases del sistema %%%%%
Sb = 100e6;
Ub1 = 110e3;
Ub2 = 66e3;

Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ib1 = Sb/Ub1/sqrt(3);

Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ib2 = Sb/Ub2/sqrt(3);


%%%%% Linea 1-2 a (223km) %%%%%
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

Lu12a = 2e-7*log((Dab*Dbc*Dca)^(1/3)/(exp(-0.25))/r);    % 1.3485e-6
Cu12a = 2*pi*eps0/log((Dab*Dbc*Dca)^(1/3)/r);            % 8.5689e-12

z12a = (Ru12a + 2i*pi*50*Lu12a)*long12a/Zb1;
y12a = 1/z12a;
y012a = 2*pi*50*Cu12a*long12a/(2*Yb1);



%%%%% Linea 1-2 b (279km) %%%%%
long12b = 279e3;
i12bmax = 405*2/Ib1;

n = 2;                                      % Numero de conductores por fase
Ru12b_20 = 0.2423/1e3/n;                    % Ohm/m de un conductor a 20ºC
Ru12b = Ru12a_20*(1 + 4.02e-3*(80-20));     % Ohm/m a 80ºC´

diam12b = 15.75e-3;
r12b = diam12b/2;
Dab12b = 5;
Dbc12b = 5;
Dca12b = 10;
d = 0.4;     % Distancia entre centros de los conductores de la fase

Lu12b = 2e-7*log((Dab12b*Dbc12b*Dca12b)^(1/3)/sqrt(exp(-0.25)*r12b*d));
Cu12b = 2*pi*eps0/log((Dab12b*Dbc12b*Dca12b)^(1/3)/sqrt(r12b*d));

zu12b = (Ru12b + 2i*pi*50*Lu12b)/Zb1;
yu12b = 2i*pi*50*Cu12b/(2*Yb1);

gamma = sqrt(zu12b*yu12b);
zc = sqrt(zu12b/yu12b);

z12b = zc*sinh(gamma*long12b);
y012b = tanh(gamma*long12b/2)/zc;
y12b = 1/z12b;



%%%%% Linea 3-4 (62km) %%%%%
long34 = 62e3;
i34max = 465*2/Ib2;

Ru34 = 0.1963*(1 + 4.02e-3*(80-20))/1e3/2;     % Ohm/m a 80ºC - 2 cond./fase

Dab = sqrt((2.15-1.7)^2 + 1.8^2);
DAB = Dab;
DAb = sqrt((2.15+1.7)^2 + 1.8^2);
DaB = DAb;
Dbc = Dab;
DBC = Dab;
DBc = DAb;
DbC = DAb;
Dca = 1.8*2;
DCA = Dca;
DCa = 1.7*2;
DcA = DCa;
DaA = sqrt((2*1.8)^2+(1.7*2)^2);
DbB = 2*2.15;
Dcc = DaA;

% Formulas de Lu y Cu larguisimas
Lu34 = 1e-6;        % 2e-7*log( [...]
Cu34 = 10e-12;      % 2*pi*eps0 [...]

z34 = (Ru34+2i*pi*50*Lu34)*long34/Zb2;
y34 = 1/z34;
y034 = 2i*pi*50*Cu34*long34/(2*Yb2);




%%%%% Transformador 2-3 %%%%%
ST23 = 50e6;
zT23 = 0.002 + 0.06i;
UAT23 = 110e3;
UBT23 = 66e3;
zt23 = zT23*(Sb/ST23)*(UAT23/Ub1)^2;
yt23 = 1/zt23;

m = 0.9;                  % Módulo de la relación de transformación
theta = 0*pi/180;       % Argumento de la relacion de transformación
t = m*(cos(theta) + 1i*sin(theta));

y22 = yt23/abs(t)^2;
y23 = yt23/conj(t);
y32 = yt23/t;
y33 = yt23;

% Matriz de admitancias del sistema
Ybus = [y12a+y012a+y12b+y012b -(y12a+y12b) 0 0;
        -(y12a+y12b) y12a+y012a+y12b+y012b+y22 -y23 0;
        0 -y32 y33+y34+y034 -y34;
        0 0 -y34 y34+y034];

y = abs(Ybus);
g = angle(Ybus);




%%%%%% NUDO 1 %%%%% - SLACK
u1 = 120e3/Ub1;
d1 = 0;
sd1 = 0.7e6*(1 + 1i*tan(acos(0.87)))/Sb;



%%%%%% NUDO 2 %%%%% - PQ
sg2 = 10e6i/Sb;
sd2 = (40e6+1i*10e6)/Sb; % Si desconectamos la fábrica -> # No sirve, sube demasiado la tensión #
p2 = real(sg2-sd2);
q2 = imag(sg2-sd2);



%%%%%% NUDO 3 %%%%% - PQ
sg3 = 0;
sd3 = 0;
p3 = real(sg3-sd3);
q3 = imag(sg3-sd3);



%%%%%% NUDO 4 %%%%% - PQ
sg4 = 8e6i/Sb;              % Puede ser: 2,4,6,8 MVAr

% Curva de demanda
%sd4 = 3e6*(1+1i*tan(acos(0.85)))/Sb;        % 23:00 - 06:00
%sd4 = 12e6*(1+1i*tan(acos(0.95)))/Sb;       % 06:00 - 09:30
%sd4 = 6e6*(1+1i*tan(acos(0.9)))/Sb;         % 09:30 - 16:30
sd4 = 20e6*(1+1i*tan(acos(0.95)))/Sb;       % 16:30 - 22:00 % Desconexión y cambio trafo
%sd4 = 6e6*(1+1i*tan(acos(0.9)))/Sb;         % 22:00 - 23:00

p4 = real(sg4 - sd4);
q4 = imag(sg4 - sd4);







% ----------- Cálculos -----------
x0 = [1 1 1 0 1 0 1 0];      % x0 = [p1 q1 u2 d2 u3 d3 u4 d4]
x = fsolve(@(x)ec_prob6_Ex(x), x0);
u = [u1 x(3) x(5) x(7)]    % 1.01      0.9862      1.001       0.9906      1
d = [d1 x(4) x(6) x(8)]    % 0         -0.0318     -0.0415     -0.0370     -0.0132
p = [x(1) p2 p3 p4]        % 0.85      -0.6        -0.7        -0.8        1.25
q = [x(2) q2 q3 q4]        % 0.5749    -0.35       -0.24       -0.35       0.4469







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
