function options=getDefaultOptions()

%% MDH-based non-rigid calibration parameters
% Thomas Probst, Danda Pani Paudel, Ajad Chhatkuli, and Luc Van Gool.: Incremental Non-Rigid Structure-from-Motion
% with Unknown Focal Length In: ECCV (2018)
mdh_calib.visu=1;                   %show iso error plot
mdh_calib.maxIter=15;               %max number of sweeping iterations
mdh_calib.sweep.f_init=0;           %is determined automatically if not set
mdh_calib.sweep.f_start=200;        %is determined automatically at run time
mdh_calib.sweep.f_step=50;          %is determined automatically at run time
mdh_calib.sweep.evalViewStep=1;     %evaluate isometry on every kth view
mdh_calib.sweep.evalPtsStep=10;     %evaluate isometry on every kth point
mdh_calib.useGeodesics=1;           %eval on geodesics instead of euklidean
mdh_calib.sweep.nSteps=5;           %max. steps away from current f to eval.


%% template-based mdh default parameters
% Chhatkuli, A., Pizarro, D., Collins, T., Bartoli, A.: Inextensible non-rigid shape-from-motion
% by second-order cone programming. In: CVPR. (2016)
options.template_mdh.errorMeasurement='direct';             %template-based rec. is already metric
options.template_mdh.calibration=mdh_calib;                 %calibration parameters
options.template_mdh.calibration.template=1;                %use template
options.template_mdh.calibration.useGeodesics=1;            %eval on geodesics instead of euklidean   
options.template_mdh.calibration.refineFullIntrinsics=1;    %enable refinement

%% tlmdh default parameters
% Chhatkuli, A., Pizarro, D., Collins, T., Bartoli, A.: Inextensible non-rigid shape-from-motion
% by second-order cone programming. In: CVPR. (2016)
options.tlmdh.Kneighbors=10;                    %number of nbs for NBHood graph 
options.tlmdh.nbGraph='max';                    %select max distance across views to construct nbhood graph
options.tlmdh.errorMeasurement='procrustes';    %align with gt to evaluate

%% tlmdh_incr default parameters
% Thomas Probst, Danda Pani Paudel, Ajad Chhatkuli, and Luc Van Gool.: Incremental Non-Rigid Structure-from-Motion
% with Unknown Focal Length In: ECCV (2018)
options.tlmdh_incr=options.tlmdh;
options.tlmdh_incr.incrSteps=2;             %n-step incremental reconstruction
options.tlmdh_incr.Nmin=50;                 %min 100 pts in the initial rec.
options.tlmdh_incr.calibration=mdh_calib;   %calibration params
options.tlmdh_incr.calibration.template=0;  %no template



%% Maximizing rigidity default parameters
% Ji, P., Li, H., Dai, Y., Reid, I.: ”Maximizing Rigidity” revisited: A convex programming
% approach for generic 3d shape reconstruction from multiple perspective views. In: ICCV. (2017)
options.maxrig.Kneighbors=10;
options.maxrig.lambda1 = 1;
options.maxrig.lambda2 = 20;
options.maxrig.errorMeasurement='procrustes';

%% DLH low rank fact. default parameters
%Dai, Y., Li, H., He, M.: A simple prior-free method for non-rigid structure-from-motion factorization. In: CVPR. (2012)
options.dlh.K= 9;
options.dlh.rotStruct = 1;
options.dlh.smooth = 1;
options.dlh.errorMeasurement='procrustes';

%% isom default parameters
% Parashar, S., Pizarro, D., Bartoli, A.: Isometric non-rigid shape-from-motion in linear time. In: CVPR. (2016)
options.isom.schwarzian=1e-3;
options.isom.errorMeasurement='procrustes';
