%prob 5.9
U1=420e3;
long=463e3;
U02=700e3;
I1=646i;
%
Sb=100e6;
Ub=420e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
%
modulo_u1=U1/Ub;
u02=U02/Ub;
i1=I1/Ib;
%
betalong=acos(modulo_u1/u02);
beta=betalong/long;
disp(['Constante de propagación= ' num2str(beta*1e3) ' rad/km'])
rc=u02*1i*sin(beta*long)/i1;
disp(['Resistencia característica= ' num2str(rc*Zb) ' Ohm'])
%
u2=U1/Ub;
q=10e6/Sb;
i2=conj(1i*q/u2);
u1=cos(beta*long)*u2+1i*rc*sin(beta*long)*i2;
error_u=abs(u1)-u2;
tol=1e-4;
while abs(error_u)>tol
    if error_u<0
        q=q+0.001;
    else
        q=q-0.001;
    end
    i2=conj(1i*q/u2);
u1=cos(beta*long)*u2+1i*rc*sin(beta*long)*i2;
error_u=abs(u1)-u2;
end
disp(['Potencia reactiva a instalar= ' num2str(q*Sb/1e6) ' MVAr inductiva'])
disp(['Reactancia por fase a instalar= ' num2str((u2^2/q)*Zb) ' Ohm'])
