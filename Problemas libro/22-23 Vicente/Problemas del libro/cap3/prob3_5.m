%prob 3.5
clear
clc
S=318.75e3;%potencia nom maq
U=2300;%tension nom maq
R=0.35;%resistencia por fase
X=1.2;%reactancia por fase
fpind=0.8;%factor de potencia en retraso
fpcap=0.6;%factor de potencia en adelanto
%
Sb=318.75e3;%base potencia
Ub=2300;%base tensión
Zb=Ub^2/Sb;%base impedancia
%
z=(R+X*1i)/Zb;%impedancia maq en pu
u=U/Ub;
s=S/Sb;
%
s1=s*fpind+s*fpind*tan(acos(fpind))*1i;%potencia nom en forma compleja
i1=conj(s1/u);%corriente nom
e1=u+i1*z;%tension en vacío en pu
E1=e1*Ub;%tension en vacío con fp=0.8 en retraso
modE1=abs(E1)%modulo
argE1=angle(E1)%argumento
%
s2=s*fpcap-s*fpcap*tan(acos(fpcap))*1i;
i2=conj(s2/u);
e2=u+i2*z;
E2=e2*Ub;%tension en vacio con fp=0.6 adelanto
modE2=abs(E2)%módulo
argE2=angle(E2)%argumento
%
regulacion1=(abs(e1)-u)/u;
disp(['Regulación a plena carga, fdp=0,8 inductivo y tensión nominal=' num2str(regulacion1*100) ' %'])
regulacion2=(abs(e2)-u)/u;
disp(['Regulación a plena carga, fdp=0,6 capacitivo y tensión nominal=' num2str(regulacion2*100) ' %'])
