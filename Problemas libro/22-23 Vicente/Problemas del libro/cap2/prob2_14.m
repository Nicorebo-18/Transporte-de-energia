%problema 2.14 del libro
clc
clear
%
Sb=100e3;
Ub1=20e3;
XT=0.4i;%Ohm
Zb1=Ub1^2/Sb;
xT=XT/Zb1;%reactancia de cortocircuito según placa de características
t=0.9;%desvío de la relación de transformación
%
%El circuito equivalente de un transformador TRM en la pág. 55
%La toma de regulación está en el lado de AT (nudo 2)
yT=1/xT;
y02=yT*(1-t)/t^2%admitancia paralelo equivalente en el lado de AT
y21=yT/t%admitancia serie equivalente
y01=yT*(t-1)/t%admitancia paralelo equivalente en el lado de BT
