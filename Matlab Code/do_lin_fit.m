
function [coef,std_error_out,residual]=do_lin_fit(X,Y,predictors_on)
% finds the coefficients, coef, of the linear model corresponding to input
% X, output Y, and given predictors, predictors_on
% Outputs: coefficients coef, the standard error and residual
% From solutions for homework 2
%--------------------------------------------------------------------------

N=size(X,1);
p=size(X,2)-1;

inds_on=find(predictors_on);

X=X(:,inds_on);

betahat=X\Y;

coef=zeros(p+1,1);  
coef(inds_on)=betahat;

residual=Y-X*betahat;
std_error_out=mean(residual.^2);


