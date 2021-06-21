%% Sweep for focal length that introduces the least isometric inconsistency.
% Compares distances to template, if provided, otherwise across views.
function [f_est,minErr]=sweepFocalLength(rec,Kinit,opts,template);

if opts.template && nargin<4
    fprintf('No template provided.')
    return
end

f_start = max([opts.sweep.f_start Kinit(1)-opts.sweep.f_step]);
f_step  = opts.sweep.f_step;

M=length(rec);
N=length(rec(1).x2d);
for k=1:length(rec), x2d(:,:,k)=rec(k).x2d; end


tic
if opts.template
    IDX=template.IDX;
    Tscale=sum(sum(template.D,2));
    vertices=template.x3d/Tscale;
else
    IDX=getNeighborsMM('min',x2d,5);
    Tscale=1;
    vertices=rec(k).x3d;
end


%Precompute geodesic paths
if opts.useGeodesics
    k=1;
    [geomsh,mshDef] = createMesh(vertices);
    algDef = geodesic_new_algorithm(geomsh, 'dijkstra');

    %Compute path from xx% of pts to all other pts
    IDX_all=getNeighborsMM('min',x2d,N);
    checkInd = 1: opts.sweep.evalPtsStep: size(IDX_all,1);
    for xi = checkInd
        [d, pV] = computeAllGeodesicPath(algDef,mshDef,xi,IDX_all(xi,2:end));
        pathAll{xi} = pV;
    end
else
    IDX1=IDX;
end

%%
% sweep though f

iso_errors = [];
iGall = [];

for i = 1:opts.sweep.nSteps
    f = f_start+f_step*i;
    
    %candidate intrinsics
    Kf = [f 0 Kinit(1,3); 0 f Kinit(2,3); 0 0 1];
    
    %compute error in isometry across views
    kidx=1;
    for k=1:opts.sweep.evalViewStep:M
        
        %First compute distances on template if given
        computeTemplateDists= opts.template && (k==1);
        if computeTemplateDists
            Q2k=template.x3d/Tscale;
        else
            %Otherwise, upgrade reconstruction according to Kf
            mK = x2d(:,:,k);
            multi = sqrt(sum(mK.^2,1));
            mK = pinv(Kf)*Kinit*mK;
            mu=sqrt(sum((rec(k).x3d).^2,1));
            Q2k= repmat(multi.*mu,3,1).*(mK./sqrt(sum(mK.^2,1)));
            Q2k=Q2k/Tscale;
        end
                
        %compute distances
        clear iG;
        if opts.useGeodesics
            iG = computeGeodesicInPath(Q2k,pathAll,checkInd);
        else
%                iG = pdist2(Q2k',Q2k','euclidean');
                for xi = 1:1:size(IDX1,1)
                    Xp = Q2k(:,xi);
                    for yi = 1:size(IDX1,2)-1
                        Yp = Q2k(:,IDX1(xi,yi+1));
                        iG(xi,yi) = norm(Xp-Yp);
                    end
                end
        end
        
        if computeTemplateDists 
            %normalize template distances
            iG_template=iG(:)/sum(iG(:));
        elseif opts.template 
            %normalize reconstructed distances
            iGall(:,kidx) = iG(:)/sum(iG(:));
            kidx=kidx+1;
        else
            %Template-less: normalize all views jointly later on
            iGall(:,kidx) = iG(:);
            kidx=kidx+1;
        end
        
    end
    
    if opts.template
        %Compare isometry w.r.t. to template
        isoErr = sum(sum(pdist2(iG_template',iGall(:,1:end)','cityblock')));
    else
        %normalize distances to avoid small, flat reconstructions
        iGall = iGall/sum(sum(iGall));
        %Compare isometric consistency across views
        isoErr = sum(sum(pdist(iGall','cityblock')));
    end
    
    iso_errors(i)=isoErr;
    focal_lengths(i)=f;
end

%select focal length with least isometric error
[minErr, minStep] = min(iso_errors);
f_est = f_start+f_step*minStep;

if opts.visu
    figure(1);hold on;
    %clf;
    plot(focal_lengths(1:minStep),iso_errors(1:minStep),'-b');
    plot(focal_lengths(minStep:end),iso_errors(minStep:end),'--r');
    grid on
    xlabel('$K_f$');
    ylabel('$\Phi(K_f)$');
end

