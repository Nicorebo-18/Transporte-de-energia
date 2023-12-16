%Examen ordinario 2013/14 Iñaki Orradre
clear
clc
format shortEng
%Valores asignados transformadores
Snt12 = 10e6;
UATt12 = 220e3;
UBTt12 = 20e3;
Snt34 = 2.5e6;
UATt34 = 20e3;
UBTt34 = 0.4e3;
Snt56 = 1e6;
UATt56 = 20e3;
UBTt56 = 0.4e3;
%Bases del sistema por unidad
Sb = 100e6;
Ub1 = 220e3; %entrada a la subestación
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ub2 = Ub1*UBTt12/UATt12; %líneas de media tensión
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ub3 = Ub2*UBTt34/UATt34; %puntos de consumo
Ib3 = Sb/Ub3/sqrt(3);
Zb3 = Ub3^2/Sb;
Yb3 = 1/Zb3;
%% Problema 1: Cálculo de los parámetros de las líneas de distribución
%Se trata de una línea aérea trifásica asimétrica de un circuito y un
%conductor por fase
%Constantes empleadas para el cálculo
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Datos de la línea
Dab = sqrt(((3.36/2-(0.55+0.673/cosd(15)))/sind(15)+0.673/sind(15))^2+3.36^2);
Dbc = Dab;
Dac = 3.36; %Distancias entre conductores
radio = sqrt(30/pi)*1e3/2; %Radio de los conductores, equivalente en cobre
Rc = 0.6136e-3*(1+(3.93e-3*(80-20))); %Resistencia del conductor por unidad de longitud Ohm/m, a 80 ºC

R = Rc; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/(radio*exp(-0.25)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/radio); %Capacidad de la línea por unidad de longitud C/m
X = R + 2i*pi*f*L; %Impedancia de la línea por unidad de longitud, Ohm/m
B = 2i*pi*f*C;
disp(['Impedancia de la línea por unidad de longitud: ' num2str(X) ' Ohmios/m'])
disp(['Susceptacia capacitiva de la línea por unidad de longitud: ' num2str(B) ' Siemens/m'])
%% Problema 2: Cálculo de tensiones en todos los nudos del sistema.
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script
%Parámetros del circuito equivalente por unidad en secuencia directa
xt12 = 0.12i*Sb/Snt12*(UATt12/Ub1)^2;
yt12 = 1/xt12;
xt45 = 0.04i*Sb/Snt34*(UATt34/Ub2)^2;
yt45 = 1/xt45;
xt67 = 0.04i*Sb/Snt56*(UATt56/Ub2)^2;
yt67 = 1/xt67;
z23 = (1+2*pi*50*1e-3*1i)*3/Zb2;
y23 = 1/z23;
z34 = (1+2*pi*50*1e-3*1i)*7/Zb2;
y34 = 1/z34;
z36 = (1+2*pi*50*1e-3*1i)*18/Zb2;
y36 = 1/z36;
%Inicializaciones previas al cálculo
n = input('Número de nudos: ');
Tipo = zeros(n,1);
u0 = zeros(n,1);
d0 = zeros(n,1);
p0 = zeros(n,1);
q0 = zeros(n,1);
x0 = zeros(n*2,1); %Vector de soluciones iniciales para comenzar la iteración
%% Nudos del sistema
for k = 1:1:n
    Tipo(k) = input(['Nudo ' num2str(k) ': Slack (1), PV (2), PQ (3) ']);
    switch Tipo(k)
        case 1
            u0(k) = input(['u' num2str(k) ': ']);
            d0(k) = input(['d' num2str(k) ': ']);
            x0(2*k-1) = 1; %p
            x0(2*k) = 1; %q
%             disp(['%Nudo ' num2str(k) ', Slack'])
%             disp(['u' num2str(k) ' = ' num2str(u(k)) ';'])
%             disp(['d' num2str(k) ' = ' num2str(d(k)) ';'])
        case 2
            u0(k) = input(['u' num2str(k) ': ']);
            pg = input(['pg' num2str(k) ': ']);
            pd = input(['pd' num2str(k) ': ']);
            p0(k) = pg-pd;
            x0(2*k-1) = 0; %d
            x0(2*k) = 1; %q
