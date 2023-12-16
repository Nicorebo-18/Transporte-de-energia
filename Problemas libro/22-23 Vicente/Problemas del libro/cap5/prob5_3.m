%prob 5.3c
clear
clc
Ub=220e3;
Sb=100e6;
Zb=Ub^2/Sb;
Yb=1/Zb;
Ib=Sb/Ub/sqrt(3);
f=50;%Hz
U1=220e3;%V (de lÃ­nea)
u1=U1/Ub;%pu
u20maxlong=235e3/Ub;
u20maxfrec=250e3/Ub;
%parÃ¡metros por unidad de longitud de la lÃ­nea y por fase
long0=400e3;%m
Ru=0.125e-3;%Ohm/m
Lu=0.4e-3/2/pi/50;%H/m
Cu=2.8e-9/2/pi/50;%F/m
%
Xu=2i*pi*f*Lu;%Ohm
Yu=2i*pi*f*Cu;%S
Zu=Ru+Xu;%Ohm/m
zu=Zu/Zb;%pu
yu=Yu/Yb;%pu
zc=sqrt(zu/yu);%pu
gamma=sqrt(zu*yu);%pu
u2=u1/cosh(gamma*long0);%tensiÃ³n extremo receptor en vacÃ­o en pu
disp(['Tensión al final de la línea en vacío= ' num2str(abs(u2)*Ub/1e3) ' kV'])
i1=sinh(gamma*long0)*u2/zc;%corriente por fase extremo emisor en vacÃ­o en A
disp(['Corriente al principio de la línea en vacío= ' num2str(abs(i1)*Ib) ' A'])
%
tol=1e-6;
long=long0;
error_long=abs(u2)-u20maxlong;
while abs(error_long)>tol
  if error_long>0
    long=long-1;
  else
    long=long+1;
  endif
u2=u1/cosh(gamma*long);
error_long=abs(u2)-u20maxlong;
endwhile
disp(['Longitud máx. para que U20<=235 kV: ' num2str(long/1e3) ' km'])
%
tol=1e-5;
error_f=abs(u2)-u20maxfrec;
while abs(error_f)>tol
  if error_f<0
    f=f+0.001;
  else
    f=f-0.001;
  endif
Xu=2i*pi*f*Lu;%Ohm
Yu=2i*pi*f*Cu;%S
Zu=Ru+Xu;%Ohm/m
zu=Zu/Zb;%pu
yu=Yu/Yb;%pu
zc=sqrt(zu/yu);%pu
gamma=sqrt(zu*yu);%pu
u2=u1/cosh(gamma*long0);
error_f=abs(u2)-u20maxfrec;
endwhile
disp(['Frecuencia máx. para que U20<=250 kV: ' num2str(f) ' Hz'])
