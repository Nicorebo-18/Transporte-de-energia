%Ejercicio 1 Examen ordinario 2018/19 Iñaki Orradre
clear
clc
format shortEng
% Datos del problema y bases del sistema por unidad
%Valores asignados de las máquinas
Sng1 = 100e6;
Ung1 = 132e3;
Sng3 = 83e6;
Ung3 = 15e3;
Snt3 = 100e6;
UATt3 = 132e3;
UBTt3 = 13.2e3;
Snt34 = 100e6;
UATt34 = 132e3;
UBTt34 = 66e3;
Snt45 = 100e6;
UATt45 = 132e3;
UBTt45 = 66e3;
%Bases del sistema por unidad
Sb = 100e6;
Ub1 = 136e3;
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1; %sistema vecino
Ub2 = Ub1*UBTt34/UATt34;
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2; %zona entre nudos 3 y 4
Ub3 = Ub1*UBTt45/UATt45;
Ib3 = Sb/Ub3/sqrt(3);
Zb3 = Ub3^2/Sb;
Yb3 = 1/Zb3; %nudo generación
%Parámetros del circuito equivalente por unidad
x12 = [0.0850+0.38i 0.0425+0.19i 0.0425+0.19i]*100/Zb1; %[homopolar, directa, inversa]
y12 = 1./x12;
x23 = [0.2520+0.6078i 0.1260+0.3039i 0.1260+0.3039i]*50/Zb1;
y23 = 1./x12;
x34 = [0.7269+0.6078i 0.2423+0.401i 0.2423+0.401i]*25/Zb3;
y34 = 1./x12;
x45 = [0.2520+0.6078i 0.1260+0.3039i 0.1260+0.3039i]*50/Zb1;
y45 = 1./x12;
x25 = [0.2520+0.6078i 0.1260+0.3039i 0.1260+0.3039i]*50/Zb1;
y25 = 1./x12;
xg1 = [0.01i 0.1i 0.1i]*Sb/Sng1*(Ung1/Ub1)^2;%Cambiamos de la base que nos da el problema a la nuestra
yg1 = 1./xg1;
xg3 = [0.06i 0.18i 0.21i]*Sb/Sng3*(Ung3/Ub2)^2;%Cambiamos de la base que nos da el problema a la nuestra
yg3 = 1./xg3;
xt3 = 0.1i*Sb/Snt3*(UATt3/Ub1)^2;%Cambiamos de la base que nos da el problema a la nuestra
yt3 = 1/xt3;
xt34 = 0.1i*Sb/Snt3*(UATt34/Ub1)^2;%Cambiamos de la base que nos da el problema a la nuestra
yt34 = 1/xt34;
xTt34 = 0.1i*Sb/Snt3*(UATt34/Ub1)^2;
yTt34 = 1/xTt34; %admitancia de puesta a tierra del neutro
xt45 = 0.1i*Sb/Snt45*(UATt45/Ub1)^2;
yt45 = 1/xt45;
% Calculo las tensiones pre-falta en cada uno de los nudos
%Para ello, calculo los flujos de carga del sistema y las tensiones en cada
%uno de los nudos Para facilitar la ejecución del código se ha dividido el
%presente apartado en varias secciones. Los resultados obtenidos tras la
%ejecución se adjuntan en un archivo .txt.
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script
%% Matriz de admitancias del sistema: Sistema de 5 nudos
Ybus = [y12(2) -y12(2) 0 0 0;
        -y12(2) y12(2)+y23(2)+y25(2) -y23(2) 0 -y25(2);
        0 -y23(2) y23(2)+yt34+y34(2) -(yt34+y34(2)) 0;
        0 0 -(yt34+y34(2)) yt34+y34(2)+yt45+y45(2) -(yt45+y45(2));
        0 -y25(2) 0 -(yt45+y45(2)) y25(2)+yt45+y45(2)];
yab = [0 y12(2) 0 0 0;
        y12(2) 0 y23(2) 0 y25(2);
        0 y23(2) 0 yt34+y34(2) 0;
        0 0 yt34+y34(2) 0 yt45+y45(2);
        0 y25(2) 0 yt45+y45(2) 0]; %matriz auxiliar para el cálculo
y = abs(Ybus);
g = angle(Ybus);