%             disp(['%Nudo ' num2str(k) ', PV'])
%             disp(['u' num2str(k) ' = ' num2str(u(k)) ';'])
%             disp(['pg' num2str(k) ' = ' num2str(pg) ';'])
%             disp(['pd' num2str(k) ' = ' num2str(pd) ';'])
%             disp(['p' num2str(k) ' = pg' num2str(k) '-pd' num2str(k) ';'])
        case 3
            pg = input(['pg' num2str(k) ': ']);
            pd = input(['pd' num2str(k) ': ']);
            p0(k) = pg-pd;
            qg = input(['qg' num2str(k) ': ']);
            qd = input(['qd' num2str(k) ': ']);
            q0(k) = qg-qd;
            x0(2*k-1) = 1; %u
            x0(2*k) = 0; %d
%             disp(['%Nudo ' num2str(k) ', PQ'])
%             disp(['pg' num2str(k) ' = ' num2str(pg) ';'])
%             disp(['pd' num2str(k) ' = ' num2str(pd) ';'])
%             disp(['p' num2str(k) ' = pg' num2str(k) '-pd' num2str(k) ';'])
%             disp(['qg' num2str(k) ' = ' num2str(qg) ';'])
%             disp(['qd' num2str(k) ' = ' num2str(qd) ';'])
%             disp(['q' num2str(k) ' = qg' num2str(k) '-qd' num2str(k) ';'])
    end
end
%% Matriz de admitancias del sistema
Ybus = [yt12 -yt12 0 0 0 0 0;
        -yt12 yt12+y23 -y23 0 0 0 0;
        0 -y23 y23+y34+y36 -y34 0 -y36 0;
        0 0 -y34 y34+yt45 -yt45 0 0;
        0 0 0 -yt45 yt45 0 0;
        0 0 -y36 0 0 y36+yt67 -yt67;
        0 0 0 0 0 -yt67 yt67];
yab = [0 yt12 0 0 0 0 0;
        yt12 0 y23 0 0 0 0;
        0 y23 0 y34 0 y36 0;
        0 0 y34 0 yt45 0 0;
        0 0 0 yt45 0 0 0;
        0 0 y36 0 0 0 yt67;
        0 0 0 0 0 yt67 0]; %matriz auxiliar para el cálculo
yab_0 = zeros(n,n); %matriz auxiliar, solo ceros por que no se consideran inductancias paralelo a tierra
y = abs(Ybus);
g = angle(Ybus);
%% Cálculo de variables eléctricas y flujos de potencias
x = fsolve(@ec_flujo,x0); %Resuelvo el sistema de ecuaciones

u = zeros(n,1);
d = zeros(n,1);
p = zeros(n,1);
q = zeros(n,1);
for k = 1:1:n
    switch Tipo(k)
        case 1
            u(k) = u0(k);
            d(k) = d0(k);
            p(k) = x(2*k-1);
            q(k) = x(2*k);
        case 2
            u(k) = u0(k);
            d(k) = x(2*k-1);
            p(k) = p0(k);
            q(k) = x(2*k);
        case 3
            u(k) = x(2*k-1);
            d(k) = x(2*k);
            p(k) = p0(k);
            q(k) = q0(k);
    end
end
%Tensiones, ángulos de carga y potencias activa y reactiva en los vectores
%u, d, p y q

%Vector de tensiones del sistema
U = u.*cos(d)+1i*u.*sin(d);

%Cálculo de flujos de potencia
iab = zeros(n,n);
sab = zeros(n,n);
for k = 1:1:n
    for j = 1:1:n
        if k~=j
            iab(k,j) = (U(k)-U(j))*yab(k,j) + U(k)*yab_0(k,j);
            sab(k,j) = U(k)*conj(iab(k,j));
        end
    end
end
%Pérdidas en las líneas
perd = zeros(n,n);
for k = 1:1:n
    for j = 1:1:n
        if k~=j
            perd(k,j) = sab(k,j) + sab(j,k);
        end
    end
end
%% Visualización de resultados
disp('Tensiones en todos los nudos del sistema en por unidad (fasores):')
U
disp('Módulo de la tensión en cada uno de los nudos:')
disp(['   Tensión a la salida de la subestación de Pueblogrande de los Botijos: ' num2str(abs(u(2))*Ub2) ' V'])
disp(['   Tensión en la carga de Villabotijos de Abajo: ' num2str(abs(u(5))*Ub3) ' V'])
disp(['   Tensión en la carga de Villabotijos de Arriba: ' num2str(abs(u(7))*Ub3) ' V'])