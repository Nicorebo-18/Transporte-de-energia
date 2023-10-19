%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ------- PROBLEMA Clase A (Pag 15. Apuntes) --------      %
%                    Clase 19/10/2023                           %
%                  Nicolás Rebollo Ugarte                       %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc                       % Borrar toda la Consola / Ventana de comandos
clear                     % Borra todas las variables
format shortEng           % Pone el formato de ingeniería


% ----------- Definir variables -----------
u2 = 1;
x12a = 0.1i;
x12b = 0.2i;
i2 = cos(-pi/6) + 1i*sin(-pi/6);

% ----------- Cálculos -----------
i12b = i2/(1+x12b/x12a);
i12a = i12b*x12b/x12a;

s12a = u2*conj(i12a);
s12a = u2*conj(i12b);

% *Modificación -> Trafo de Módulo
t = 1.03;
u = 0.97;
u1 = (i2*x12a*x12b+x12b+0.097i)/0.3i;
i12atrm = (u1-u2)/x12a;
i12btrm = (u1-u)/x12b;
s12atrm = u2*conj(i12atrm);
s12btrm = u2*conj(i12btrm);

% *Modificación -> Trafo de Fase
utrd = cos(-2*pi/180) + 1i*sin(-2*pi/180);
u1trd = (i2*x12a*x12b+x12b+x12a*utrd)/(x12a+x12b);
i12atrd = (u1trd-u2)/x12a;
i12btrd = (u1trd-utrd)/x12b;
s12atrd = u2*conj(i12atrd)
s12btrd = u2*conj(i12btrd)

% ----------- Imprimir Resultados -----------
disp("\nResultados: \n")




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