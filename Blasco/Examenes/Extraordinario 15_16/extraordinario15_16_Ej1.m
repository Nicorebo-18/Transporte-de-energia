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
