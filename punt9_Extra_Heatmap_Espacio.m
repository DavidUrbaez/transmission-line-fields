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
% V_LN=1/sqrt(3)*[
%     115*exp(+2*pi/3j) 115 115*exp(-2*pi/3j)...
%     115 115*exp(2*pi/3j) 115*exp(-2*pi/3j)...
%     230*exp(-2*pi/3j) 230 230*exp(+2*pi/3j)]'

V_LN=500/sqrt(3)*[1 exp(2*pi/3j) exp(-2*pi/3j)]'



Q_2pie0=inv(Lambda)*V_LN
%%
x = linspace(-30,30,1000);
y = linspace(0,25,1000);
[xtotal,ytotal] = meshgrid(x,y);
[imax,jmax]=size(meshgrid(x,y))

Etotal=[]
% y=1;
for j=1:jmax
    y=ytotal(j,1);
    
    for i=1:imax
        x=xtotal(1,i);
    

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
%         E_mag=sqrt(abs(Ex_Added)^2+abs(Ey_Added)^2)
        E(j,i)=sqrt(abs(Ex_Added)^2+abs(Ey_Added)^2);
    end
end
E(E>30)=30;
%% Plotting Settings
colormap('winter');
contourf(xtotal,ytotal,E,30*(1-log((1:0.1:10))))
a=colorbar;
a.Label.String = 'E [{kV_{rms}}/_{m}]';
xlabel('X [m]')
ylabel('Y [m]')