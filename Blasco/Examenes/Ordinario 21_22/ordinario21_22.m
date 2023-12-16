% Examen ordinario 2021/22 Iñaki Orradre
clear
clc
format shortEng
%% Valores asignados transformadores y generadores
Sng1 = 1000e6;
Ung1 = 13.8e3;
Sng2 = 250e6;
Ung2 = 6.9e3;
Snt12 = 1000e6;
UATt12 = 220e3;
UBTt12 = 13.2e3;
Snt56 = 400e6;
UATt56 = 66e3;
UBTt56 = 6.6e3;
Snt34 = 1000e6;
UATt34 = 220e3;
UBTt34 = 66e3;
%Bases del sistema por unidad
Sb =100e6;
Ub2 = 220e3;
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2; %zona líneas 23
Ub1 = Ub2*UBTt12/UATt12;
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1; %zona generador 1
Ub3 = Ub2*UBTt34/UATt34;
Ib3 = Sb/Ub3/sqrt(3);
Zb3 = Ub3^2/Sb;
Yb3 = 1/Zb3; %zona línea 45
Ub4 = Ub3*UBTt56/UATt56;
Ib4 = Sb/Ub4/sqrt(3);
Zb4 = Ub4^2/Sb;
Yb4 = 1/Zb4; %zona generador 6
%% a) Circuito equivalente en pi nominal para las líneas
%Constantes
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Línea 34: Línea trifásica de doble circuito, 1 conductor por fase
long = 35e3; %Longitud de la línea, en m
DAB = 3.26;
DAb = sqrt(3.26^2+5.5^2);
DaB = sqrt(3.26^2+5.5^2);
Dab = 3.26;
DBC = 3.26;
DBc = sqrt(3.26^2+5.5^2);
DbC = sqrt(3.26^2+5.5^2);
Dbc = 3.26;
DAC = 3.26*2;
DAc = 5;
DaC = 5;
Dac = 3.26*2; 
DAa = sqrt((3.26*2)^2+5^2);
DBb = 6;
DCc = sqrt((3.26*2)^2+5^2); %Distancias entre conductores, en m
radio = 27.72e-3/2; %Radio de los conductores
Rc = 71.8e-6*(3.93e-3*(80-20)); %Resistencia del conductor por unidad de longitud Ohm/m

R = Rc/2; %Resistencia de la línea por unidad de longitud
L = mu0*log(((DAB*DAb*DaB*Dab)^(1/4)*(DBC*DBc*DbC*Dbc)^(1/4)*(DAC*DAc*DaC*Dac)^(1/4))^(1/3)/(sqrt(radio*exp(-0.25))*(DAa*DBb*DCc)^(1/6)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log(((DAB*DAb*DaB*Dab)^(1/4)*(DBC*DBc*DbC*Dbc)^(1/4)*(DAC*DAc*DaC*Dac)^(1/4))^(1/3)/(sqrt(radio)*(DAa*DBb*DCc)^(1/6))); %Capacidad de la línea por unidad de longitud C/m

r = R/Zb3; %Resistencia de la línea por unidad de longitud, en pu
x = 2*pi*f*L*1i/Zb3; %Reactancia de la línea por unidad de longitud, en pu
c = 1/(2*pi*f*C*1i)/Zb3; %Capacidad de la línea por unidad de longitud, en pu
%Modelo equivalente en pi nominal para la línea 34
z34 = (r+x)*long;
y34_0 = (1/c)*long/2;
T34 = [1+z34*y34_0 z34;
        2*y34_0*(1+z34*y34_0) 1+z34*y34_0];
disp('a) Circuitos equivalentes en pi nominal para las líneas eléctricas.')
disp('Matriz de transmisión de la línea 34 (modelo equivalente en pi nominal): ')
T34
%Línea 23a: línea aérea trifásica asimétrica duplex
long = 123e3; %Longitud de la línea
Dab = 8.2;
Dbc = 8.5;
Dac = 6.5; %Distancias entre conductores
d = 0.4; %Distancia entre conductores del mismo haz, en m
radio = 27.72e-3/2; %Radio de los conductores
Rc = 71.8e-6*(3.93e-3*(80-20)); %Resistencia del conductor por unidad de longitud Ohm/m

R = Rc/2; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*d)); %Capacidad de la línea por unidad de longitud C/m

