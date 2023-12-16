%% Examen parcial 7, año 2013 Iñaki Orradre
clear
clc
format shortEng
%Valores asignados máquinas eléctricas
Sng1 = 25e6;
Ung1 = 12.4e3;
Sng4 = 20e6;
Ung4 = 3.8e3;
Sng6 = 10e6;
Ung6 = 11e3;
Snt12 = 25e6;
UATt12 = 33e3;
UBTt12 = 11e3;
Snt34 = 20e6;
UATt34 = 33e3;
UBTt34 = 3.3e3;
Snt56 = 20e6;
UATt56 = 33e3;
UBTt56 = 11e3;
%Bases del sistema por unidad
Sb = 100e6;
Ub1 = 11e3;
Ib1 = Sb/Ub1/sqrt(3);
Zb1 = Ub1^2/Sb;
Yb1 = 1/Zb1;
Ub2 = Ub1*UATt12/UBTt12;
Ib2 = Sb/Ub2/sqrt(3);
Zb2 = Ub2^2/Sb;
Yb2 = 1/Zb2;
Ub3 = Ub2*UBTt34/UATt34;
Ib3 = Sb/Ub3/sqrt(3);
Zb3 = Ub3^2/Sb;
Yb3 = 1/Zb3;
%Elementos del circuito equivalente por unidad
xg1 = [0.05i 0.1i 0.1i]*Sb/Sng1*(Ung1/Ub1)^2;
yg1 = 1./xg1;
xTg1 = 0.05i*Sb/Sng1*(Ung1/Ub1)^2;
xg4 = [0.04i 0.15i 0.15i]*Sb/Sng4*(Ung4/Ub3)^2;
yg4 = 1./xg4;
xg6 = [0.05i 0.1i 0.1i]*Sb/Sng6*(Ung6/Ub1)^2;
yg6 = 1./xg6;
xt12 = 0.08i*Sb/Snt12*(UBTt12/Ub1);
yt12 = 1/xt12;
xt34 = 0.1i*Sb/Snt34*(UBTt34/Ub3);
yt34 = 1/xt34;
xt56 = 0.1i*Sb/Snt56*(UBTt56/Ub1);
yt56 = 1/xt56;
y23 = 1/20i/Zb2;
y16 = 1/8i/Zb1;
y35 = 1/9i/Zb2;
%% Matrices de admitancias e impedancias del sistema
Yhom = [yg1(1)+1/(3*xTg1)+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 0 0 0 0;
        0 -y23 y23+y35+yt34 0 -y35 0;
        0 0 0 0.00000001 0 0;
        0 0 -y35 0 y35 0;
        -y16 0 0 0 0 y16]; 
Ydir = [yg1(2)+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0;
        0 0 -yt34 yt34+yg4(2) 0 0;
        0 0 -y35 0 y35+yt56 -yt56;
        -y16 0 0 0 -yt56 y16+yt56+yg6(2)];
Yinv = [yg1(3)+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0;
        0 0 -yt34 yt34+yg4(3) 0 0;
        0 0 -y35 0 y35+yt56 -yt56;
        -y16 0 0 0 -yt56 y16+yt56+yg6(3)];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = [1 1 1 1 1 1]; %se considera que el sistema funciona a tensión nominal en todos los nudos, se desprecia la carga.
%% Cálculo de corrientes de cortocircuito
%La presente sección se ejecutará varias veces para la resolución de las
%cuestiones a continuación, indicando en cada una de las ejecuciones los
%parámetros necesarios.
%Notación:
%v = Vector de tensiones pre-falta 
%Ydir = Matriz de admitancias en secuencia directa 
%Yinv = Matriz de admitancias en secuencia inversa 
%Yhom = Matriz de admitancias en secuencia homopolar 
%Zdir = Matriz de impedancias en secuencia directa 
%Zinv = Matriz de impedancias en secuencia inversa 
%Zhom = Matriz de impedancias en secuencia homopolar

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
%% Cuestión a: Corriente de falta cuando se produce cortocircuito FF en el nudo 6.
disp('Cuestión a:')
disp('Corriente de falta al producirse cortocirucuito entre dos fases en bornes del motor 6 (kA): ')
abs(Ifab(6,6,:))*Ib1/1e3
%% Cuestión b: Corriente máxima en el interruptor B cuando se produce cortocircuito FT en el nudo 6.
disp('Cuestión b:')
h34 = 5; %Supongo índice horario Dy5
ifB = [ifab(3,5,1);ifab(3,5,2);ifab(3,5,3)].*[0;cos(h34*pi/6)+1i*sin(h34*pi/6);cos(-h34*pi/6)+1i*sin(-h34*pi/6)];
IfB = A*ifB;
disp('Corriente de falta en el interruptor B al producirse un cortocirucuito fase-tiera en bornes del motor 6 (kA):')
abs(IfB)*Ib2/1e3
%% Cuestión c: Corriente en el interruptor B cuando se produce un cortocircuito FT en el nudo 5.
disp('Cuestión c:')
%Se considera que la conexión a tierra del transformador que lo
%alimenta no existe, no es necesario volver a cargar las matrices de
%admitancia del sistema, dado que no cambian con esa modificación.
disp('Corriente de falta en el interruptor B al producirse un cortocircuito fase-tierra en el nudo 5 (kA):')
abs(Ifab(5,6,:))*Ib2/1e3
%% Cuestión d: Corriente de falta cuando se produce un cortocircuito FT en mitad de la línea 16.
%Será necesario añadir un nudo al cálculo y por lo tanto, volver a cargar
%las matrices de admitancia e impedancia. Una vez cargadas, se ejecutará el
%código de cálculo.
Yhom = [yg1(1)+1/(3*xTg1)+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 0 0 0 0 0;
        0 -y23 y23+y35+yt34 0 -y35 0 0;
        0 0 0 0.00000001 0 0 0;
        0 0 -y35 0 y35 0 0;
        0 0 0 0 0 2*y16 -2*y16;
        -2*y16 0 0 0 0 -2*y16 4*y16]; 
Ydir = [yg1(2)+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 0 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0 0;
        0 0 -yt34 yt34+yg4(2) 0 0 0;
        0 0 -y35 0 y35+yt56 -yt56 0;
        0 0 0 0 -yt56 2*y16+yt56+yg6(2) -2*y16;
        -2*y16 0 0 0 0 -2*y16 4*y16];
Yinv = [yg1(3)+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 0 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0 0;
        0 0 -yt34 yt34+yg4(3) 0 0 0;
        0 0 -y35 0 y35+yt56 -yt56 0;
        0 0 0 0 -yt56 2*y16+yt56+yg6(3) -2*y16;
        -2*y16 0 0 0 0 -2*y16 4*y16];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = [1 1 1 1 1 1 1]; %vector de tensiones pre-falta
%% Visualización de resultados cuestión d
disp('Cuestión d:')
('Corriente de falta en cada fase cuando se produce un cortocircuito fase-tierra en medio de la línea 16 (kA):')
Ifab(7,7,:)*Ib1
%% Cuestión e: Cuestión en el nudo 2 cuando se produce cortocircuito del apartado a.
uf
disp('Cuestión e:')
disp('Tensión en el nudo 2 cuando se produce cortocircuito entre dos fases del motor en el nudo 4:')
h34 = 5; %Supongo índice horario Dy5
uf2 = [uf(1,2);uf(2,2);uf(3,2)].*[0;cos(h34*pi/6)+1i*sin(h34*pi/6);cos(-h34*pi/6)+1i*sin(-h34*pi/6)];
Uf2 = A*uf2;
abs(Uf2)*Ub2