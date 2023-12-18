%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%    ----- Extraido del problema 2-Trafo,ExamenTrafo... -----   %
%                    Páginas 11-14 Apuntes                      %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería



%%%%%%%%%% PASOS PARA RESOLVER CUALQUIER PROBLEMA P.U %%%%%%%%%%%


% 1º Dibujo -> Cada trafo = Distintos niveles de tensión


%|||||||||| PASO 1: ESTABLECER BASES DEL SISTEMA |||||||||||

% Bases Principales:
Sb;                      % Da igual cual cojamos -> Recomendable coger el de uno o varios trafos
Ub1,Ub2,Ub3;             % Tantas bases de tensión como niveles de tensión haya
UbAT = UbBT * (UAT/UBT); % Si hay trafos y desconocemos el resto de tensiones, para establecer las otras bases


%||||||| PASO 2: ESTABLECER LAS OTRAS BASES DEL SISTEMA ||||||||

% Bases Secundarias
Zb = (Ub^2)/Sb;         % Impedancia base
Yb = 1/Zb;              % Admitancia base
Ib = Sb/(sqrt(3)*Ub);   % Corriente base


%||||||| PASO 3: Impedancias/Admitancias DEL SISTEMA ||||||||

zpu = Z/Zb;
ypu = 1/zpu;
ypu = Y/Yb;

% En transformadores numéricamente (Con bases = al trafo): 
uccpu = zccpu;

% Si las bases no coinciden con las del sistema -> Cambio de base
xpu = xpunom * (Sb/Sn) * (Un/Ub)^2;     % Cuidado, tensión y potencia tienen que estar en el mismo lado


%%%%%%%%%% FÓRMULAS ÚTILES %%%%%%%%%%%
% Corriente a partir de potencia y tensión
i1 = conj(sc/u);

% Impedancia
z = r + xi