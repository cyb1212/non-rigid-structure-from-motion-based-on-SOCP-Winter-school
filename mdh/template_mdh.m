% Chhatkuli, A., Pizarro, D., Collins, T., Bartoli, A.: Inextensible non-rigid shape-from-motion
% by second-order cone programming. In: CVPR. (2016)
%
%
function data=template_mdh(data,template)

%Normalize data
for k=1:length(data)
   x2d(:,:,k)=data(k).x2d; 
end
x2d=x2d./sqrt(sum(x2d.^2,1));


%Get parameters
N=size(x2d,2);
M=size(x2d,3);

%Get template
IDXt=template.IDX;
Dt=template.D;
Tscale=sum(sum(Dt,2));
Dt=Dt/Tscale;

%Solve SOCP
mu=zeros(M,N);
[mu] = NrSfM_template(IDXt,Dt,x2d);

%% Fill return variable
for k=1:length(data)
    data(k).x3d=Tscale*repmat(reshape(mu(k,:)',1,N),[3,1]).*x2d(:,:,k);
end