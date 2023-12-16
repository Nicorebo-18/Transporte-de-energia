%prob 2.10 del libro
Sb=100e6;
Ub=400e3;
S2=(15.93-33.4i)*1e6;
S3=77e6+14e6i;
s2=S2/Sb;
s3=S3/Sb;
U3=400e3;
u3=U3/Ub;
x23=0.4i;
x12=0.5i;
i23=conj(s3/u3);
u2=u3+i23*x23;
i2=conj(s2/u2);
i12=i2+i23;
u1=u2+i12*x12;
U1=abs(u1)*Ub
U2=abs(u2)*Ub