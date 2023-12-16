%% Examen parcial 4, Año 2012 Iñaki Orradre
clear
clc
format shortEng
%Bases del sistema por unidad
Sb = 100e6;
Ub = 220e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Datos de las líneas
%línea 12, Central/Saint-Denis
R12 = 72.1e-6;
X12 = 423.2i*1e-6; %ohm/m
B12 = 2693i*1e-12; %S/m
long12 = 200e3;
%línea 23, Saint-Denis/Le Port
R23 = 85.1e-6;
X23 = 417.1i*1e-6; %ohm/m
B23 = 2807i*1e-12; %S/m
long23 = 150e3;
%línea 13, Central/Le Port (en proyecto)
R13 = 42.5e-6;
X13 = 301.4*1e-6; %ohm/m
B13 = 4139i*1e-12; %S/m
long13 = 270e3;
%Modelo equivalente de las líneas eléctricas: Empleo el modelo en pi
%nominal
z12 = (R12+X12)*long12/Zb;
y12_0 = B12*long12/2/Yb; %y12_2
z23 = (R23+X23)*long23/Zb;
y23_0 = B23*long23/2/Yb;
z13 = (R13+X13)*long13/Zb;
y13_0 = B13*long13/2/Yb;
%Consumo en cada una de las ciudades
s2 = (85+56i)*1e6/Sb; %consumo en Saint-Denis
s3 = (41+30i)*1e6/Sb; %consumo en Le Port
%% Cálculo de flujo de potencias
%Calculo los flujos de potencia del sistema para determinar las tensiones
%en cada uno de los nudos del sistema. Para resolver las cuestiones
%dispuestas a continuación, se deberá ejecutar este código repetidas veces,
%variando los parámetros correspondientes en función del problema a
%estudiar.
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script
n = input('Número de nudos: ');
Tipo = zeros(1,n);
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
% Matriz de admitancias del sistema
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
%% Cuestión 1: Tensión en cada uno de los nudos con la configuración actual.
disp('Tensión en cada uno de los nudos:')
u*Ub
%% Cuestión 2: Pérdidas en cada una de las líneas.
disp(['Pérdidas en la línea Central/Saint-Denis: ' num2str(real(perd(1,2))*Sb/1e6) ' MW'])
disp(['Pérdidas en la línea Saint-Denis/Le Port: ' num2str(real(perd(2,3))*Sb/1e6) ' MW'])
%% Cuestión 3: Sistema añadiendo batería de condensadores en Le Port.
disp('Cuestión 3:')
%Se debe ejecutar el código correspondiente al cálculo de flujo de
%potencias, considerando esta vez el nudo 3 (Le Port) como nudo PV. Una vez
%ejecutado, se visualizarán los resultados mediante la ejecución de la
%presente sección.
disp(['Tensión en la subestación de Saint-Denis: ' num2str(u(2)*Ub/1e3) ' kV'])
%% Cuestión 4: Pérdidas en cada una de las líneas.
disp('Cuestión 4:')
disp(['Pérdidas en la línea Central/Saint-Denis: ' num2str(real(perd(1,2))*Sb/1e6) ' MW'])
disp(['Pérdidas en la línea Saint-Denis/Le Port: ' num2str(real(perd(2,3))*Sb/1e6) ' MW'])
%% Cuestión 5: Potencia reactiva del banco de condensadores a instalar en Le Port.
disp('Cuestión 5:')
%q(3)=qc-imag(s3)
qc = q(3)+imag(s3);
disp(['Potencia del banco de condensadores a intalar en Le Port: ' num2str(qc*Sb/1e6) ' MVAr'])
%% Cuestión 6: Sistema añadiendo batería de condensadores en Saint-Denis.
%Se debe ejecutar el código correspondiente al cálculo de flujo de
%potencias, considerando esta vez el nudo 2 (Saint-Denis) como nudo PV. Una vez
%ejecutado, se visualizarán los resultados mediante la ejecución de la
%presente sección.
disp('Cuestión 6:')
disp(['Tensión en la subestación de Le Port: ' num2str(u(3)*Ub/1e3) ' kV'])
%% Cuestión 7: Pérdidas en cada una de las líneas.
disp('Cuestión 7:')
disp(['Pérdidas en la línea Central/Saint-Denis: ' num2str(real(perd(1,2))*Sb/1e6) ' MW'])
disp(['Pérdidas en la línea Saint-Denis/Le Port: ' num2str(real(perd(2,3))*Sb/1e6) ' MW'])
%% Cuestión 8: Potencia del banco de condensadores a intalar en Saint-Denis
disp('Cuestión 8:')
qc = q(2)+imag(s2);
disp(['Potencia del banco de condensadores a intalar en Saint-Denis: ' num2str(qc*Sb/1e6) ' MVAr'])
%% Cuestión 9: Tensión en Saint-Denis y en Le Port con la configuración de 3 líneas.
%Se debe ejecutar el código correspondiente al cálculo de flujo de
%potencias. A diferencia de en los casos anteriores, se considerará la
%configuración de 3 líneas. Los nudos correspondientes a Saint-Denis y Le
%Port se considerarán nudos PQ.
disp('Cuestión 9:')
disp(['Tensión en la subestación de Saint-Denis: ' num2str(u(2)*Ub/1e3) ' kV'])
disp(['Tensión en la subestación de Le Port: ' num2str(u(3)*Ub/1e3) ' kV'])
%% Cuestión 10: Pérdidas en cada una de las líneas.
disp('Cuestión 10:')
disp(['Pérdidas en la línea Central/Saint-Denis: ' num2str(real(perd(1,2))*Sb/1e6) ' MW'])
disp(['Pérdidas en la línea Saint-Denis/Le Port: ' num2str(real(perd(2,3))*Sb/1e6) ' MW'])
%% Cuestión 11:
%La cuestión 11 se encuentra respondida en el archivo .txt, que recoge los
%resultados de las ejecuciones realizadas para cada una de las cuestiones.