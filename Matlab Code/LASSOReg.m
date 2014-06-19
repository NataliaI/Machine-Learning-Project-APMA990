% Lasso Regression with Cross Validation
%------------------------------------------
% Using build in function lasso

[beta FitInfo]=lasso(XTrain, YTrain, 'CV', 10);

% Plotting CV Curve
lassoPlot(beta,FitInfo, 'PlotType', 'CV');
hold on
if Registered==1
    gcf; title('Lasso CV Curve for Registered Users','FontSize',12);
    saveas(gcf,'Output\lassoCVR.eps','epsc');
else
   gcf; title('Lasso CV Curve for Casual Users','FontSize',12);
   saveas(gcf,'Output\lassoCVC.eps','epsc');
end

% Plotting Profiles of Lasso Coefficients 
lassoPlot(beta,FitInfo, 'PlotType', 'Lambda', 'XScale', 'log');
% Profile plots samed from plot window because function handles don't work

% coefficients corresponding to optimal lambda
lambda=FitInfo.Index1SE;
beta=beta(:,lambda);
b0=FitInfo.Intercept;
b0=b0(lambda);
disp('Optimal Lambda:')
disp(lambda);

% Final test error for full model
%---------------------------------
[beta, FitInfo]=lasso(XTrain, YTrain, 'Lambda', lambda);
XTestOnes=[ones(num_test,1) XTest];
b0=FitInfo.Intercept;
Pred=XTestOnes*[b0;beta];

test_err_lasso_mse=mean((Pred-YTest).^2);
test_err_lasso_mae=mean(abs(Pred-YTest));

disp('Final beta (including intercept');
disp([b0;beta]);

disp('Test Error (MSE):')
disp(test_err_lasso_mse);

disp('Test Error (MAE):')
disp(test_err_lasso_mae);

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
        saveas(gcf, 'Output\lassoPredTimeR.eps', 'epsc');
    else
        title('Predictions Plotted Over Time for Casual Users','FontSize',12);
        saveas(gcf, 'Output\lassoPredTimeC.eps', 'epsc');
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
    saveas(gcf, 'Output\lassoPredTimeSortR.eps', 'epsc');
else
     title('Predicted and Actual Values Srted According to Number of Trips for Casual')
    saveas(gcf, 'Output\lassoPredTimeSortC.eps', 'epsc');
end


