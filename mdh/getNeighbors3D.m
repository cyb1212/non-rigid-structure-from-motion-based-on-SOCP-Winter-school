function [ IDX,D ] = getNeighbors3D(m1Mat,Ng,m2Mat)

if nargin<3
    m2Mat=m1Mat;
end


distmat = zeros(size(m1Mat,2),size(m2Mat,2),size(m1Mat,3));
for k =1:size(m1Mat,3)
    distmat(:,:,k) = pdist2(m1Mat(:,:,k)',m2Mat(:,:,k)','euclidean');
end

dist = max(distmat,[],3);
[D, IDX] = sort(dist,2);
IDX = IDX(:,1:Ng);
D=D(:,1:Ng);
end