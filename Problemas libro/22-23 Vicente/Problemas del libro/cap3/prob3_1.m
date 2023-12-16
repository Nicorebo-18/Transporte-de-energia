%prob 3.1
clc
clear
%datos
pg=1;
fdp=0.8;%ind
u=1;
xg=1i;
%calc E
qg=pg*tan(acos(fdp));
sg=pg+qg*i;
ig=conj(sg/u);
eg=u+ig*xg;
disp(['Eg = ' num2str(abs(eg)) ' /___' num2str(angle(eg)) ' p.u.'])
