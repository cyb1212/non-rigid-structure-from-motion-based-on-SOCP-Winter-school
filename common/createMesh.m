function [ geomsh, mshDef ] = createMesh( Pdef )
% create Meshes to compute geodesics later.
% Use dense points

% rotate points and then do 2d meshing
Pd = Pdef';

% M=[Pt'-mean(Pt)'*ones(1,size(Pt,1))];
% [~,~,V]=svd(M*M');
% Pt=(V'*M)';
% 

M=[Pd'-mean(Pd)'*ones(1,size(Pd,1))];
[~,~,V]=svd(M*M');
Pd=(V'*M)';
% 
deltriDef = delaunay(Pd(:,1), Pd(:,2));
% 
% 
% 
% [Pdc,tri]=meshcheckrepair(Pd,deltriDef,'dup');
% % [vertex, faces] = perform_mesh_simplification(Pd,deltriDef);


mshDef.vertexPos = Pd;
mshDef.faces = deltriDef;
geomsh = geodesic_new_mesh(Pd, deltriDef);         %initilize new mesh

end

