%% Load Tshirt dataset
function dataset=prepare_tshirt(opts)

load data/tshirt_reduced4/tshirt_scale_corrected_reduced4.mat;
m = scene.m;
Pgth = scene.Pgth;
KK = scene.K;

%get parameters
sv=opts.sv;
sp=opts.sp;

%if calibration is known
if opts.normalizeK
    K=KK;
else
    K=eye(3);
end

sv = 1; sp = 1;% subsample views
Pgt = Pgth(sv:sv:end);
p = m(sv:sv:end);
for k = 1: length(p)
    kM = pinv(K)*[p(k).p(1:2,:); ones(1,length(p(k).p))]; % no K normalization
    data(k).x2d=kM(:,1:sp:end);
    data(k).x3d_gt=Pgt(k).P(:,1:sp:end);
end

dataset.data=data;
dataset.K=KK;
dataset.imageSize=[4928 3264];

N   = size(data(1).x2d,2); M = length(data);
dataset.N=N;
dataset.M=M;

%% Compute template
x3d_t=zeros(3,N,M);
% x3d_t=data(1).x3d_gt;
for k=1:M 
   x3d_t(:,:,k)= data(k).x3d_gt;
end
[IDX, D]=getNeighbors3D(x3d_t,15);
template.IDX=IDX;
template.D=D;
template.x3d=x3d_t(:,:,1);

dataset.template=template;