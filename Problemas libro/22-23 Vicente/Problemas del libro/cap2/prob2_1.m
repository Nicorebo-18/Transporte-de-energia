%problema 2.1
clc
clear
S=10e6;%potencia aparente de la carga en VA
U=20e3;%tensión de la carga en V
U1=132e3;%tensión de suministro en AT
%la tensión nominal de los transformadores monofásicos está por debajo de 100 kV y corrientes nominales por debajo de 250 A
%
%a) Es posible alimentar la carga utilizando sólo 3 transformadores monofásicos?
disp(['Para que puedan conectarse a 132 kV los devanados de AT deben estar conectados en estrella'])
disp(['Recibirían una tensión de ' num2str(U1/sqrt(3)/1e3) ' kV'])
icarga=S/U/sqrt(3);%corriente de la carga por fase
disp(['La corriente por fase en la carga es ' num2str(icarga) ' A'])
disp(['Si la tensión nominal en el lado de BT es 20 kV y se conectan en triángulo'])
disp(['La corriente en cada transformador sería de ' num2str(icarga/sqrt(3)) ' A'])
