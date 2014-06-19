% Ridge Regression with Cross Validation
%------------------------------------------
% Based on code from solutions to homework 2

% set up values of lambda to use
lambda_vect=2.^(0:15);
lambda_vect=[0.1:0.1:0.9 lambda_vect];
num_lambda=length(lambda_vect);

% keep track of error on test data
store_test_error=zeros(num_folds,num_lambda);

for k=1:num_lambda
    for ell=1:num_folds
        % select CV training data
        Xtrain_CV=XTrain(find(foldAssignment~=ell),:);
        Ytrain_CV=YTrain(find(foldAssignment~=ell),:);
        
        % select CV test data
        Xtest_CV=XTrain(find(foldAssignment==ell),:);
        Ytest_CV=YTrain(find(foldAssignment==ell),:);
        
        % compute coefficients for given choice of variables
        [coef]=run_ridge_fit(Xtrain_CV,Ytrain_CV,lambda_vect(k));
        Xtest_CV=[ones(size(Xtest_CV,1),1) Xtest_CV];
        
        % compute error on test data
        store_test_error(ell,k)=(mean( (Ytest_CV-Xtest_CV*coef).^2 ));
    end   
end

% Plotting CV results and finding optimal lambda
%--------------------------------------------------
cv_error_mean=mean(store_test_error,1);
cv_error_std=std(store_test_error,1);
[min_cv_error,min_index]=min(cv_error_mean);
cutoff=min_cv_error+cv_error_std(min_index);

% best index of lambda
chosen_index=max(find(cv_error_mean<cutoff));
opt_lambda=lambda_vect(chosen_index);

figure;
errorbar((lambda_vect),cv_error_mean,cv_error_std)
set(gca, 'XScale', 'log');
hold on
xlabel('lambda','FontSize',12)
ylabel('CV Error','FontSize',12)
plot([min(lambda_vect) max(lambda_vect)], [cutoff cutoff],'r','LineWidth',1.5);
plot([opt_lambda,opt_lambda],[0.1 1e6],'r','LineWidth',1.5);

if Registered==1
    title('Ridge CV for Registered Users','FontSize',12)
    saveas(gcf, 'Output\ridgeCVR.eps', 'epsc');
else 
    title('Ridge CV for Casual Users','FontSize',12)
    saveas(gcf, 'Output\ridgeCVC.eps', 'epsc');
end

disp('optimal lambda: ')
disp(opt_lambda);

% FINAL RIDGE FIT
%---------------------
[coef,train_error_ridge]=run_ridge_fit(XTrain,YTrain,lambda_vect(chosen_index));

XTestOnes=[ones(size(XTest,1),1) XTest];
Pred=XTestOnes*coef;
test_err_ridge=(mean((YTest-Pred).^2));
test_err_ridge_abs=mean(abs(YTest-Pred));

disp('Final beta (including intercept)');
disp(coef);

disp('Test Error (MSE):')
disp(test_err_ridge);

disp('Test Error (MAE):')
disp(test_err_ridge_abs);

% Plotting Prediction Error Over Time
%----------------------------------------
 figure; 
 if Registered==1 i=1; else i=2; end
    a=plot(YTime(:,i),'.', 'MarkerSize',10);
    hold on 
    b=plot(Test, Pred,'r.','MarkerSize',10);
    xlabel('Day (1-1095)','FontSize',12);
    ylabel('Number of Trips','FontSize',12)
    legend([a,b], 'Actual', 'Predicted','Location', 'Best');
    if Registered==1
        title('Predictions Plotted Over Time for Registered Users','FontSize',12);
        saveas(gcf, 'Output\ridgePredTimeR.eps', 'epsc');
    else
        title('Predictions Plotted Over Time for Casual Users','FontSize',12);
        saveas(gcf, 'Output\ridgePredTimeC.eps', 'epsc');
    end

% Plotting Actual and Predicted Values, Sorting according to size
%-----------------------------------------------------------------
figure; 
[S,ind]=sort(YTest);
plot(S,'.','MarkerSize',10)
hold on 
plot(Pred(ind),'r.','MarkerSize',10)
ylabel('Number of Trips')
legend('Actual', 'Predicted','Location','Best');
if Registered==1
    title('Predicted and Actual Values Sorted According to Number of Trips for Registered')
    saveas(gcf, 'Output\ridgePredTimeSortR.eps', 'epsc');
else
     title('Predicted and Actual Values Srted According to Number of Trips for Casual')
    saveas(gcf, 'Output\ridgePredTimeSortC.eps', 'epsc');
end


