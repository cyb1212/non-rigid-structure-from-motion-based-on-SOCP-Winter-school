function [rec,err3d,rel_err3d,err_p] =evaluate(rec,eval_views,opts)

err3d=[];
rel_err3d=[];
err_p=[];
for k=eval_views
    x3d=rec(k).x3d;
    x3dgt=rec(k).x3d_gt;
    
    %eval on visible pts
    vp = x3dgt(3,:)>0;
    
    if strcmp(opts.errorMeasurement,'procrustes')
        [~,x3d_n,~] = absor(x3d(:,vp),x3dgt(:,vp),'doScale', true);
    elseif strcmp(opts.errorMeasurement,'scale')
        %only scale
        x3d_n = RegisterToGTH(x3d(:,vp),x3dgt(:,vp));
    else
       x3d_n=x3d(:,vp); 
    end
    
    scale = norm(x3dgt(:,vp),'fro');
    
    rec(k).rel_err_3d = norm(x3d_n - x3dgt(:,vp),'fro')/scale;
    rec(k).err_3d = sqrt(mean(sum((x3dgt(:,vp)-x3d_n).^2)));  
    
    rec(k).x3d_aligned=x3d_n;
    
    err3d=[err3d rec(k).err_3d];
    rel_err3d=[rel_err3d rec(k).rel_err_3d];
    
    scale = max(max(x3dgt')-min(x3dgt'));
    err_p = [err_p sqrt(mean((x3dgt(:,vp)-x3d_n).^2))/scale];

end


