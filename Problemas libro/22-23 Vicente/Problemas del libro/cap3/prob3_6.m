%prob 3.6
clear
clc
S=60e6;%pot nom maq
U=69.3e3;%tension nom
X=15i;%reactancia por fase
%
Sb=S;
Ub=U;
Zb=Ub^2/Sb;
Ib=(Sb/3)/(Ub/sqrt(3));
%
u=U/Ub;
s=S/Sb;
z=X/Zb;
%
fp=0.8;%fp en retraso
s1=s*fp+s*fp*tan(acos(fp))*1i;
ig=conj(s1/u);
e=u+ig*z;
E=abs(e)*Ub/sqrt(3)%resultado en V por fase
delta=angle(e)%resultado en rad
%
e2=36e3*sqrt(3)/Ub;%entre líneas
pmax=abs(e2)*abs(u)/abs(z);
Pmax=pmax*Sb
%
P=48e6;
E3=46e3*sqrt(3);
p=P/Sb;
e3=E3/Ub;
delta3=asin(p*abs(z)/abs(e3)/abs(u));
i1=((e3*cos(delta3)+e3*sin(delta3)*1i)-u)/z;
fp=cos(angle(i1))
if imag(i1)>0
  disp(['cap'])
else
  disp(['ind'])
endif
I1=i1*Ib;
I=abs(I1)
