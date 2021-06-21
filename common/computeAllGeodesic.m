function [ d1 ] = computeAllGeodesic( algDef,mshDef, indi, indj )
% geodesics in meshes
% use library exact geodesic: Danil Kirsanov, 09/2007
vertices = mshDef.vertexPos;
source_points = {geodesic_create_surface_point('vertex', indi, vertices(indi,:))};

geodesic_propagate(algDef, source_points);   %propagation stage of the algorithm (the most time-consuming)
                             %create a single destination at vertex #N
d1 = zeros(size(indj));                             
                             
for k = 1:length(indj) 
% [indj]
destination = geodesic_create_surface_point('vertex', indj(k), vertices(indj(k), :));
path = geodesic_trace_back(algDef, destination);     %find a shortest path from source to destination
[x,y,z] = extract_coordinates_from_path(path);
% figure(2)
% hold on;
% plot3(x,y,z,'r','LineWidth',2);    %plot a sinlge path for this algorithm
% hold off;
d1(k) = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));      %length of the path
% 
% figure(3)
% clf;
% plot3(mshDef.vertexPos(:,1),mshDef.vertexPos(:,2),mshDef.vertexPos(:,3),'b.');
% hold on;
% plot3(x,y,z,'go');
% axis equal;
% hold off;

% geodesic_delete;
end
end

