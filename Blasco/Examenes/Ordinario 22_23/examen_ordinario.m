%Examen ordinario, Iñaki Orradre Fernandez
%% Ejercicio 1
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
%% Inicializaciones previas al cálculo
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
%% Problema 1a y 1b: Visualización de resultados
disp(['a) Potencia activa proveniente de Vinulandia: ' num2str(p(1)*Sb/1e6+50) ' MW'])
pVinu = p(1)*Sb/1e6+50; %potencia suministrada por Vinulandia, en MW
Perd = real(sum(perd,"all"))/2; %Pérdidas totales de potencia activa del sistema, en pu
disp(['b) Pérdidas totales en las líneas de Silvania: ' num2str(Perd*Sb/1e6) ' MW'])
%% Problema 1c: Visualización de resultados
%Se debe volver a ejecutar las secciones del script correspondiestes al
%tipo de nudos, donde se realizarán las modificaciones pertinentes, y a
%continuación, la sección de código correspondiente al cálculo de variables
%eléctricas. Finalmente se ejecutará la presente sección para visualizar
%los resultados del problema.
pgen = p(4)+80e6/Sb; %potencia que debe entregar el generador del nudo 4, expresada en por unidad
disp(['c) Potencia a la que debe ajustarse el generador del nudo 4: ' num2str(pgen*Sb/1e6) ' MW'])
%% Ejercicio 2
%A diferencia del ejercicio que le precede, para resolver el presente
%ejercicio basta con ejecutar cada una de las secciones a continuación para
%obtener el resultado a cada una de las cuestiones planteadas.
clear
clc
format shortEng
%Elementos del circuito equivalente por unidad
%Generadores
xg1 = [0.06i 0.20i 0.12i];
yg1 = 1./xg1;
xg4 = [0.066i 0.330i 0.220i];
yg4 = 1./xg4;
%Transformadores
xt12 = 0.2i;
yt12 = 1/xt12;
xt15 = 0.16i;
yt15 = 1/xt15;
xt34 = 0.225i;
yt34 = 1/xt34;
xt46 = 0.27i;
yt46 = 1/xt46;
%Líneas eléctricas: Considero valores de reactancia de secuencia inversa
%iguales a los de secuencia directa.
x23 = [0.3i 0.14i 0.14i];
y23 = 1./x23;
x56 = [0.6i 0.35i 0.35i];
y56 = 1./x56;
%Matriz de transformación componentes simétricas/componentes por fase
a = -0.5 + sqrt(3)*1i/2;
A = [1 1 1;1 a^2 a;1 a a^2];
%% Apartados a y b
%Matrices de admitancias e impedancias del sistema
Yhom = [yg1(1) 0 0 0 0 0;
        0 y23(1)+yt12 -y23(1) 0 0 0;
        0 -y23(1) y23(1)+yt34 0 0 0;
        0 0 0 yg4(1) 0 0;
        0 0 0 0 y56(1)+yt15 -y56(1);
        0 0 0 0 -y56(1) y56(1)+yt46];
Ydir = [yt12+yt15+yg1(2) -yt12 0 0 -yt15 0;
        -yt12 yt12+y23(2) -y23(2) 0 0 0;
        0 -y23(2) y23(2)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(2) 0 -yt46;
        -yt15 0 0 0 yt15+y56(2) -y56(2);
        0 0 0 -yt46 -y56(2) yt46+y56(2)];
Yinv = [yt12+yt15+yg1(3) -yt12 0 0 -yt15 0;
        -yt12 yt12+y23(3) -y23(3) 0 0 0;
        0 -y23(3) y23(3)+yt34 -yt34 0 0;
        0 0 -yt34 yt34+yt46+yg4(3) 0 -yt46;
        -yt15 0 0 0 yt15+y56(3) -y56(3);
        0 0 0 -yt46 -y56(3) yt46+y56(3)];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
