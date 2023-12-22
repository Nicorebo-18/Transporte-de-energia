%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ------- Extraido de los problemas 4-4 y 4-5 --------     %
%                       Página 4 Apuntes                        %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


%%%%%%%%%%%%%%%%%%%%% COMENTARIOS GENERALES %%%%%%%%%%%%%%%%%%%%%%%


% 1º Revisar casos disponibles en documento "Parámetros de las lineas.pdf".
% 2º No existen todas las configuraciones en ese pdf pero siempre son derivados,
%    asi que prestar atención al número de cables por fase y número de fases. 
% 3º Meter los datos muy despacio y asegurarse de que son esos los correctos (Unidades y distancias)


%%%%%%%%%%%%%%%%%%%%% CASOS DE EJEMPLO %%%%%%%%%%%%%%%%%%%%%%%

% ----------- Variables generales -----------
U = ;                % Tensión nominal de la linea
f = ;                   % Frecuencia de la red

diam = ;             % Diámetro del conductor
r = diam/2;               % Radio del conductor

u0 = 4e-7*pi;             % Permeabilidad del aire
c = 299792458;            % Velocidad de la luz
eps0 = 1/(u0*c^2);        % Permitividad del aire

Ru20 = /1e3;     % Resistencia del conductor (Ohm/km -> Ohm/m)
R_cond = Ru20*(1+4.03e-3*(Temperatura-20));  % Suponemos una Tª max de funcionamiento
n = 2;                    % Número de conductores


%/////////////// Caso 1 - Línea aérea trifásica asimétrica dúplex de doble circuito //////////////

% ------------- Dibujo -------------

%       ◯a ◯a'      ◯b ◯b'      ◯c ◯c'
%          |<--- 15m --->|<--- 15m --->|

% ----------- Definir variables -----------
d = ;                  % Distancia del Haz (Entre 2 cables de la msima fase)
D_ab = ;                % Distancia entre fases a y b
D_bc = ;                % Distancia entre fases b y c
D_ca = D_ab + D_bc;       % Distancia entre fases

% ----------- Cálculos -----------
R_fase = R_cond/n;        % Resistencia unitaria de la linea por fase (2 fases)
Lu = (u0/(2*pi))*log(((D_ab*D_bc*D_ca)^(1/3))/(n*r*exp(-1/4)*d/(2*sin(pi/n)))^(n-1)); % Inductancia
Xu = 2*pi*f*Lu;           % Reactancia Unitaria
Cu = (2*pi*eps0)/log(((D_ab*D_bc*D_ca)^(1/3))/(n*r*exp(-1/4)*d/(2*sin(pi/n)))^(n-1)); % Capacidad
Bu = 2*pi*f*Cu;           % Susceptancia Unitaria




%/////////////// Caso 2 - Línea aérea trifásica asimétrica de doble circuito /////////////

% ------------- Dibujo -------------

%       ◯a     ◯b     ◯c     ◯a'    ◯b'    ◯c'
%       |<- 1m -><- 1m -><- 1m -><- 1m -><- 1m ->|

% ----------- Definir variables -----------
D_ab = ;                % Distancia entre fases a y b
D_bc = ;                % Distancia entre fases b y c
D_ca = ;                % Distancia entre fases c y a
D_AB = ;                % Distancia entre fases a' y b'
D_BC = ;                % Distancia entre fases b' y c'
D_CA = ;                % Distancia entre fases c' y a'
D_aB = ;
D_Ab = ;
D_bC = ;
D_Bc = ;
D_cA = ;
D_Ca = ;
D_aA = ;
D_bB = ;
D_cC = ;

% ----------- Cálculos -----------
raiz = ((D_ab*D_aB*D_Ab*D_AB)^(1/4)*(D_bc*D_bC*D_Bc*D_BC)^(1/4)*(D_ca*D_cA*D_Ca*D_CA)^(1/4))^(1/3);

R_fase = R_cond/n;        % Resistencia unitaria de la linea por conductor
Lu = (u0/(2*pi))*log(raiz/(sqrt(r*exp(-1/4))*(D_aA*D_bB*D_cC)^(1/6))); % Inductancia
Xu = 2*pi*f*Lu;           % Reactancia Unitaria
Cu = (2*pi*eps0)/log(raiz/(sqrt(r)*(D_aA*D_bB*D_cC)^(1/6))); % Capacidad
Bu = 2*pi*f*Cu;           % Susceptancia Unitaria