%% Examen extraordinario 2015/16 Iñaki Orradre
clear
clc
format shortEng
%% Problema 1
%Bases del sistema por unidad
Sb = 100e6;
Ub = 230e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Constantes
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Inductancia unitaria de la línea antes de ser reconstruida
Dab = 6.7;
Dbc = 6.7;
Dac = Dab+Dbc; %Distancias entre conductores
d = 0.3; %Distancia entre conductores del mismo haz, en m
radio = 25.4e-3/2; %Radio de los conductores

L0 = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi; %Inductancia de la línea por unidad de longitud H/m

%Inductancia unitaria de la línea una vez reconstruida
Dab = 1;
Dbc = Dab;
Dac = Dab; %Distancias entre conductores

L = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi; %Inductancia de la línea por unidad de longitud H/m

%Calculo la distancia Dab para que la inductancia unitaria de la línea una
%vez reconstruida sea igual a la línea original
error = L-L0;
while abs(error)>1e-11
    if error>0
        Dab = Dab-0.0001;
    end
    if error<0
        Dab = Dab+0.0001;
    end
    Dbc = Dab;
    Dac = Dab;
    L = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi;
    error = L-L0;
end
long = 100e3; %longitud de la línea, en m
Rc = 85.1e-6;
R = Rc/2; %Resistencia de la línea por unidad de longitud
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*d)); %Capacidad de la línea por unidad de longitud C/m
xlinea = 2*pi*f*long*L/Zb;
rlinea = R*long/Zb;
blinea = 2*pi*f*long*C/Yb;
disp(['Los conductores deberan estar separados una distancia de ' num2str(Dab) ' metros.'])
disp(['Inductancia de la línea ' num2str(xlinea) ' p.u.'])
disp(['Resistencia de la línea ' num2str(rlinea) ' p.u.'])
disp(['Susceptancia de la línea ' num2str(blinea) ' p.u.'])
%% Problema 2
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
y13 = 1/(0.01+0.03i);
y13_0 = 0;
y23 = 1/(0.0125+0.025i);
%% Matriz de admitancias del sistema
Ybus = [y13 0 -y13;
        0 y23 -y23;
        -y13 -y23 y13+y23]; %matriz de admitancias del sistema
yab = [0 0 y13;
        0 0 y23;
        y13 y23 0];
yab_0 = zeros(n,n); %matrices auxiliares para el cálculo de flujos de potencia
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
%% Tratamiento y visualización de resultados
disp(['Potencia que circula por la línea 13: ' num2str(abs(sab(1,3))*Sb/1e6) ' MVA'])
disp(['  Potencia activa: ' num2str(abs(real(sab(1,3))*Sb/1e6)) ' MW'])
disp(['  Potencia reactiva: ' num2str(abs(imag(sab(1,3))*Sb/1e6)) ' MVAr'])
PERD = real(sum(perd,"all"))*Sb/2/1e6; %pérdidas totales del sistema, en MW
disp(['Pérdidas totales del sistema: ' num2str(PERD) ' MW'])
%% Problema 3: Cortocircuito FFF en el nudo 2
y13 = 1/0.03i;
y23 = 1/0.025i;
xgen = 0.1i;
ygen = 1/xgen;
Ydir = [y13+ygen 0 -y13;
        0 y23 -y23;
        -y13 -y23 y13+y23]; %matriz de admitancias del sistema en secuencia directa, línea 12 deshabilitada
Zdir = inv(Ydir);
v = [1.05 1.05 1.05]; %tensión pre-falta
%Se ha despreciado el efecto de las cargas para el cálculo
%% Cálculo de corrientes de cortocircuito
%Notación
% v = Vector de tensiones pre-falta
% Ydir = Matriz de admitancias en secuencia directa
% Yinv = Matriz de admitancias en secuencia inversa
% Yhom = Matriz de admitancias en secuencia homopolar
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
                ifab(k,j,1) = -(uf(1,k)-uf(1,j))*Yhom(k,j); %componente homopolar
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
%% Tratamiento y visualización de resultados
disp('Corriente de falta en la línea 13 para cada una de las fases (p.u.):')
abs(Ifab(1,3,:))
disp('Corriente de falta en la línea 13 para cada una de las fases (kA:')
abs(Ifab(1,3,:)*Ib/1e3)
%% Problema 4: Corrientes de cortocircuito trifásico.
%Parámetros del circuito equivalente por unidad en secuencia directa
y23 = 1/0.1i;
y34 = 1/0.2i;
y24 = 1/0.3i;
yt12 = 1/0.05i;
yt45 = 1/0.05i;
yg1 = 1/0.15i;
%Calculo las matrices de admitancia e impedancias
Ydir = [yt12+yg1 -yt12 0 0 0;
        -yt12 yt12+y24+y23 -y23 -y24 0;
        0 -y23 y23+y34 -y34 0;
        0 -y24 -y34 y24+y34+yt45 -yt45;
        0 0 0 -yt45 yt45];
Zdir = inv(Ydir);
%Considero que antes de la falta los nudos se encuentran trabajando a
%tensión nominal
%Desprecio la impedancia del nudo 5, correspondiente a la red de potencia
%infinita.
v = [1 1 1 1 1]; %vector de tensiones pre-falta
%% Cálculo de corrientes de cortocircuito
%Notación
% v = Vector de tensiones pre-falta
% Ydir = Matriz de admitancias en secuencia directa
% Yinv = Matriz de admitancias en secuencia inversa
% Yhom = Matriz de admitancias en secuencia homopolar
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
                ifab(k,j,1) = -(uf(1,k)-uf(1,j))*Yhom(k,j); %componente homopolar
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
%% Visualización de resultados
disp('Corriente de cortocircuito en la línea 23 (por unidad), en cada una de las fases:')
abs(Ifab(2,3,:))
disp('Corriente de cortocircuito en la línea 34 (por unidad), en cada una de las fases:')
abs(Ifab(4,3,:))