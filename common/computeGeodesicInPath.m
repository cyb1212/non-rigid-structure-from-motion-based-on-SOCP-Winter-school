function [ d ] = computeGeodesicInPath( Q, pAll, checkInd )
d = zeros(max(checkInd),length(pAll{1}));
for i = checkInd
    pathMulti = pAll{i};
    for j = 1:length(pathMulti)        
        r = pathMulti{j};
        d(i,j) = sum(sqrt(diff(Q(1,r)).^2 + diff(Q(2,r)).^2 +diff(Q(3,r)).^2));
    end
end
d = d(checkInd,:);
end

