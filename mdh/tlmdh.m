% Chhatkuli, A., Pizarro, D., Collins, T., Bartoli, A.: Inextensible non-rigid shape-from-motion
% by second-order cone programming. In: CVPR. (2016)
%
%
function data=tlmdh(data,opts)

%Normalize data
for k=1:length(data)
   x2d(:,:,k)=data(k).x2d; 
end
xl=sqrt(sum(x2d.^2,1));
for i=1:1:size(x2d,1)
    for j=1:1:size(x2d,2)
        x2d(i,j,:)=x2d(i,j,:)./xl(1,j,:);
    end
end

%Get parameters
Kneighbors = opts.Kneighbors; 
N=size(x2d,2);
M=size(x2d,3);


%Compute nbhood graph
IDX = getNeighborsMM(opts.nbGraph,x2d,Kneighbors);


%Solve SOCP
mu=zeros(M,N);
[mu,D] = NrSfM_cvx(IDX,x2d);

%% Fill return variable
for k=1:length(data)
    data(k).x3d=repmat(reshape(mu(k,:)',1,N),[3,1]).*x2d(:,:,k);
end