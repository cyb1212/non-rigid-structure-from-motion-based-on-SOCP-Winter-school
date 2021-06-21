function eval=evaluateSpecialObjectiveFn(x,mMat,mu,Dt,IDX,invNormMatrix)


fx=x(1);
fy=x(2);
cx=x(3);
cy=x(4);

Kest=[fx 0 cx;0 fy cy; 0 0 1];

KestN=inv(invNormMatrix)*Kest;
fxN=KestN(1,1);
fyN=KestN(2,2);
cxN=KestN(1,3);
cyN=KestN(2,3);

M=size(mMat,3);
N=size(mMat,2);
pts=reshape(mMat,3,M*N);
mus=reshape(mu',M*N,1)';


%% Reconstruction 1
x2dN=inv(Kest)*invNormMatrix*pts;
upgrade=mus./sqrt(sum(x2dN.^2,1));
x3d=[upgrade;upgrade;upgrade].*x2dN;
x3d=reshape(x3d,3,N,M);
x3d1=x3d;

xpts=1:2:size(IDX,1);
scaleT=sum(sum(Dt(xpts,:)));
Dt=Dt/scaleT;

Dr=Dt*0;
Egeo1=0;
views=1:2:M;
for k=views
for xi = xpts
    Xp = x3d(:,xi,k);
    for yi = 1:size(IDX,2)
        Yp = x3d(:,IDX(xi,yi),k);
        Dr(xi,yi)=norm(Xp-Yp);
    end
end
    scaleR=sum(sum(Dr(xpts,:)));
    Dr=Dr/scaleR;
    Egeo1=Egeo1+sum(sum((Dt-Dr).^2));
end
scale1=scaleR;




%% Reconstruction 2
Kest2=Kest;
alpha=0.75;
Kest2(1,1)=alpha*Kest2(1,1);
Kest2(2,2)=alpha*Kest2(2,2);

x2dN=inv(Kest2)*invNormMatrix*pts;
upgrade=mus./sqrt(sum(x2dN.^2,1));
x3d=[upgrade;upgrade;upgrade].*x2dN;
x3d=reshape(x3d,3,N,M);
x3d2=x3d;

Egeo2=0;
for k=views
for xi = xpts
    Xp = x3d(:,xi,k);
    for yi = 1:size(IDX,2)
        Yp = x3d(:,IDX(xi,yi),k);
        Dr(xi,yi)=norm(Xp-Yp);
    end
end
    scaleR=sum(sum(Dr(xpts,:)));
    Dr=Dr/scaleR;
    Egeo2=Egeo2+sum(sum((Dt-Dr).^2));
end
scale2=scaleR;

%%
    
% figure(2); clf;
% showPointCloud(x3d1(1:3,1:N)'/scale1,'b');     hold on;
% showPointCloud(x3d2(1:3,1:N)'/scale2,'g');     hold on;
% axis equal;

%%
weight=0.001/(1+1000*abs(Egeo1*numel(Dt)-Egeo2*numel(Dt)) );%exp(-(Egeo1*numel(Dt)-Egeo2*numel(Dt))^2*10*4*4);
E_tooHighF=weight*((alpha-fxN)^2 +(alpha-fyN)^2); %+ (1-weight)*((1-fxN)^2 +(1-fyN)^2);

%Ereg= (cxN^2+cyN^2+(fxN-fyN)^2); %(1-fxN)^2 +(1-fyN)^2+ 
Ereg= (cxN^2+cyN^2+(1-fxN/fyN)^2);
eval=Egeo1+Ereg;%+E_tooHighF;
%eval=sqrt(eval);
fprintf('Geo: %.6f \tweight: %.6f\t Ereg: %.3f \t [%.3f %.3f %.3f %.3f]\n ',Egeo1,weight,Ereg,fx,fy,cx,cy);




