%Ejercicio 1 apartados b y c Iván Chamorro
clc
clear
global u1 d1 p2 q2 u3 p3 y g

%Nudo1
u1=1.04;
d1=0;
pd1=2;
qd1=1;

%Nudo 2
pd2=0;
qd2=0;
pg2=0.5;
qg2=1;
p2=pg2-pd2;
q2=qg2-qd2;

%Nudo3
u3=1.04;
pd3=1.2*1.5;
qd3=1.2*0.6;
pg3=0;
p3=pg3-pd3;

%Línea
z=0.02+0.08i;
y_2=0.02i;

y12=1/z;
y012=y_2;
y13=1/z;
y013=y_2;
y23=1/z;
y023=y_2;

Ybus=[y12+y012+y13+y013 -y12 -y13;
      -y12 y12+y012+y23+y023 -y23;
      -y13 -y23 y13+y013+y23+y023];
y=abs(Ybus);
g=angle(Ybus);

x0=[1 1 1 0 1 0]; %x0=[p1 q1 u2 d2 q3 d3]
x=fsolve(@Ej1b_ec,x0);

u=[u1 x(3) u3]; %módulos de las tensiones
d=[d1 x(4) x(6)]; %argumentos de las tensiones
p=[x(1) p2 p3]; %potencias activas inyectadas
q=[x(2) q2 x(5)]; %potencias reactivas inyectadas
 
U=u.*cos(d)+1i*u.*sin(d);
display([' '])

i12=y12*(U(1)-U(2))+y012*U(1);
i21=y12*(U(2)-U(1))+y012*U(2);
s12=U(1)*conj(i12);
s21=U(2)*conj(i21);
perd12=s12+s21;

i13=y13*(U(1)-U(3))+y013*U(1);
i31=y13*(U(3)-U(1))+y013*U(3);
s13=U(1)*conj(i13);
s31=U(3)*conj(i31);
perd13=s13+s31;

i23=y23*(U(2)-U(3))+y023*U(2);
i32=y23*(U(3)-U(2))+y023*U(3);
s23=U(2)*conj(i23);
s32=U(3)*conj(i32);
perd23=s23+s32;

display(['Flujo línea12 = ',num2str(abs((s12))),' p.u'])
display(['Flujo línea13 = ',num2str(abs((s13))),' p.u'])
display(['Flujo línea23 = ',num2str(abs((s23))),' p.u'])

display(['Sobrecarga línea13 = ',num2str((abs(s13)-1)/1*100),' %'])

display(['Potencia generador1 = ',num2str(abs((p(1)+pd1+q(1)*i+qd1*i))),' p.u'])
display(['Potencia generador2 = ',num2str(abs((p(2)+pd2+q(2)*i+qd2*i))),' p.u'])
display(['Potencia generador3 = ',num2str(abs((pg3+q(3)*i+qd3*i))),' p.u'])

display(' ')
display('Se plantea añadir una línea en paralelo a la línea13 de manera ') 
display('que entre 1 y 3 haya dos líneas idénticas paralelas')

Ybus2=[y12+y012+2*y13+2*y013 -y12 -2*y13;
      -y12 y12+y012+y23+y023 -y23;
      -2*y13 -y23 2*y13+2*y013+y23+y023];
y=abs(Ybus2);
g=angle(Ybus2); 

x0=[1 1 1 0 1 0]; %x0=[p1 q1 u2 d2 q3 d3]
x=fsolve(@Ej1b_ec,x0);

u=[u1 x(3) u3]; %módulos de las tensiones
d=[d1 x(4) x(6)]; %argumentos de las tensiones
p=[x(1) p2 p3]; %potencias activas inyectadas
q=[x(2) q2 x(5)]; %potencias reactivas inyectadas

U=u.*cos(d)+1i*u.*sin(d);

i13a=y13*(U(1)-U(3))+y013*U(1);
i31a=y13*(U(3)-U(1))+y013*U(3);
s13a=U(1)*conj(i13a);
s31a=U(3)*conj(i31a);

i13b=y13*(U(1)-U(3))+y013*U(1);
i31b=y13*(U(3)-U(1))+y013*U(3);
s13b=U(1)*conj(i13b);
s31b=U(3)*conj(i31b);

display(['Flujo línea12 = ',num2str(abs((s12))),' p.u'])
display(['Flujo línea13a = ',num2str(abs((s13a))),' p.u'])
display(['Flujo línea13b = ',num2str(abs((s13b))),' p.u'])
display(['Flujo línea23 = ',num2str(abs((s23))),' p.u'])

display(['Potencia generador1 = ',num2str(abs((p(1)+pd1+q(1)*i+qd1*i))),' p.u'])
display(['Potencia generador2 = ',num2str(abs((p(2)+pd2+q(2)*i+qd2*i))),' p.u'])
display(['Potencia generador3 = ',num2str(abs((pg3+q(3)*i+qd3*i))),' p.u'])