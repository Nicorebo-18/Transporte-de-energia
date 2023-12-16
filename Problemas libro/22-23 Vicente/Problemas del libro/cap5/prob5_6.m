%prob 5.6
A=0.93*(cos(1.5*pi/180)+1i*sin(1.5*pi/180));
B=115*(cos(77*pi/180)+1i*sin(77*pi/180));
U2=275e3;
%
P2=250e6;
fdp2=0.85;%ind
%
Sb=250e6;
Ub=275e3;
Zb=Ub^2/Sb;
Yb=1/Zb;
%
%A es adimensional
a=A;
%B tiene dimensiones de Ohm
b=B/Zb;
%
u2=U2/Ub;
p2=P2/Sb;
q2=p2*tan(acos(fdp2));
i2=conj((p2+q2*1i)/u2);
u1=a*u2+b*i2;
disp(['|U1|= ' num2str(abs(u1)*Ub/1e3) ' kV'])
%
theta=angle(b);
delta=theta;
z=b;
y_2=(a-1)/b;
u1=295e3/Ub;
p2max=abs(u1)*abs(u2)*cos(theta-delta)/abs(z)-(abs(u2))^2*cos(theta)/abs(z)-abs(y_2)*abs(u2)^2*cos(angle(y_2));
disp(['Potencia máxima transmisible= ' num2str(p2max*Sb/1e6) ' MW'])
%
scarga2=400e6/Sb;
fdpcarga2=0.8;%ind
p2=scarga2*fdpcarga2;
q2carga=sqrt(scarga2^2-p2^2);
q2=0;
i2=conj((p2+q2*1i)/u2);
%la tensión al final debe ser 275 kV y U1 tiene que salir 295 kV (1.07272)
tol=1e-5;
objetivo=295e3/Ub;
u1=a*u2+b*i2;
error_u=abs(u1)-objetivo;
while error_u>tol
    if error_u<0
        q2=q2+0.001;
    else
        q2=q2-0.001;
    end
    i2=conj((p2+q2*1i)/u2);
    u1=a*u2+b*i2;
error_u=abs(u1)-objetivo;
end
disp(['Q= ' num2str((q2-q2carga)*Sb/1e6) ' MVAr'])
