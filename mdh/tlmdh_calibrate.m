function calib=tlmdh_calibrate(dataset,opts)

data=dataset.data;
imSize=dataset.imageSize;
N=dataset.N;
M=dataset.M;


if opts.calibration.sweep.f_init>0
    f_init=opts.calibration.sweep.f_init;
else
    %Initial intrinsics: start with underestimated f
    f_init=mean(imSize)/2;
end

Kinit=[f_init   0       imSize(1)/2;
       0        f_init  imSize(2)/2;
       0        0       1];


if opts.calibration.visu
    figure(1);cla;
end

%Start iterative re-reconstruction and sweeping
Kf=Kinit;
lastIsoErr=1;
f_last=f_init;
f_list=[];
for it=1:opts.calibration.maxIter
    
    %Normalize data
    for k=1:length(data)
        data_n(k).x2d=inv(Kf)*data(k).x2d;   
        data_n(k).x2d=data_n(k).x2d./sqrt(sum(data_n(k).x2d.^2,1));
    end

    %Reconstruct using tlmdh_incr    
    rec=tlmdh_incr(data_n,opts);
    
    %look for best f
    [f_est, isoErr]=sweepFocalLength(rec,Kf,opts.calibration);
    
    %terminate?
    if f_est==f_last
        break
    end
    
    if isoErr>=lastIsoErr
        f_est=f_last;
        break
    end
    lastIsoErr=isoErr;
    
    %update intrinsics
    Kf = [f_est 0 Kinit(1,3); 0 f_est Kinit(2,3); 0 0 1];
        
    f_last=f_est;
    f_list=[f_list f_est];

end


% Converged?
if it<opts.calibration.maxIter
    calib.f=f_est;
    calib.K=Kf;
else
    fprintf('Calibration did not converge in %d iterations. Increase f_step and re-run.',opts.maxIter);
    calib.f=f_init;
    calib.K=Kinit;
end