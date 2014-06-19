
function [coef,train_error]=run_ridge_fit(X,Y,lambda)
% computing ridge regression model using built in function
% the 0 indicates that the coefficients are scaled back to the original
% data and the intercept is added
coef=ridge(Y,X,lambda,0);
X=[ones(size(X,1),1) X];
train_error=mean((Y-X*coef).^2);
