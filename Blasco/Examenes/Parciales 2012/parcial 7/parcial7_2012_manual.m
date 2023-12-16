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
Sb = 25e6;
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
%% Matrices de admitancias e impedancias
Yhom = [yg1(1)+3*xTg1+yt12+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 -y23 0 0 0;
        0 -y23 y23+y35+yt34 0 -y35 0;
        0 0 0 0.0000001 0 0;
        0 0 -y35 0 y35 0;
        -y16 0 0 0 0 y16];

Ydir = [yg1(2)+yt12+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 -y23 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0;
        0 0 -yt34 yt34+yg4(2) 0 0;
        0 0 -y35 0 y35+yt56 -yt56;
        -y16 0 0 0 -yt56 yt56+y16+yg6(2)];
Yinv = [yg1(3)+yt12+y16 -yt12 0 0 0 -y16;
        -yt12 yt12+y23 -y23 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0;
        0 0 -yt34 yt34+yg4(3) 0 0;
        0 0 -y35 0 y35+yt56 -yt56;
        -y16 0 0 0 -yt56 yt56+y16+yg6(3)];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = [1.05 1.05 1.05 1.05 1.05 1.05]; %vector de tensiones pre-falta
a = -0.5 + sqrt(3)*1i/2;
A = [1 1 1;1 a^2 a;1 a a^2]; %Matriz de transformación componentes simétricas-componentes por fase
%% a) Cortocircuito FF en bornes del generador del nudo 6.
n = length(Ydir); %Número de nudos del sistema
%N = input('Nudo en el que se produce el fallo: ');
N = 6;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 3;
zf = 0;
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
disp('a) Corriente de falta al producirse un cortocircuito fase-fase en bornes del generador en el nudo 6 (kA):')
If = abs(A*[ifhom;ifdir;ifinv]*Ib1/1e3)
%% e) Tensión en el nudo 2 cuando se produce cortocircuito fase-fase en el generador del nudo 6
%Tensiones de falta
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
disp('e) Tensión de falta en el nudo 2 ante cortocircuito fase-fase en el generador del nudo 6 (kV):')
Uf2 = abs(A*uf(:,2))*Ub2/1e3
%% b) Corriente de falta en el interruptor B ante cortocircuito fase-tierra en el motor (nudo 4)
n = length(Ydir); %Número de nudos del sistema
%N = input('Nudo en el que se produce el fallo: ');
N = 4;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 2;
zf = 0;
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
%Calculo la corriente de falta que circula por el interruptor B
%considero el transformador t34 con índice horario 5
h34 = 5; %Yd5
%Variables eléctricas en secuencia directa del primario adelantadas
%respecto al secundario. Componente en secuencia inversa retrasada.
ifB = ((uf(:,5)-uf(:,3))*y35).*[0;cos(h34*pi/6)+1i*sin(h34*pi/6);cos(-h34*pi/6)+1i*sin(-h34*pi/6)];
IfB = A*ifB;
disp('b) Corriente en el interruptor B ante falta fase-tierra en bornes del motor (kA)')
IfB = abs(IfB*Ib2/1e3)
%% c) Corriente en el interruptor B cuando se produce cortocircuito fase-tierra en el nudo 5
%Se desprecia la conexión a teirra del transformador 56, aunque las
%matrices de admitancias del sistema no cambian.
n = length(Ydir); %Número de nudos del sistema
%N = input('Nudo en el que se produce el fallo: ');
N = 5;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 2;
zf = 0;
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
%Calculo la corriente de falta que circula por el interruptor B
ifB = (uf(:,6)-uf(:,5))*yt56;
IfB = A*ifB;
disp('c) Corriente en el interruptor B ante falta fase-tierra en el nudo 5 (kA):')
IfB = abs(IfB*Ib2/1e3)
%% d)Corriente de falta ante cortocircuito en medio de la línea 16
%Se debe añadir un nudo más al sistema, en el que se producirá la falta.
Yhom = [yg1(1)+3*xTg1+yt12+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 -y23 0 0 0 0;
        0 -y23 y23+y35+yt34 0 -y35 0 0;
        0 0 0 0.0000001 0 0 0;
        0 0 -y35 0 y35 0 0;
        0 0 0 0 0 2*y16 -2*y16;
        -y16*2 0 0 0 0 -y16*2 y16*4];

Ydir = [yg1(2)+yt12+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 -y23 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0 0;
        0 0 -yt34 yt34+yg4(2) 0 0 0;
        0 0 -y35 0 y35+yt56 -yt56 0;
        0 0 0 0 -yt56 yt56+yg6(2)+2*y16 -2*y16;
        -y16*2 0 0 0 0 -y16*2 y16*4];
Yinv = [yg1(3)+yt12+2*y16 -yt12 0 0 0 0 -2*y16;
        -yt12 yt12+y23 -y23 0 0 0 0;
        0 -y23 y23+y35+yt34 -yt34 -y35 0 0;
        0 0 -yt34 yt34+yg4(3) 0 0 0;
        0 0 -y35 0 y35+yt56 -yt56 0;
        0 0 0 0 -yt56 yt56+yg6(3)+2*y16 -2*y16;
        -y16*2 0 0 0 0 -y16*2 y16*4];
Zhom = inv(Yhom);
Zdir = inv(Ydir);
Zinv = inv(Yinv);
v = [1.05 1.05 1.05 1.05 1.05 1.05 1.05];
n = length(Ydir); %Número de nudos del sistema
%N = input('Nudo en el que se produce el fallo: ');
N = 7;
%tipo_fallo = input('Tipo de fallo: FFF (1), FT (2), FF (3), FFT (4) ');
tipo_fallo = 2;
zf = 0.1i;
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
disp('d) Corriente de falta al producirse cortocircuito fase-tierra en mitad de la línea 16 (kA):')
If7 = abs(A*[ifhom;ifdir;ifinv])*Ib1/1e3