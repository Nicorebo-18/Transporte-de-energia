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
%% Problema 3: Cortocircuito FT en la subestación de Villabotijos de Abajo
%Modelo las cargas del sistema como impedancias
yL5 = (u(5))^2/conj((2e6+1i*1.1e6)/Sb); %carga Villabotijos de Abajo
yL7 = (u(7))^2/conj((0.6e6+1i*0.2e6)/Sb); %carga Villabotijos de Arriba
%Considero el valor de impedancia de las líneas en secuencia homopolar igual al doble del valor
%de impedancia en secuencia directa, se desprecia la parte resistiva.
% Considero impedancias de cortocircuito de los transformadores del mismo 
% valor para secuncias directa, inversa y homopolar.
x23 = 2*pi*50*1e-3*1i*3/Zb2;
y23 = [0.5/x23 1/x23 1/x23]; %[homopolar, directa, inversa]
x34 = 2*pi*50*1e-3*1i*7/Zb2;
y34 = [0.5/x34 1/x34 1/x34];
x36 = 2*pi*50*1e-3*1i*18/Zb2;
y36 = [0.5/x36 1/x36 1/x36];
%Matrices de admitancias e impedancias del sistema
Yhom = [yt12 0 0 0 0 0 0;
        0 y23(1) -y23(2) 0 0 0 0;
        0 -y23(2) y23(1)+y34(1)+y36(1) -y34(1) 0 -y36(1) 0;
        0 0 -y34(1) y34(1) 0 0 0;
        0 0 0 0 yt45+yL5 0 0;
        0 0 -y36(1) 0 0 y36(1) 0;
        0 0 0 0 0 0 yt67+yL7];
Ydir = [yt12 -yt12 0 0 0 0 0;
        -yt12 yt12+y23(2) -y23(2) 0 0 0 0;
        0 -y23(2) y23(2)+y34(2)+y36(2) -y34(2) 0 -y36(2) 0;
        0 0 -y34(2) y34(2)+yt45 -yt45 0 0;
        0 0 0 -yt45 yt45+yL5 0 0;
        0 0 -y36(2) 0 0 y36(2)+yt67 -yt67;
        0 0 0 0 0 -yt67 yt67+yL7];
Yinv = [yt12 -yt12 0 0 0 0 0;
        -yt12 yt12+y23(3) -y23(3) 0 0 0 0;
        0 -y23(3) y23(3)+y34(3)+y36(3) -y34(3) 0 -y36(3) 0;
        0 0 -y34(3) y34(3)+yt45 -yt45 0 0;
        0 0 0 -yt45 yt45+yL5 0 0;
        0 0 -y36(3) 0 0 y36(3)+yt67 -yt67;
        0 0 0 0 0 -yt67 yt67+yL7];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = u; %tensiones pre-falta en todos los nudos del sistema
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
% %Corrientes de falta en las líneas para cada una de las fases
% a = -0.5 + sqrt(3)*1i/2;
% A = [1 1 1;1 a^2 a;1 a a^2];
% Ifab = zeros(n,n,3);
% for k = 1:1:n
%     for j = 1:1:n
%         if k==N && j==N
%             aux = A*[ifhom; ifdir; ifinv];
%             Ifab(k,j,1) = aux(1,1);
%             Ifab(k,j,2) = aux(2,1);
%             Ifab(k,j,3) = aux(3,1);
% %              disp(['If' num2str(k) num2str(j) ' = '])
% %              abs(aux) %corrientes en por unidad
%         elseif k~=j
%             aux = A*[ifab(k,j,1); ifab(k,j,2);ifab(k,j,3)]; %corrientes de falta, en p.u
%             Ifab(k,j,1) = aux(1,1);
%             Ifab(k,j,2) = aux(2,1);
%             Ifab(k,j,3) = aux(3,1);
% %              disp(['If' num2str(k) num2str(j) ' = '])
% %              abs(aux) %corrientes en por unidad
%         end
%     end
% end
%% Corrección debido a desfases introducidos por los transformadores trifásicos y visualización de resultados
a = -0.5 + sqrt(3)*1i/2;
A = [1 1 1;1 a^2 a;1 a a^2];
%Las variables eléctricas en las líneas 34 y 35 se encuentran 330º
%adelantadas respecto a las corrientes en el lado de baja de los
%transformadores (secundario).
ifab34 = [ifab(3,4,1); ifab(3,4,2); ifab(3,4,3)].*[0;cos(11*pi/60)+1i*sin(11*pi/6);cos(-11*pi/60)+1i*sin(-11*pi/6)];
ifab36 = [ifab(3,6,1); ifab(3,6,2); ifab(3,6,3)].*[0;cos(11*pi/60)+1i*sin(11*pi/6);cos(-11*pi/60)+1i*sin(-11*pi/6)];
%Aplicando las leyes de Kirchoff en el nudo 3 se obtiene la corriente que
%circula por la línea 23 (que parte desde la subestación de Pueblogrande)
ifab23 = ifab34 + ifab36;
IfPuebloGrande = A*ifab23; %corriente por fase
%Tensión que llega a la subestación de Villabotijos de Arriba: Al igual que
%las corrientes, está adelantada 330º respecto al punto de la falta.
uf(:,6) = uf(:,6).*[0;cos(11*pi/60)+1i*sin(11*pi/6);cos(-11*pi/60)+1i*sin(.11*pi/6)];
uf(:,6) = A*uf(:,6);
%Visualización de resultados
disp('Corrientes de falta a la salida de la subestación de Pueblogrande de los Botijos (en el lado de las líneas), en A:')
abs(IfPuebloGrande)*Ib2
disp('Tensión de falta en el centro de transformación de Villabotijos de arriba (lado de alta de la subestación): ')
abs(uf(:,6))*Ub2