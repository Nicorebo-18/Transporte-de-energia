%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%          ------------ PROBLEMA 8-1 --------------             %
%                    Clase 13/11/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
%format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------

% Definimos las bases
Sb = 100e6;

Ub1 = 11e3;
Ub2 = 33e3;
Ub3 = 6.6e3;

% Bases derivadas
Zb1 = Ub1^2/Sb;
Zb2 = Ub2^2/Sb;
Zb3 = Ub3^2/Sb;

Ib1 = Sb/(Ub1*sqrt(3));
Ib2 = Sb/(Ub2*sqrt(3));
Ib3 = Sb/(Ub3*sqrt(3));

% Expresar todo en por unidad
xG1a = 0.1i;
SG1a = 10e6;
UG1a = 11e3;
xg1a = xG1a*(Sb/SG1a)*(UG1a/Ub1)^2;
yg1a = 1/xg1a;

xG1b = 0.125i;
SG1b = 10e6;
UG1b = 11e3;
xg1b = xG1b*(Sb/SG1b)*(UG1b/Ub1)^2;
yg1b = 1/xg1b;

xT12 = 0.1i;
ST12 = 10e6;
UAT12 = 33e3;
xt12 = xT12*(Sb/ST12)*(UAT12/Ub2)^2;
yt12 = 1/xt12;

xT34 = 0.08i;
ST34 = 5e6;
UAT34 = 33e3;
xt34 = xT34*(Sb/ST34)*(UAT34/Ub2)^2;
yt34 = 1/xt34;

long23 = 30e3;
Zu23 = (0.27 + 0.36i)/1e3;  % Ohm/m
z23 = Zu23*long23/Zb2;
y23 = 1/z23;

long45 = 3e3;
Zu45 = (0.135 + 0.08i)/1e3;  % Ohm/m
z45 = Zu45*long45/Zb3;
y45 = 1/z45;




% ----------- Cálculos -----------

% Matriz de admitancias del sistema
Ybus = [yg1a+yg1b+yt12  -yt12       0           0           0;
        -yt12           yt12+y23    -y23        0           0;
        0               -y23        y23+yt34   -yt34        0;
        0               0           -yt34       yt34+y45    -y45;
        0               0           0           -y45        y45];

Zbus = inv(Ybus);


% Producimos un cortocircuito en el nudo 5
% Cálculo de la falta:
n = 5;                          % Número de nudos
q = 5;                          % Nudo donde se está produciendo el cortocircuito
v = [1 1 1 1 1];                % Tensión de prefalta en el nudo 1
ifaltaFFF5(q) = v(q)/Zbus(q,q);
i23 = abs(ifaltaFFF5(q));

ufalta = zeros(1,n);

for k=1:n
        ufalta(1,k) = v(1,k)-Zbus(k,q)*ifaltaFFF5(q);
end

ufalta
i23 = abs((ufalta(2)-ufalta(3))*y23)
i45 = abs((ufalta(4)-ufalta(5))*y45)








%q = 5;
%v = 1;                          % Tensión de prefalta en el nudo 1
%ifaltaFFF5 = v/Zbus(5,5);
%
%IT12BT = ifaltaFFF5*Ib1/1e3;    % Resultado en KA
%I23 = ifaltaFFF5*Ib2/1e3;       % Resultado en KA
%IT12AT = I23;
%IT34AT = I23;
%I45 = ifaltaFFF5*Ib3/1e3;        % Resultado en KA
%
%
%% Tensión de falta en el nudo 1
%ufalta1 = v - Zbus(1,5)*ifaltaFFF5;
%Ufalta1 = ufalta1*Ub1/1e3;       % Resultado en KV








% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")

%ifaltaFFF5
%abs(IT12BT)
%abs(I23)
%abs(I45)
%abs(Ufalta1)



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