clc
clear all

A=(sqrt(2)/2)*46/100
r=25.146/2000
Req=(4*r*A^(3))^(1/4)
%%
H=9
dist=[-12.5,H,Req; ...
      0,H,Req; ... 
      12.5,H,Req]
 
[n,~]=size(dist)
Lambda=FindLambda(dist)
%%
V_LN=500/sqrt(3)*[1 exp(2*pi/3j) exp(-2*pi/3j)]'

Q_2pie0=inv(Lambda)*V_LN;
%%
xtotal=-30:0.1:30;
Etotal=[]
y=1;
for x=xtotal
% x=0;
    

    FactorX=[];
    for Linea=1:n
        FactorX=[FactorX...
            (x-dist(Linea,1))/((x-dist(Linea,1))^2+(y-dist(Linea,2))^2) - (x-dist(Linea,1))/((x-dist(Linea,1))^2+(y+dist(Linea,2))^2)];
    end
    FactorX=diag(FactorX);
    Ex=FactorX*Q_2pie0;

    Ex_Added=sum(Ex);
    %%
    FactorY=[];

    for Linea=1:n
    FactorY=[FactorY ...
        (y-dist(Linea,2))/((x-dist(Linea,1))^2+(y-dist(Linea,2))^2) - (y+dist(Linea,2))/((x-dist(Linea,1))^2+(y+dist(Linea,2))^2)];
    end
    FactorY=diag(FactorY);
    Ey=FactorY*Q_2pie0;

    Ey_Added=sum(Ey);
    %%
    E=sqrt(abs(Ex_Added)^2+abs(Ey_Added)^2);
    Etotal=[Etotal E];
end
plot(xtotal,Etotal)
xlabel('X [m]')
ylabel('Campo ELéctrico E [kV/m]')
title('Campo Eléctrico a 1 m de altura ( Linea 500kV ) ')