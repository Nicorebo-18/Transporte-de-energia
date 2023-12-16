%prob 2.12 y 2.13 del libro
Sb=100e6;
UbL=500e3;
ZbL=UbL^2/Sb;
UbG1=20e3;
UbG2=20e3;
UbM=20e3;
XL1=40i;
XL2=25i;
XL3=XL2;
xl1=XL1/ZbL;
xl2=XL2/ZbL;
xl3=XL3/ZbL;
SG1=750e6;
UG1=18e3;
xG1=0.2i;
SG2=SG1;
UG2=UG1;
xG2=xG1;
ST1234=750e6;
xT1234=0.1i;
ST5=1500e6;
xT5=0.1i;
SM=1500e6;
UM=20e3;
xM=0.2i;
%
xg1=xG1*(Sb/SG1)*(UG1/UbG1)^2;
xg2=xG2*(Sb/SG2)*(UG2/UbG2)^2;
xt1234=xT1234*(Sb/ST1234)*(500e3/UbL)^2;
xt5=xT5*(Sb/ST5)*(500e3/UbL)^2;
xm=xM*(Sb/SM)*(UM/UbM)^2;
%
umf=18e3/UbM;
pmf=1200e6/Sb;
fdp=0.8;%cap
imf=conj((pmf-1i*pmf*tan(acos(fdp)))/umf);
%
i1=imf/2;%corriente en cualquiera de las líneas inferiores
%por simetría teniendo en cuenta que ambos generadores suministran la misma potencia compleja
umedio=umf+imf*xt5;%tensión en el nudo que conecta T5 a las líneas
u1=umedio+i1*(xt1234+xl2);%tensión en el nudo 1
disp(['Tensión en el nudo 1= ' num2str(abs(u1)*UbG1/1e3) '/___' num2str(angle(u1)) ' kV'])
u2=umedio+i1*(xt1234+xl3);%tensión en el nudo 2
disp(['Tensión en el nudo 2= ' num2str(abs(u2)*UbG2/1e3) '/___' num2str(angle(u2)) ' kV'])
