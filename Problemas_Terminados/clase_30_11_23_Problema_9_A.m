%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 9-A --------------             %
%                    Clase 30/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Definimos bases principales
Sb = 100e6;
UbG = 12e3;
UbL = 66e3;
UbNI = 12e3;

% Bases Derivadas
ZbL = UbL^2/Sb;
IbL = Sb/(sqrt(3)*UbL);


% Generador
SG = 60e6;
UG = 12e3;
xG = 0.35i; 
xg = xG*(Sb/SG)*(UG/UbG)^2;

% Trafo 1-2
ST12 = 80e6;
UATT12 = 66e3;
UBTT12 = 12e3;
xT12 = 0.08i;
xt12 = xT12*(Sb/ST12);

% Trafo 3-4
xt34 = xt12;

% Impedancia de la linea
X23 = 12i;
x23 = X23/ZbL;

% Fuente de tensión infinita potencia
xni = 1e-120;


% ----------- Cálculos -----------

% Matriz SOLO Directa porque estamos ante un cortocircuito trifásico
Ydir = [1/xg+1/xt12 -1/xt12         0               0;
        -1/xt12     1/xt12+1/x23    -1/x23           0;
        0           -1/x23          1/x23+1/xt34    -1/xt34;
        0           0               -1/xt34         1/xt34+1/xni];

Zdir = inv(Ydir);

% Cortocircuito trifásico en el nudo 3
q = 3;
v = [   0       0       0       0;
        1.1     1.1     1.1     1.1;
        0       0       0       0];

% ifff está mal, debería salir 0 - 12.1472i
ifff = v(2,q)/Zdir(q,q);        % Componente directa de la corriente de falta trifásica
ufalta(2,3) = 0;

iB = (v(2,4)-ufalta(2,3))/xt34; % Componente directa de la componente directa por el int B
iA = ifff - iB;                 % Componente directa de la corriente por el int A

% No hace falta convertir de componentes siméticas a por fases ya que solo tenemos la componente directa

IA = abs(iA)*IbL/1e3;
IB = abs(iB)*IbL/1e3;

% No sirve para calcular el poder de corte del interruptor ya que es la corriente de cortocircuito en regimen permanente y nos interesa el transitorio
% Pág 266 Libro -> Tenemos que multiplicar icc * 2√2 para pico máximo

IA = IA * 2*sqrt(2);
IB = IB * 2*sqrt(2);

% Estamos ante un cortocircuito equilibraso y no hay que tener en cuenta el desfase del trafo.
% Si que habría que tenerla en cuenta si fuese un cortocircuito desequlibrado


% Apartado B - Alternativa de corriente de falta
u4 = 11e3/UbNI;
fdp = 0.8; % En retraso (Inductivo)
SNI = 50e6*(fdp+1i*sin(acos(fdp)));
ipf = conj((SNI/Sb)/u4);

u3 = u4 + ipf*xt34;
u2 = u3 + ipf*x23;
u1 = u2 + ipf*xt12;  % Buenas soluciones

% Cálculo de las FEM de cada fuente de tensión
e1 = u1 + ipf*xg;
eni = u4;

ifff2 = u3/Zdir(3,3);
w = [0	0	0	0;
	u1	u2	u3	u4;
	0	0	0	0];
ufalta = zeros(3,4);

for k=1:4
	ufalta(:,k) = w(:,k)-Zdir(k,q)*ifff2;
end

iB2 = (ufalta(2,4)-ufalta(2,3))/xt34;
iA2 = ifff2-iB2;
IA2 = abs(iA2)*2*sqrt(2)/1e3;
IB2 = abs(iB2)*2*sqrt(2)/1e3;








% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

IA      % 2.8386 kA
IB      % 27.2166 kA

disp("\nComparacion A:")
abs(iA)
abs(iA2)

disp("\nComparacion B:")
abs(iB)
abs(iB2)








% # Herramientas para imprimir en octave #

% printf("",) 
% disp() con [num2str()]

% --- Para Plots ---
% h=plot (x, sin (x));
% xlabel ("x");
% ylabel ("sin (x)");
% title ("Simple 2-D Plot");
% waitfor(h);
% -------------------