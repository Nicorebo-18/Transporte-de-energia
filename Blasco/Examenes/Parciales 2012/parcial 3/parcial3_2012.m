%% Examen parcial 3, año 2012 Iñaki Orradre
clear
clc
format shortEng
%% Problema 1
disp('Problema 1:')
%Bases del sistema por unidad
Sb = 100e6;
Ub = 66e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Datos de la línea
long = 48e3; %m
R = 0.213e-3; %ohm/m
L = 1.28e-6; %H/m
C = 9.3e-12; %F/m
r = R/Zb; %resistencia por unidad de longitud, expresada en por unidad
x = 2i*pi*50*L/Zb;%reactancia inductiva por unidad de longitud, expresada en por unidad
b = 2i*pi*50*C/Yb; %susceptancia capacitiva por unidad de longitud, expresada en por unidad
%Carga al final de la línea
u2 = 66e3/Ub;
fdp = 0.8; %inductivo
p2 = 10e6/Sb;
s2 = p2+p2*1i*tan(acos(fdp));
i2 = conj(s2/u2);
%Empleo el modelo general de la línea para calcular la tensión que debe
%haber en el extremo emisor
zu = r + x;
yu = b;
zc = sqrt(zu/yu); %Impedancia característica de la línea, en por unidad
gamma = sqrt(zu*yu); %Constante de propagación de la línea, en por unidad
%Relaciones entre variables eléctricas (1 extremo emisor, 2 extremo
%receptor)
%Expresado en forma matricial
u1i1 = [cosh(gamma*long) zc*sinh(gamma*long);sinh(gamma*long)/zc cosh(gamma*long)]*[u2;i2]; %[u1;i1]
disp(['Tensión en el extremo emisor: ' num2str(abs(u1i1(1,1))*Ub/1e3) ' kV'])
%% Problema 2
disp('Problema 2:')
%Nueva carga al final de la línea
u1 = u1i1(1,1);
u2 = 66e3/Ub;
fdp = 0.8; %inductivo
p2 = 15e6/Sb;
qc = 0; %Potencia de la batería de condensadores, valor inicial para comenzar el cálculo iterativo
s2 = p2+p2*1i*tan(acos(fdp))-qc;
i2 = conj(s2/u2);
u1i1 = [cosh(gamma*long) zc*sinh(gamma*long);sinh(gamma*long)/zc cosh(gamma*long)]*[u2;i2]; %tensión con la nueva carga
error = abs(u1i1(1,1))-abs(u1);
%Calculo la potencia necesaria de la batería de condensadores para mantener
%la tensión del nudo 1, cálculo iterativo
while abs(error)>0.1/Ub
    if error>0
        qc = qc + 0.00001;
    else
        qc = qc - 0.00001;
    end
    s2 = p2+p2*1i*tan(acos(fdp))-1i*qc;
    i2 = conj(s2/u2);
    u1i1 = [cosh(gamma*long) zc*sinh(gamma*long);sinh(gamma*long)/zc cosh(gamma*long)]*[u2;i2]; %tensión con la nueva carga
    error = abs(u1i1(1,1))-abs(u1);
end
disp(['Potencia que debe suministrar la batería de condensadores: ' num2str(qc*Sb/1e6) ' MVAr'])
Xc = (u2^2/qc)*Zb; %reactancia capacitiva por fase
C = 1/Xc/2/pi/50;
disp(['Capacidad por fase de la batería de condensadores: ' num2str(C*1e6) ' uF'])
%% Problema 3
clear
disp('Problema 3:')
%Bases del sistema por unidad
Sb = 100e6;
Ub = 220e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
Yb = 1/Zb;
%Datos de la línea
R = 72.1e-6; %ohm/m
X = 424.2e-6; %ohm/m
B = 2693e-12; %S/m
r = R/Zb;
x = X/Zb;
b = B/Yb;
%Carga al final de la línea
u2 = 220e3/Ub;
fdp = 0.8; %inductivo
s2 = 100e6/Sb*(cos(fdp)+1i*sin(acos(fdp)));
i2 = conj(s2/u2);
u1max = 1.05;
u1min = 1.05;
%Empleo el modelo general de la línea para los cálculos
zu = r + x;
yu = b;
zc = sqrt(zu/yu); %Impedancia característica de la línea, en por unidad
gamma = sqrt(zu*yu); %Constante de propagación de la línea, en por unidad
%Relaciones entre variables eléctricas (1 extremo emisor, 2 extremo
%receptor)
long = 1e3; %valor inicial para comenzar el cálculo iterativo
u1i1 = [cosh(gamma*long) zc*sinh(gamma*long);sinh(gamma*long)/zc cosh(gamma*long)]*[u2;i2]; %[u1;i1]
error = u1max-abs(u1i1(1,1));
while abs(error)>0.0000001
    if error>0
        long = long+1;
    else
        long = long-1;
    end
    u1i1 = [cosh(gamma*long) zc*sinh(gamma*long);sinh(gamma*long)/zc cosh(gamma*long)]*[u2;i2]; %[u1;i1]
    error = u1max-abs(u1i1(1,1));
end
disp(['Longitud máxima de la línea: ' num2str(long/1e3) ' km'])