n = length(Ybus);
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
            iab(k,j) = (U(k)-U(j))*yab(k,j);
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
disp('Tensiones pre-falta en cada uno de los nudos:')
u
%% Cálculo de las corriente de cortocircuito en la línea 25 cuando se produce un fallo fase-tierra junto al nudo 5
%Al igual que el apartado anterior, el cálculo se ha dividido en varias
%secciones, con objeto de facilitar la ejecución del código. Los resultados
%obtenidos tras la ejecución se adjuntan en el mismo archivo .txt que los
%anteriores.
%% Matrices de admitancia e impedancia del sistema en secuencia homopolar, directa e inversa
%Las cargas se modelan como impedancias
zL5 = (u(5)^2^)/conj((30e6+15e6*1i)/Sb);%Diria que falta elevar los voltajes al cuadrado
zL3 = (u(3)2)/conj((30e6+15e6*1i)/Sb);
zL4 = (u(4)^2)/conj((15e6+7.5e6*1i)/Sb);
%Matrices de admitancia
Yhom = [y12(1)+yg1(1) -y12(1) 0 0 0;
        -y12(1) y12(1)+y23(1)+y25(1) -y23(1) 0 -y25(1);
        0 -y23(1) y23(1)+yt34+3*yTt34+y34(1)+yt3+1/zL3 -(yt34+3*yTt34+y34(1)) 0;
        0 0 -(yt34+3*yTt34+y34(1)) yt34+3*yTt34+y34(1)+yt45+y45(1)+1/zL4 -(yt45+y45(2));
        0 -y25(1) 0 -(yt45+y45(1)) y25(1)+yt45+y45(1)+1/zL5];
Ydir = [y12(2)+yg1(2) -y12(2) 0 0 0;
        -y12(2) y12(2)+y23(2)+y25(2) -y23(2) 0 -y25(2);
        0 -y23(2) y23(2)+yt34+y34(2)+yt3+yg3(2)+1/zL3 -(yt34+y34(2)) 0;
        0 0 -(yt34+y34(2)) yt34+y34(2)+yt45+y45(2)+1/zL4 -(yt45+y45(2));
        0 -y25(2) 0 -(yt45+y45(2)) y25(2)+yt45+y45(2)+1/zL5];
Yinv = [y12(3)+yg1(3) -y12(3) 0 0 0;
        -y12(3) y12(3)+y23(3)+y25(3) -y23(3) 0 -y25(3);
        0 -y23(3) y23(3)+yt34+y34(3)+yt3+yg3(3)+1/zL3 -(yt34+y34(3)) 0;
        0 0 -(yt34+y34(3)) yt34+y34(3)+yt45+y45(3)+1/zL4 -(yt45+y45(3));
        0 -y25(3) 0 -(yt45+y45(3)) y25(3)+yt45+y45(3)+1/zL5];
%Matrices de impedancia
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = u; %tensiones pre-falta del sistema
%% Cálculo de corrientes de falta, sin tener en cuenta desfases introducidos por transformadores trifásicos
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
disp('Corrientes de falta para cada una de las fases en la línea 25 (en A): ')
If25 = abs(Ib1*[Ifab(2,5,1);Ifab(2,5,2);Ifab(2,5,3)]) %corrientes de falta en la línea 25 para cada una de las fases
%% Calculo la tensión en cada uno de los nudos una vez deshabilitada la línea 25
%Para comenzar el cálculo iterativo se partirá de los valores obetenidos en
%la anterior resolución, es decir, de los valores de las variables
%eléctricas en los nudos con la línea 25 habilitada. De este modo,
%previsiblemente se reducirá el número de iteraciones necesarias para
%realizar el cálculo.
%% Matriz de admitancias del sistema: Sistema de 5 nudos
Ybus = [y12(2) -y12(2) 0 0 0;   %No se pone el generador
        -y12(2) y12(2)+y23(2) -y23(2) 0 0;
        0 -y23(2) y23(2)+yt34+y34(2) -(yt34+y34(2)) 0;
        0 0 -(yt34+y34(2)) yt34+y34(2)+yt45+y45(2) -(yt45+y45(2));
        0 0 0 -(yt45+y45(2)) yt45+y45(2)];
yab = [0 y12(2) 0 0 0;
        y12(2) 0 y23(2) 0 0;
        0 y23(2) 0 yt34+y34(2) 0;
        0 0 yt34+y34(2) 0 yt45+y45(2);
        0 0 0 yt45+y45(2) 0]; %matriz auxiliar para el cálculo
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
            iab(k,j) = (U(k)-U(j))*yab(k,j);
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
disp(['Tensión en el nudo 5 con la línea 25 deshabilitada: ' num2str(abs(u(5))*Ub1/1e3) ' kV'])