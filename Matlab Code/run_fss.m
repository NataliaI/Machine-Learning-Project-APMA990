function [test_err_mse,coef,test_err_mae,Pred]= run_fss(Xtrain,Ytrain,Xtest,Ytest,max_pred)
% run_fss performs forward stepwise selection given training and testing
% data (Xtrain, Ytrain, Xtest, Ytest) and the number of predictors desired
% in the model. 
% Output: test_err: minimum test error for the model given the number of variables
%         coef: coefficients for the model
% Taken from solutions for homework 2 
%--------------------------------------------------------------------------

    num_predictors= size(Xtrain,2)-1;
    % which variables are on
    variables_on=zeros(num_predictors+1,1);
    % constant is always on
    variables_on(1,1)=1;
    
    test_err_mse=zeros(1,max_pred);
    test_err_mae=zeros(1,max_pred);
       
    for k=1:max_pred
        % compute coefficients for given choice of variables
        [coef,train_err,residual]=do_lin_fit(Xtrain,Ytrain,variables_on);
        
        % get variables that are off
        off_variables=find(variables_on==0);
        Xoff=Xtrain(:,off_variables);
        
        % do QR of variables that are on
        [Q,R]=qr(Xtrain(:,find(variables_on)),0);
        
        % project residual onto orthogonal complement of Q
        Z=Xoff - Q*Q'*Xoff;
        % normalize columns of Z
        Z=normc(Z);
        % which has biggest dot-product with residual
        [temp,ind]=max(abs(Z'*residual));
        % turn on new variable
        variables_on(off_variables(ind))=1;
        
        Pred=Xtest*coef;
        % compute test error (MSE)
        test_err_mse(1,k)=mean((Ytest-Pred).^2);
        
        % compute test error (MAE- mean absolute error)
        test_err_mae(1,k)=mean(abs(Ytest-Pred));
    end
  
    