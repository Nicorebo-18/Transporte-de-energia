%% Examen parcial 1, curso 2012/12 Iñaki Orradre
clear
clc
format shortEng
%% Problema 1: Análisis de sistema eléctrico de potencia
%Valores asignados transformador
Snt12 = 15e6;
UATt12 = 69e3;
UBTt12 = 13.8e3;
%Bases del sistema por unidad
Sb = 100e6;
Ub1 = 69e3;
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ub2 = Ub1*UBTt12/UATt12;
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
%Elementos del circuito equivalente por unidad
xt12 = sqrt(0.08/(1+(1/8)^2));
rt12 = xt12/8;
zt12 = (rt12+xt12*1i)*Sb/Snt12*(UATt12/Ub1);
yt12 = 1/zt12;
x23 = (0.19138+0.12119)/Zb2;
y23 = 1/x23;
%Potencia absorbida por la carga en el nudo 3, considero que está
%alimentada a tensión nominal para simplificar el cálculo, el error
%cometido será pequeño.
s3 = 1^2/conj((34.45+91.125i)/Zb2);
%A continuación, calculo el flujo de potencias del sistema.
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script
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
disp(['Tensión aplicada a la carga en el nudo 3: ' num2str(abs(u(3))*Ub2/1e3) ' kV'])
PERD = real(sum(perd,"all"))/2; %pérdidas totales del sistema, en por unidad
disp(['Pérdidas totales en todo el sistema: ' num2str(PERD*Sb/1e6) ' MW'])
%% Problema 2: Determinación de la impedancia de cortocircuito de un transformador trifásico
%Bases del sistema por unidad
Sb = 3e3;
Ub = 220;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
%En sistema por unidad, el módulo de la tensión de cortocircuito es igual a
%la impedancia de cortocircuito
zcc_modulo = 6.61/Ub;
%Calculo la parte resistiva de esa impedancia
perdidas = 80.9/Sb; %perdidas totales del transformador
icc = 7.87/Ib; %corriente de cortocircuito
rcc = perdidas/icc^2;
%Reactancia del transformador
xcc = sqrt(zcc_modulo^2-rcc^2);
%Por último, calculo la impedancia de cortocircuito del transformador.
zcc = rcc + 1i*xcc;
disp(['Impedancia de cortocircuito del transformador, expresada en sistema por unidad: ' num2str(zcc)])
