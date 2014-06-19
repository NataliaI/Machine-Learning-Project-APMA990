% Forward Stepwise Selection with Cross Validation
%---------------------------------------------------
% Based on code from solutions to homework 2

% storing test errors on training data
store_test_error=zeros(num_folds,num_predictors+1);

XTrainOnes=[ones(num_train,1) XTrain];
XTestOnes=[ones(num_test,1) XTest];

% for each fold
for ell=1:num_folds

    % select CV training data
    Xtrain_CV=XTrainOnes(find(foldAssignment~=ell),:);
    Ytrain_CV=YTrain(find(foldAssignment~=ell),:);
    
    % select CV test data
    Xtest_CV=XTrainOnes(find(foldAssignment==ell),:);
    Ytest_CV=YTrain(find(foldAssignment==ell),:);
    
    % perform stepwise selection
    [test_err]=run_fss(Xtrain_CV,Ytrain_CV,Xtest_CV,Ytest_CV,num_predictors+1);
    
    store_test_error(ell,:)=test_err;
end  

cv_error_mean=mean(store_test_error,1);
cv_error_std=std(store_test_error,1);

% plotting cross validation curve
figure;
errorbar(0:num_predictors,cv_error_mean,cv_error_std)
hold on
xlabel('Degrees of Freedom','FontSize',12)
ylabel('CV Error','FontSize', 12)

[min_cv_error,min_index]=min(cv_error_mean);
cutoff=min_cv_error+cv_error_std(min_index);
plot([0 num_predictors], [cutoff cutoff],'r','LineWidth',1.5);
hold on 
chosen_index=min(find(cv_error_mean<cutoff));

% optimal number of included variables 
opt_dof=chosen_index-1;
disp('Optimal degrees of freedom (number of variables included in the model):')
disp(opt_dof);
plot([opt_dof opt_dof],[min_cv_error max(cv_error_mean)],'r','LineWidth',1.5);

if Registered==1
    title('Forward Stepwise Selection CV for Registered Users','FontSize',12)
    saveas(gcf, 'Output/fssCVR.eps', 'epsc');
else 
    title('Forward Stepwise Selection CV for Casual Users','FontSize',12)
    saveas(gcf, 'Output/fssCVC.eps', 'epsc');
end
    


% Final test error for full model
%-----------------------------------------
[test_error_mse,beta_fss,test_err_mae,Pred]=run_fss(XTrainOnes,YTrain,XTestOnes,YTest,opt_dof+1);  

disp('Final beta (including intercept)')
disp(beta_fss);

disp('Test Error (MSE):')
disp(test_error_mse(1,end));

disp('Test Error (MAE):')
disp(test_err_mae(1,end));

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
        saveas(gcf, 'Output\fssPredTimeR.eps', 'epsc');
    else
        title('Predictions Plotted Over Time for Casual Users','FontSize',12);
        saveas(gcf, 'Output\fssPredTimeC.eps', 'epsc');
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
    saveas(gcf, 'Output\fssPredTimeSortR.eps', 'epsc');
else
     title('Predicted and Actual Values Srted According to Number of Trips for Casual')
    saveas(gcf, 'Output\fssPredTimeSortC.eps', 'epsc');
end
    

