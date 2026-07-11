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

%%
IL=2400*[1 exp(-2*pi/3j) exp(2*pi/3j)]'


%%
xtotal=-30:0.1:30;

ytotal=[0,1,2,3,4];
for y=ytotal
    Btotal=[];
    for x=xtotal
        %(xi,yi) -> Posición del conductor
        % (x,y)  -> Posición del sensor de  campo

        FactorX=[(dist(1,2)-y)/((dist(1,1)-x)^2+(dist(1,2)-y)^2)...
            (dist(2,2)-y)/((dist(2,1)-x)^2+(dist(2,2)-y)^2)...
            (dist(3,2)-y)/((dist(3,1)-x)^2+(dist(3,2)-y)^2)];

        Bx=diag(FactorX)*IL;
        Bx_Added=sum(Bx);
        %%
        FactorY=[(x-dist(1,1))/((dist(1,1)-x)^2+(dist(1,2)-y)^2)...
                 (x-dist(2,1))/((dist(2,1)-x)^2+(dist(2,2)-y)^2)...
                 (x-dist(3,1))/((dist(3,1)-x)^2+(dist(3,2)-y)^2)];

        By=diag(FactorY)*IL;
        By_Added=sum(By);
        %%
        B=0.2*sqrt(abs(Bx_Added)^2+abs(By_Added)^2);
        Btotal=[Btotal B];
    end
    hold on
    plot(xtotal,Btotal)
end
xlabel('X [m]')
ylabel('Campo Magnetico B [uT]')
legend('y = 0 [m]','y = 1 [m]','y = 2 [m]','y = 3 [m]','y = 4 [m]')