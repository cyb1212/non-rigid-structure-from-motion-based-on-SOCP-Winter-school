function [mu,D]=NrSfM_cvx(IDX,mMat)
N = size(mMat,2);
M = size(mMat,3);
L = size(IDX,2);
n=M*N;
m=(L-1)*N;
ka=ones(1,n);
cvx_begin
    variable z(n) nonnegative;% 
    variable d(m) nonnegative;%
    minimize(-sum(ka*z));
    subject to
%% Please add constaints here
cvx_end
mu = reshape(z,N,M)';
D  = reshape(d,N,L-1)';