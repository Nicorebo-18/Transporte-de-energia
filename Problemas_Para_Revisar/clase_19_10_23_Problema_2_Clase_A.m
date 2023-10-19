%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%      ---------- PROBLEMA Clase A (Pag 15.) -----------        %
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

s12a = u2*conj(i12a)
s12a = u2*conj(i12b)



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