r = R/Zb2; %Resistencia de la línea por unidad de longitud, en pu
x = 2*pi*f*L*1i/Zb2; %Reactancia de la línea por unidad de longitud, en pu
c = 1/(2*pi*f*C*1i)/Zb2; %Reactancia capacitiva de la línea por unidad de longitud, en pu
%Modelo equivalente en pi nominal para la línea 23a
z23a = (r+x)*long;
y23a_0 = (1/c)*long/2;
T23a = [1+z23a*y23a_0 z23a;
        2*y23a_0*(1+z23a*y23a_0) 1+z23a*y23a_0];
disp('Matriz de transmisión de la línea 23a (modelo equivalente en pi nominal): ')
T23a
%Línea 23b: línea aérea trifásica asimétrica duplex
long = 148e3; %Longitud de la línea
Dab = 8.6;
Dbc = 8.6;
Dac = Dab+Dbc; %Distancias entre conductores
d = 0.4; %Distancia entre conductores del mismo haz, en m
radio = 27.72e-3/2; %Radio de los conductores
Rc = 71.8e-6*(3.93e-3*(80-20)); %Resistencia del conductor por unidad de longitud Ohm/m

R = Rc/2; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*d)); %Capacidad de la línea por unidad de longitud C/m

r = R/Zb2; %Resistencia de la línea por unidad de longitud, en pu
x = 2*pi*f*L*1i/Zb2; %Reactancia de la línea por unidad de longitud, en pu
c = 1/(2*pi*f*C*1i)/Zb2; %Reactancia capacitiva de la línea por unidad de longitud, en pu
%Modelo equivalente en pi nominal para la línea 23a
z23b = (r+x)*long;
y23b_0 = (1/c)*long/2;
T23b = [1+z23b*y23b_0 z23b;
        2*y23b_0*(1+z23b*y23b_0) 1+z23b*y23b_0];
disp('Matriz de transmisión de la línea 23a (modelo equivalente en pi nominal): ')
T23b
%% b) Pérdidas económicas en una hora en todo el sistema, con los modelos de línea anteriores
%Se debe resolver el problema de flujo de potencias para determinar las
%pérdidas en cada una de las líneas, se empleará el script auxiliar
%ec_flujo para ello
%Para facilitar la ejecución del código, el apartado b se ha dividido en
%varias secciones
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script

%Reactancias de cortocircuito de los transformadores
xt12 = 0.1i*Sb/Snt12*(UBTt12/Ub1)^2;
xt56 = 0.08i*Sb/Snt56*(UBTt56/Ub4)^2;
xt34 = 0.1i*Sb/Snt34*(UBTt34/Ub3)^2;

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
%% Parámetros de las líneas
yab = zeros(n,n);
yab_0 = zeros(n,n);

for k = 1:1:n
    for j = 1:1:n
        if k~=j
            yab(k,j) = input(['y' num2str(k) num2str(j) ': ']);
            yab_0(k,j) = input(['y' num2str(k) num2str(j) '_0: ']);
%             disp(['y' num2str(k) num2str(j) ' = ' num2str(yab(k,j)) ';'])
%             disp(['y' num2str(k) num2str(j) '_0 = ' num2str(yab_0(k,j)) ';'])
        end
    end
end

%% Matriz de admitancias del sistema
Ybus = zeros(n,n);
for k = 1:1:n
    for j = 1:1:n        
        if k==j
            suma_a = sum(yab,2);
            suma_b = sum(yab_0,2);
            Ybus(k,j) = suma_a(k,1) + suma_b(k,1);
        else
            Ybus(k,j) = -yab(k,j);
        end
    end
end
y = abs(Ybus);
g = angle(Ybus);
% Cálculo de variables eléctricas y flujos de potencias
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
%% Tratamiento y visualización de resultados
PerdW = Sb*real(sum(perd,"all"))/2; %Pérdidas totales del sistema, en W
Perd_hora = 3600*PerdW/1e6; %Perdidas totales del sistema en una hora, en MWh
Perd_eco = Perd_hora/300; %Pérdidas económicas por hora del sistema
disp(['Pérdidas de potencia por hora: ' num2str(Perd_hora) ' MWh'])
disp(['Pérdidas económicas por hora: ' num2str(Perd_eco) ' €'])

