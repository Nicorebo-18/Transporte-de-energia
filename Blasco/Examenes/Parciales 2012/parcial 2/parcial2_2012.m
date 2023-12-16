%% Examen parcial 2, año 2012 Iñaki Orradre
clear
clc
format shortEng
%% Problema 1: Generador síncrono.
disp('Problema 1:')
%Bases del sistema por unidad
Sb = 10e6;
Ub = 13.2e3;
Ib = Sb/Ub/sqrt(3);
Zb = Ub^2/Sb;
%Parámetros del generador
xs = 10i/Zb;
%Punto de funcionamiento del enunciado
u0 = 13.2e3/Ub; %tensión constante, nudo de potencia infinita
fdp0 = 0.95; %capacitivo
s0 = 9e6/Sb*(cos(fdp0)-1i*sin(acos(fdp0)));
is0 = conj(s0/u0);
e0 = u0+is0*xs; %tensión de vacío
%a) Manteniendo la potencia activa se suministran 7 MVAr
s1 = real(s0)+1i*7e6/Sb;
is1 = conj(s1/u0);
e1 = u0+is1*xs; %tensión de vacío
%Calculo en que porcentaje debe modificarse la corriente de excitación
%respecto al punto de funcionamiento descrito en el enunciado
disp(['a) La corriente de excitación debe aumentarse un ' num2str(((abs(e1)/abs(e0)-1)*100)) ' %'])
%b) ¿Será necesario cambiar la entrada de agua?
disp(['b) Corriente suministrada por el generador: ' num2str(abs(is1)*Ib) ' A'])
if abs(is1)*Ib>525
    disp('   Será necesario reducir la entrada de agua, dado que el generador funciona sobrecargado.')
else
    disp('   No será necesario modificar la entrada de agua, la corriente está por debajo de la nominal.')
end
%c) Máxima potencia activa antes de que se activen las protecciones,
%suministrando 7MVar
%Realizo cálculo iterativo
p2 = real(s0);
s2 = p2+1i*7e6/Sb;
is2 = conj(s2/u0); %valores iniciales para comenzar el cálculo
error = 525/Ib-abs(is2);
while abs(error)>0.001/Ib
    if error>0
        p2 = p2+0.00001;
    else
        p2 = p2-0.00001;
    end
    s2 = p2+1i*7e6/Sb;
    is2 = conj(s2/u0); %valores iniciales para comenzar el cálculo
    error = 525/Ib-abs(is2);
end
disp(['c) Potencia activa máxima que puede suministrar el generador antes de que se disparen las protecciones: ' num2str(real(s2)*Sb/1e6) ' MW'])
%% Problema 2: Parámetros eléctricos de líneas eléctricas.
disp('Problema 2:')
%Constantes empleadas en el cálculo
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%Línea áerea trifásica asimétrica
%Parámetros de la línea
long = 4.5e3; %Longitud de la línea
Dab = 0.3;
Dbc = 0.3;
Dac = Dab+Dbc; %Distancias entre conductores
radio = 11.5e-3/2; %Radio de los conductores
Rc = 387e-6*(1+(3.92e-3*(80-20))); %Resistencia del conductor por unidad de longitud Ohm/m, a 80 ºC
%Calculo la resistencia y la reactancia inductiva de la línea
R = Rc; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/(radio*exp(-0.25)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
Rtotal = R*long;
Xtotal = 2*pi*f*L*long;
disp(['Resistencia por fase de la línea: ' num2str(Rtotal) ' Ohmios'])
disp(['Reactancia inductiva por fase de la línea: ' num2str(Xtotal) ' Ohmios'])
%% Problema 3: Rueda hidráulica.
disp('Problema 3:')
%Velocidad de giro del alternador para generar a 50 Hz
f = 50; %frecuencia de las variables eléctricas
p = 12; %pares de polos del generador
Wmec = 2*pi*f/p/pi*60;
Wrueda = 8; %velocidad de giro de la rueda hidráulica
%La relación de transmisión de la intercambiadora será la relación entre
%la velocidad de giro de necesaria para generar a 50 Hz y la velocidad de
%giro de la rueda
r = Wmec/Wrueda;
disp(['Relación de transmisión de la caja multiplicadora: ' num2str(r)])
%% Problema 4: Parámetros de líneas eléctricas.
disp('Problema 4:')
%Constantes empleadas en el cálculo
mu0 = 4e-7*pi; %Permeabilidad magnética del vacío
cluz = 299792458; %Velocidad de la luz en vacío
eps0 = 1/mu0/cluz^2; %Permitividad eléctrica del vacío
f = 50; %frecuencia en Hz
%a) Línea aérea trifásica asimétrica duplex
long = 114e3; %Longitud de la línea
Dab = 6.7;
Dbc = 6.7;
Dac = 13.22; %Distancias entre conductores
d = 0.4; %Distancia entre conductores del mismo haz, en m
radio = 25.4e-3/2; %Radio de los conductores
Rc = 85.1e-6*(1+3.92e-3*(80-20)); %Resistencia del conductor por unidad de longitud Ohm/m, a 80 ºC

R = Rc/2; %Resistencia de la línea por unidad de longitud
L = mu0*log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*exp(-0.25)*d))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log((Dab*Dbc*Dac)^(1/3)/sqrt(radio*d)); %Capacidad de la línea por unidad de longitud C/m
disp(['a) Resistencia por fase de la línea: ' num2str(R*long) ' Ohm'])
disp(['   Inductancia por fase de la línea: ' num2str(L*long) ' H'])
disp(['   Capacidad por fase de la línea: ' num2str(C*long) ' F'])
%b) Línea aérea trifásica duplex asimétrica de doble circuito
DAB = 6.7;
DAb = sqrt((9.8+6.7*sin(acos(13.22/2/6.7)))^2+(13.22/2)^2);
DaB = DAb;
Dab = DAB;
DBC = DAB;
DBc = DAb;
DbC = DAb;
Dbc = DAB;
DAC = 13.22;
DAc = 9.8;
DaC = 9.8;
Dac = 13.22; 
DAa = sqrt(9.8^2+13.22^2);
DBb = 9.8+2*6.7*sin(acos(13.22/2/6.7));
DCc = DAa; %Distancias entre conductores

R = Rc/4; %Resistencia de la línea por unidad de longitud
L = mu0*log(((DAB*DAb*DaB*Dab)^(1/4)*(DBC*DBc*DbC*Dbc)^(1/4)*(DAC*DAc*DaC*Dac)^(1/4))^(1/3)/((radio*exp(-0.25)*d)^(1/4)*(DAa*DBb*DCc)^(1/6)))/2/pi; %Inductancia de la línea por unidad de longitud H/m
C = 2*pi*eps0/log(((DAB*DAb*DaB*Dab)^(1/4)*(DBC*DBc*DbC*Dbc)^(1/4)*(DAC*DAc*DaC*Dac)^(1/4))^(1/3)/((radio*d)^(1/4)*(DAa*DBb*DCc)^(1/6))); %Capacidad de la línea por unidad de longitud C/m
disp(['b) Resistencia por fase de la nueva línea: ' num2str(R*long) ' Ohm'])
disp(['   Inductancia por fase de la nueva línea: ' num2str(L*long) ' H'])
disp(['   Capacidad por fase de la nueva línea: ' num2str(C*long) ' F'])