%problema 5.11
clc
clear
%Datos
A=0.86;
B=130.2i;
C=0.002i;
D=A;
U2=500e3;
S2=1000e6;
fdp=0.8;%ind
Xc=-100i/2;
%Bases
Ub=U2;
Sb=S2;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%Valores en pu
s2=(S2*fdp+i*S2*sin(acos(fdp)))/Sb;
u2=U2/Ub;
xc=Xc/Zb;
a=A;%A=cosh(Gamma*long); Gamma=sqrt(Zu*Yu); gamma=sqrt(Zu/Zb*Yu/Yb)=Gamma
b=B/Zb;%B=Zc*sinh(Gamma*long)=Z';z'=Z'/Zb;
y_2=(a-1)/b;%A=1+Z'*Y'/2
d=a;
c=2*y_2*(1+b*y_2/2);%C=Y'*(1+Z'*Y'/4)
%
Tlinea=[a b;c d];
Tcondensador=[1 xc;0 1];
Tsist=Tcondensador*Tlinea*Tcondensador%respuesta b)
%
i2=conj(s2/u2);
ui1=Tlinea*[u2;i2];

disp(['U1= ' num2str(abs(ui1(1))*Ub/1e3) 'kV /___' num2str(angle(ui1(1))) ' rad'])
disp(['I1= ' num2str(abs(ui1(2))*Ib) 'A /___' num2str(angle(ui1(2))) ' rad'])%respuesta a)
%
ui1todo=Tsist*[u2;i2];
disp(['Con condensadores en serie'])
disp(['U1= ' num2str(abs(ui1todo(1))*Ub/1e3) ' kV /___' num2str(angle(ui1todo(1))) ' rad'])
disp(['I1= ' num2str(abs(ui1todo(2))*Ib) ' A /___' num2str(angle(ui1todo(2))) ' rad'])%respuesta c)