%% c) Corriente de cortocircuito en todos los interruptores si se produce cortocircuito FF en medio de la línea 23a
%Al igual que el apartado anterior, el script se ha dividido en varias
%secciones para facilitar su ejecución
%Parámetros del circuito equivalente por unidad
xTg1 = 3i/Zb1;
yg1 = [1/(0.05i*Sb/Sng1*(Ung1/Ub1)^2) 1/(0.35i*Sb/Sng1*(Ung1/Ub1)^2) 1/(0.25i*Sb/Sng1*(Ung1/Ub1)^2)];
yg6 = [0 1/((0.35i*Sb/Sng2*(Ung2/Ub4)^2)) 1/((0.25i*Sb/Sng2*(Ung2/Ub4)^2))];
yt12 = 1/xt12;
yt56 = 1/xt56;
yt34 = 1/xt34;
x23a = [3*imag(z23a) imag(z23a) imag(z23a)];
x23b = [3*imag(z23b) imag(z23b) imag(z23b)];
x45 = [3*imag(z34) imag(z34) imag(z34)]; %hay un fallo en la nomenclatura, proveniente del apartado anterior
%Matrices de admitancias e impedancias del sistema
Yhom = [yg1(1)+3*xTg1 0 0 0 0 0 0;
        0 yt12+1/(x23a(1)/2)+1/x23b(1) -1/x23b(1) 0 0 0 -1/(x23a(1)/2);
        0 -1/x23b(1) 1/x23b(1)+1/(x23a(1)/2)+yt34 -yt34 0 0 -2/x23a(1);
        0 0 -yt34 yt34+1/x45(1) -1/x45(1) 0 0;
        0 0 0 -1/x45(1) 1/x45(1)+yt56 0 0;
        0 0 0 0 0 0.0000000001 0;
        0 -2/x23a(1) -2/x23a(1) 0 0 0 2/x23a(1)+2/x23a(1)];
Ydir = [yt12+yg1(2) -yt12 0 0 0 0 0;
        -yt12 yt12+1/(x23a(2)/2)+1/x23b(2) -1/x23b(2) 0 0 0 -1/(x23a(2)/2);
        0 -1/x23b(2) 1/x23b(2)+1/(x23a(2)/2)+yt34 -yt34 0 0 -2/x23a(2);
        0 0 -yt34 yt34+1/x45(2) -1/x45(2) 0 0;
        0 0 0 -1/x45(2) 1/x45(2)+yt56 -yt56 0;
        0 0 0 0 -yt56 yt56+yg6(2) 0;
        0 -2/x23a(2) -2/x23a(2) 0 0 0 2/x23a(2)+2/x23a(2)];
Yinv = [yt12+yg1(3) -yt12 0 0 0 0 0;
        -yt12 yt12+1/(x23a(3)/2)+1/x23b(3) -1/x23b(3) 0 0 0 -1/(x23a(3)/2);
        0 -1/x23b(3) 1/x23b(3)+1/(x23a(3)/2)+yt34 -yt34 0 0 -2/x23a(3);
        0 0 -yt34 yt34+1/x45(3) -1/x45(3) 0 0;
        0 0 0 -1/x45(3) 1/x45(3)+yt56 -yt56 0;
        0 0 0 0 -yt56 yt56+yg6(3) 0;
        0 -2/x23a(3) -2/x23a(3) 0 0 0 2/x23a(3)+2/x23a(3)];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = [1 1 1 1 1 1 1]; %tensiones pre-falta
%% Cálculo de corrientes de cortocircuito (sin tener en cuenta desfases introducidos por los transformadores)
%Notación
% v = Vector de tensiones pre-falta
% Ydir = Matriz de admitancias en secuencia directa
% Yinv = Matriz de admitancias en secuencia inversa
% Yhom = Matriz de admitancias en secuencia homopolar
% Auxhom = Matriz auxiliar empleada para el cálculo de corrientes de falta en componentes simétricas
% Zdir = Matriz de impedancias en secuencia directa
% Zinv = Matriz de impedancias en secuencia inversa
% Zhom = Matriz de impedancias en secuencia homopolar

%Datos del fallo
%n = input('Número de nudos del sistema: ');
n = length(Ydir); %Número de nudos del sistema
N = input('Nudo en el que se produce el fallo: ');
tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
zf = input('Impedancia de fallo: ');
%Corrientes de falta
switch tipo_fallo
    case 1
        ifhom = 0;
        ifdir = v(N)/(Zdir(N,N)+zf);
        ifinv = 0;
    case 2
        ifhom = v(N)/(Zhom(N,N)+Zdir(N,N)+Zinv(N,N)+3*zf);
        ifdir = ifhom;
        ifinv = ifhom;
    case 3
        ifhom = 0;
        ifdir = v(N)/(Zdir(N,N)+Zinv(N,N)+zf);
        ifinv = -ifdir;
    case 4
        ifdir = v(N)/(Zdir(N,N)+(Zinv(N,N)*(Zhom(N,N)+3*zf)/(Zinv(N,N)+Zhom(N,N)+3*zf)));
        ifhom = -ifdir*Zinv(N,N)/(Zinv(N,N)+Zhom(N,N)+3*zf);
        ifinv = -ifdir*(Zhom(N,N)+3*zf)/(Zinv(N,N)+Zhom(N,N)+3*zf);
