function [ d1, pV ] = computeAllGeodesicPath( algDef,mshDef, indi, indj )
% geodesics in meshes
% use library exact geodesic: Danil Kirsanov, 09/2007
vertices = mshDef.vertexPos;
source_points = {geodesic_create_surface_point('vertex', indi, vertices(indi,:))};

geodesic_propagate(algDef, source_points);   %propagation stage of the algorithm (the most time-consuming)
%create a single destination at vertex #N
d1 = zeros(size(indj));
pV = cell(1,length(indj));
for k = 1:length(indj)
    destination = geodesic_create_surface_point('vertex', indj(k), vertices(indj(k), :));
    path = geodesic_trace_back(algDef, destination);     %find a shortest path from source to destination
    [x,y,z] = extract_coordinates_from_path(path);
    
    vertpath = [x,y,z];
    dist = pdist2(vertpath,vertices);    
    
    [r,c] = find(dist'==0);
    
    pV{k} = r;
    
    % figure(2)
    % hold on;
    % plot3(x,y,z,'r','LineWidth',2);    %plot a sinlge path for this algorithm
    % hold off;
    d1(k) = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));            %length of the path
    
%     d2(k) = sum(sqrt(diff(vertices(r,1)).^2 + diff(vertices(r,2)).^2 +diff(vertices(r,3)).^2));
    
    % geodesic_delete;
end
end