%Se considera que antes de la falta todos los nudos trabajan a tensión
%nominal y se desprecia la carga del sistema.
v = [1 1 1 1 1 1]; %vector de tensiones pre-falta
%Cortocircuito fase-tierra en el nudo 5
n = length(Ydir); %Número de nudos del sistema
N = 5;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 2;
zf = 0; %desprecio la impedancia de falta
%Calculo la corriente de falta
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
%Tensiones de falta en todo el sistema, sin tener en cuenta desfases
%introducidos por los transformadores trifásicos
uf = zeros(3,n);
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
%Calculo la corriente que entra por el lado de baja del transformador 1.25
h15 = 11;
%Las variables eléctricas del lado de baja estarán retrasadas 330º respecto
%a las variables eléctricas del lado de alta, dado que el transformador
%tiene un grupo de conexión Yd11
if15 = (uf(:,1)-uf(:,5))/xt15; %Sin tener en cuenta el desfase
if15 = if15.*[0;cos(-h15*pi/6)+1i*sin(-h15*pi/6);cos(h15*pi/6)+1i*sin(h15*pi/6)]; %Corrección por desfase
disp('a) Corriente de falta en el lado de baja del transformador (por fase)')
If15 = abs(A*if15)
disp('b) Corriente de falta que circuila por la línea 56:')
if56 = [(uf(1,6)-uf(1,5))/x56(1);(uf(2,6)-uf(2,5))/x56(2);(uf(3,6)-uf(3,5))/x56(3)];
If56 = abs(A*if56)
%% Apartado c (corregido)
%Corriente de falta ante cortocircuito trifásico en bornes del generado G1
%Se considera que antes de la falta todos los nudos trabajan a tensión
%nominal y se desprecia la carga del sistema.
v = [1 1 1 1 1 1]; %vector de tensiones pre-falta
%Cortocircuito fase-tierra en el nudo 1
n = length(Ydir); %Número de nudos del sistema
N = 1;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 1;
zf = 0; %desprecio la impedancia de falta
%Calculo la corriente de falta
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
ifff1 = [ifhom;ifdir;ifinv];
Ifff1 = A*ifff1; %corriente de falta, expresada en por unidad
Imax = abs(Ifff1(1));
%Calculo la reactancia de puesta a tierra del transformador para que la
%corriente de cortocircuito entre un fase y tierra en los bornes de salida
%sea igual a la corriente ante un cortocircuito trifásico.
%Matriz de admitancias en secuencia homopolar:
xTg1 = 0; %valor inicial para comenzar cálculo iterativo
Yhom = [yg1(1)+3*xTg1 0 0 0 0 0;
        0 y23(1) -y23(1)+yt12 0 0 0;
        0 -y23(1) y23(1)+yt34 0 0 0;
        0 0 0 yg4(1) 0 0;
        0 0 0 0 y56(1)+yt15 -y56(1);
        0 0 0 0 -y56(1) y56(1)+yt46];
Zhom = inv(Yhom);
%Cortocircuito fase-tierra en el nudo 1
n = length(Ydir); %Número de nudos del sistema
N = 1;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 2;
zf = 0; %desprecio la impedancia de falta
%Calculo la corriente de falta
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
ift1 = [ifhom;ifdir;ifinv];
Ift1 = A*ift1; %corriente de falta ante fallo FT en bornes de G1
error = max(abs(Ift1))-Imax;
while error>0.00001
    xTg1 = xTg1 + 0.0001i;
    Yhom = [1/(xg1(1)+3*xTg1) 0 0 0 0 0;
        0 y23(1) -y23(1)+yt12 0 0 0;
        0 -y23(1) y23(1)+yt34 0 0 0;
        0 0 0 yg4(1) 0 0;
        0 0 0 0 y56(1)+yt15 -y56(1);
        0 0 0 0 -y56(1) y56(1)+yt46];
    Zhom = inv(Yhom);
    %Cortocircuito fase-tierra en el nudo 1
    n = length(Ydir); %Número de nudos del sistema
    N = 1;
    %tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
    tipo_fallo = 2;
    zf = 0; %desprecio la impedancia de falta
    %Calculo la corriente de falta
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
    ift1 = [ifhom;ifdir;ifinv];
    Ift1 = A*ift1; %corriente de falta ante fallo FT en bornes de G1
    error = max(abs(Ift1))-Imax;
end
disp(['c) Reactancia que es necesario añadir en la puesta a tierra del generador G1: ' num2str(xTg1)])