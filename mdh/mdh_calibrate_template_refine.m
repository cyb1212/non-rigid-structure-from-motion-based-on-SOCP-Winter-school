%% Energy-based refinement on full intrinsics
function K_ref=mdh_calibrate_template_refine(dataset,rec,Kinit)

N=dataset.N;
M=dataset.M;
template=dataset.template;

%define optimization    
options = optimoptions('fminunc');
options = optimoptions(options, 'OptimalityTolerance', 1e-3);%,'CheckGradients',true,'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true); 
options.Display = 'iter';
options.StepTolerance = 1e-10
options.MaxFunctionEvaluations = 3000;
%options.MaxIterations=20;
%options.GradObj= 'on';
options.FunctionTolerance=1e-10;
options.OptimalityTolerance=1e-10;



D=template.D;
IDX=template.IDX;


for k=1:M
    x2d(:,:,k)=rec(k).x2d;
    mu(k,:)=sqrt(sum((rec(k).x3d).^2,1));
end

x0=[Kinit(1,1) Kinit(2,2) Kinit(1,3) Kinit(2,3)]';


xopt = fminunc(@(x)(evalTemplateIsometryObjectiveFn(x,x2d,mu,D,IDX,Kinit)),x0,options)
K_ref = [xopt(1) 0 xopt(3);0 xopt(2) xopt(4); 0 0 1];
