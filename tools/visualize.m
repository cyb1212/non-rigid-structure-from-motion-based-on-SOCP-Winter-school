function visualize(result,views)

for k = views
                
    x3drec=result(k).x3d_aligned;
    x3dgt=result(k).x3d_gt;
    cla;
    plot3(x3drec(1,:),x3drec(2,:),x3drec(3,:),'bo');
    hold on;
    plot3(x3dgt(1,:),x3dgt(2,:),x3dgt(3,:),'go');
    
    axis equal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    view([0 0])
    pause(0.2);
    
end