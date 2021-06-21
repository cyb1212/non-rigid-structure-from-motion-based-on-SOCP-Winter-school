function [ IDX ] = getNeighborsMM(method,m1Mat,Ng,m2Mat)

if nargin<4
    m2Mat=m1Mat;
end

distmat = zeros(size(m1Mat,2),size(m2Mat,2),size(m1Mat,3));
for k =1:size(m1Mat,3)
    distmat(:,:,k) = pdist2(m1Mat(:,:,k)',m2Mat(:,:,k)','cityblock');
end

if strcmp(method,'max')
    dist = max(distmat,[],3);
else
    dist = min(distmat,[],3);
end

[~, IDX] = sort(dist,2);
IDX = IDX(:,1:Ng);

end
