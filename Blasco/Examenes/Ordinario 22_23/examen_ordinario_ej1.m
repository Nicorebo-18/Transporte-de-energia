%Examen ordinario, Álvaro Blasco
% Ejercicio 1
%Para resolver el siguiente ejercicio se ha empleado el código dispuesto a
%continuación, que recoje los datos del problema y las secciones
%correspondientes a los cálculos. Se trata de un script que pide al usuario
%que se introduzcan los datos manualmente, por lo que para resolver el
%problema es preciso ejecutar el código e introducir las variables del
%problema a resolver. Los resultados de la apropiada ejecuación del código
%se adjuntan en un archivo .txt (archivo de texto), junto con los
%resultados del problema.
% Nota: Para la ejecución en Octave es preciso
%cambiar las sentencias "end" que finalizan acciones tales como bucles for
%o while por sus correspondientes sentencias en Octave.
clear
clc
format shortEng
%Bases del sistema por unidad
Sb = 100e6;
Ub = 230e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Modelo de las líneas: Se emplea el modelo equivalente en pi.
z12 = (5.3323+26.6616i)/Zb;
y12 = 1/z12;
y12_0 = 1i*48.44e-6/Yb;
z13 = (3.9358+19.6788i)/Zb;
y13 = 1/z13;
y13_0 = 1i*36.626e-6/Yb;
z24 = (3.9358+19.6788i)/Zb;
y24 = 1/z24;
y24_0 = 1i*36.626e-6/Yb;
z34 = (6.7289+33.6444i)/Zb;
y34 = 1/z34;
y34_0 = 1i*60.255e-6/Yb;
% Inicializaciones previas al cálculo
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script

n = input('Número de nudos: ');
Tipo = zeros(n,1);
u0 = zeros(n,1);
d0 = zeros(n,1);
p0 = zeros(n,1);
q0 = zeros(n,1);
x0 = zeros(n*2,1); %Vector de soluciones iniciales para comenzar la iteración

% Nudos del sistema
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
% Parámetros de las líneas
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
p(1)
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
% Problema 1a y 1b: Visualización de resultados
disp(['a) Potencia activa proveniente de Vinulandia: ' num2str(p(1)*Sb/1e6+50) ' MW'])
pVinu = p(1)*Sb/1e6+50; %potencia suministrada por Vinulandia, en MW
Perd = (sum(perd,"all"))/2; %Pérdidas totales de potencia activa del sistema, en pu
%Se divide entre dos debido a que la suma de la matriz suma cada línea dos
%veces
disp(['b) Pérdidas totales en las líneas de Silvania: ' num2str(Perd*Sb/1e6) ' MW'])
% Problema 1c: Visualización de resultados
%Se debe volver a ejecutar las secciones del script correspondiestes al
%tipo de nudos, donde se realizarán las modificaciones pertinentes, y a
%continuación, la sección de código correspondiente al cálculo de variables
%eléctricas. Finalmente se ejecutará la presente sección para visualizar
%los resultados del problema.
pgen = p(4)+80e6/Sb; %potencia que debe entregar el generador del nudo 4, expresada en por unidad
disp(['c) Potencia a la que debe ajustarse el generador del nudo 4: ' num2str(pgen*Sb/1e6) ' MW'])
