%Examen ordinario 2014/15 Iñaki Orradre
clear
clc
format shortEng
%% Problemas 2 y 3: Flujo de potencias en sistema eléctrico de potencia.
%Bases del sistema por unidad
Sb = 100e6;
Ub = 66e3;
Ib = Sb/Ib/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Elementos del circuito equivalente por unidad
y12 = 1/(0.1842+0.2879i);
y13a = 1/(0.1876+0.4009i);
y13b = 1/(0.2094+0.4475i);
y23 = 1/(0.09211+0.1439i);
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
disp('Matriz de admitancias del sistema: ')
Ybus
disp(['Corriente que circula por la línea 23: ' num2str(abs(iab(2,3)*Ib)) ' A'])
if abs(iab(2,3))*Ib>339
    disp('La línea 23 funciona sobrecargada.')
else
    disp('La línea 23 no funciona sobrecargada.')
end