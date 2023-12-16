% Ejercicio 2 Iñaki Orradre
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
% Apartados a y b
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
% Apartado c (corregido)
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