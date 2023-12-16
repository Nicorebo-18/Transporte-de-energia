%prob 5.8
clc
clear
Z=5+25i;%Ohm
P2=15e6;
fdp2=0.8;%ind
U2=33e3;
%
Sb=15e6;
Ub=33e3;
Zb=Ub^2/Sb;
%
z=Z/Zb;
p2=P2/Sb;
u2=U2/Ub;
%
q2=p2*tan(acos(fdp2));
qc2=0;
s2eq=p2+(q2-qc2)*1i;
i2=conj(s2eq/u2);
%
u1=u2+i2*z;
error_u=abs(u1)-abs(u2);
tol=1e-4;
while abs(error_u)>tol
    if error_u<0
        qc2=qc2-0.001;
    else
        qc2=qc2+0.001;
    end
    u1=u2+conj((p2+(q2-qc2)*1i)/u2)*z;
    error_u=abs(u1)-abs(u2);
end
disp(['Q= ' num2str(-qc2*Sb/1e6) ' MVAr'])
%
qcond=qc2;
s2=20e6/Sb;
u2nueva=28e3/Ub;
i2=conj((s2*fdp2+((s2*sin(acos(fdp2))-qcond)*1i))/u2nueva);
u1=u2nueva+i2*z;
error_unueva=abs(u1)-33e3/Ub;
tol=1e-4;
while abs(error_unueva)>tol
    if error_unueva<0
        s2=s2+0.001;
    else
        s2=s2-0.001;
    end
i2=conj((s2*fdp2+((s2*sin(acos(fdp2))-qcond)*1i))/u2nueva);
    u1=u2nueva+i2*z;
error_unueva=abs(u1)-33e3/Ub;
end
disp(['Carga adicional= ' num2str((s2*fdp2-p2)*Sb/1e6) ' MW'])
