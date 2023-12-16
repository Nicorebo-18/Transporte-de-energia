%problema 9.6
%Este problema ya lo resolvimos simb�licamente en clase
%Esta podr�a ser la resoluci�n num�rica
clear
clc
%
xg=[0i;1i;1i];%asignamos valores arbitrarios teniendo en cuenta que xghom<<xgdir y que xgdir=xginv
xn=0.3333i;%asignamos otro valor arbitrario que se va cambiando hasta llegar al l�mite |Ifaltafff|=|Ifaltaft|
%Caso del cortocircuito trif�sico
v=[0;1;0];%asignamos otro valor arbitrario
ifaltafff=[0;v(2)/xg(2);0];%corriente de cortocircuito trif�sica en componentes sim�tricas
a=-0.5+0.5i*sqrt(3);
A=[1 1 1;
1 a^2 a;
1 a a^2];
Ifaltafff=abs(A*ifaltafff)%corriente de cortocircuito trif�sica por fase en p.u. y en m�dulo
%Caso del cortocircuito fase-tierra
ifaltadir=v(2)/(xg(1)+xg(2)+xg(3)+3*xn);
ifaltaft=[ifaltadir;ifaltadir;ifaltadir];%corriente de cortocircuito fase-tierra en componentes sim�tricas
Ifaltaft=abs(A*ifaltaft)%corriente de cortocircuito fase-tierra por fase en p.u. y en m�dulo
%
disp(['Conclusi�n'])
disp(['Con xn=0.3333i el m�dulo de la corriente por la fase a es igual en ambos tipos de cortocircuito y'])
disp(['si xn<0.3333i la corriente FT ser� mayor que la FFF'])
