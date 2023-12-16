%% Examen extraordinario 2015/16 Iñaki Orradre
clear
clc
format shortEng
% Problema 4: Corrientes de cortocircuito trifásico.
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
% Cálculo de corrientes de cortocircuito
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
% Visualización de resultados
disp('Corriente de cortocircuito en la línea 23 (por unidad), en cada una de las fases:')
abs(Ifab(2,3,:))
disp('Corriente de cortocircuito en la línea 34 (por unidad), en cada una de las fases:')
abs(Ifab(4,3,:))