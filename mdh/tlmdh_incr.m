% Thomas Probst, Danda Pani Paudel, Ajad Chhatkuli, and Luc Van Gool.: Incremental Non-Rigid Structure-from-Motion
% with Unknown Focal Length In: ECCV (2018)
%
% x2d: 3xNxM matrix of normalized N homogene 2d points in M views
%
function data=tlmdh_incr(data,opts)

%Normalize data
for k=1:length(data)
   x2d(:,:,k)=data(k).x2d; 
end
x2d=x2d./sqrt(sum(x2d.^2,1));

%Get parameters
Kneighbors = opts.Kneighbors; 
samplePts=opts.incrSteps;
Nmin=opts.Nmin;
N=size(x2d,2);
M=size(x2d,3);



if samplePts>1
    Nstart=max([Nmin,floor(N/samplePts)]);
    x2d_1 = x2d(:,1:Nstart,:);
else
    x2d_1 = x2d;
end

%% First level reconstruction
%Compute nbhood graph
IDX1 = getNeighborsMM(opts.nbGraph,x2d_1,Kneighbors);


tic;
mu=zeros(M,N);
[mu1,D1] = NrSfM_c2f(IDX1,x2d_1);
if samplePts>1
    mu(:,1:Nstart) = mu1;
else
    mu = mu1;
end
toc
%% Second level reconstruction
if samplePts>1 && N>Nstart
    for iter = 2:samplePts+1
        x2d_2    = x2d(:,(Nstart+iter-1):samplePts:end,:);
        
        IDX2 = getNeighborsMM(opts.nbGraph,x2d_2,Kneighbors,x2d_1);
        
        [mu2,D2] = NrSfM_addPoints(IDX2,x2d_2,x2d_1,mu1,D1);
        mu(:,(Nstart+iter-1):samplePts:end) = mu2;
        fprintf('%d of %d iterations\n',iter,samplePts);
    end
end
ts = toc

%% Fill return variable
for k=1:length(data)
    data(k).x3d=repmat(reshape(mu(k,:)',1,N),[3,1]).*x2d(:,:,k);
end