end
%Tensiones de falta
uf = zeros(3,N);
for k = 1:1:n
    if tipo_fallo==1
        uf(1,k) = 0; %componente homopolar
        uf(2,k) = v(k)-ifdir*Zdir(k,N); %componente en secuencia directa
        uf(3,k) = 0; %componente en secuencia inversa
    elseif tipo_fallo==3
        uf(1,k) = 0; %componente homopolar
        uf(2,k) = v(k)-ifdir*Zdir(k,N); %componente en secuencia directa
        uf(3,k) = -ifinv*Zinv(k,N); %componente en secuencia inversa
    else
        uf(1,k) = -ifhom*Zhom(k,N); %componente homopolar
        uf(2,k) = v(k)-ifdir*Zdir(k,N); %componente en secuencia directa
        uf(3,k) = -ifinv*Zinv(k,N); %componente en secuencia inversa
    end
end
%Corrientes de falta en las líneas, en componentes simétricas
ifab = zeros(n,n,3);
for k = 1:1:n
    for j = 1:1:n
        if k~=j
            if tipo_fallo==1
                ifab(k,j,1) = 0; %componente homopolar
                ifab(k,j,2) = -(uf(2,k)-uf(2,j))*Ydir(k,j); %componente en secuencia directa
                ifab(k,j,3) = 0; %componente en secuencia inversa
            elseif tipo_fallo==3
                ifab(k,j,1) = 0; %componente homopolar
                ifab(k,j,2) = -(uf(2,k)-uf(2,j))*Ydir(k,j); %componente en secuencia directa
                ifab(k,j,3) = -(uf(3,k)-uf(3,j))*Yinv(k,j) ;%componente en secuencia inversa
            else
                ifab(k,j,1) = -(uf(1,k)-uf(1,j))*Auxhom(k,j); %componente homopolar
                ifab(k,j,2) = -(uf(2,k)-uf(2,j))*Ydir(k,j); %componente en secuencia directa
                ifab(k,j,3) = -(uf(3,k)-uf(3,j))*Yinv(k,j); %componente en secuencia inversa
            end
        end
    end
end
%Corrientes de falta en las líneas para cada una de las fases
a = -0.5 + sqrt(3)*1i/2;
A = [1 1 1;1 a^2 a;1 a a^2];
Ifab = zeros(n,n,3);
for k = 1:1:n
    for j = 1:1:n
        if k==N && j==N
            aux = A*[ifhom; ifdir; ifinv];
            Ifab(k,j,1) = aux(1,1);
            Ifab(k,j,2) = aux(2,1);
            Ifab(k,j,3) = aux(3,1);
%              disp(['If' num2str(k) num2str(j) ' = '])
%              abs(aux) %corrientes en por unidad
        elseif k~=j
            aux = A*[ifab(k,j,1); ifab(k,j,2);ifab(k,j,3)]; %corrientes de falta, en p.u
            Ifab(k,j,1) = aux(1,1);
            Ifab(k,j,2) = aux(2,1);
            Ifab(k,j,3) = aux(3,1);
%              disp(['If' num2str(k) num2str(j) ' = '])
%              abs(aux) %corrientes en por unidad
        end
    end
end
%% Corrección de desfases introducidos por transformadores trifásicos y visualización de resultados
disp('Corriente de falta en el interruptor 1: ')
abs(Ifab(2,7,:)*Ib2)
disp('Corriente de falta los interruptores 2 y 4: ')
abs(Ifab(2,3,:)*Ib2)
disp('Corriente de falta en el interruptor 3:')
abs(Ifab(7,3,:)*Ib2)
disp('Corriente de falta en los interruptor 5 y 6:')
abs(Ifab(4,5,:)*Ib3)

%% d) Corriente de excitación necesaria para alimentar al generador conectado al nudo 6, en condiciones de trabajo b)
pg6 = p(6);
qg6 = q(6);
xsg6 = 1.2i*Sb/Sng2*(Ung2/Ub4)^2;
u6 = u(6); %tomo la tensión en el nudo 6 como origen de fase
i6 = conj((pg6+qg6*1i)/u6); %corriente suministrada por el generador 2
e = u6 + i6*xsg6; %tensión de vacío del generador
disp(['Corriente de excitación necesaria: ' num2str(abs(e)/1.1*346) ' A'])
