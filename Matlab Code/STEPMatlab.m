% Subset Selection with Matlab's stepwisefit
%------------------------------------------------

[beta, se, pval, inmodel, stats, nextstep, history]=stepwisefit(XTrain, YTrain,'display','off');
train_err=(history.rmse).^2;

%plottng Mean Squared Error across all steps of the algorithm
figure;
semilogy(train_err,'-.','MarkerSize',10);
ylabel('MSE','FontSize',12);
xlabel('Steps','FontSize',12);
if Registered==1
    title('MSE vs. Steps for Registered Users');
    saveas(gcf,'Output\swMSER.eps','epsc')
else
    title('MSE vs. Steps for Casual Users');
    saveas(gcf,'Output\swMSEC.eps','epsc');
end

H=history.in; % shows which variables are included at which steps 

ncolors=3;
colors={'r.','b.', 'k.'};
num_steps=1:length(train_err);
num_predictors=size(XTrain,2);

%Plotting steps of algorithm
figure;
for i=1:num_predictors
    col=(num_steps').*H(:,i);
    j=mod(i,ncolors)+1;
    plot(i, col, colors{j},'MarkerSize', 20);
    hold on 
end
axis([0 num_predictors+1 1 length(num_steps)])
set(gca, 'XGrid', 'on')
set(gca,'XMinorGrid', 'on');
ylabel('step','FontSize',12);
xlabel('Input Variables','FontSize',12);
if Registered==1
    title('Steps of the Algorithm for Registered Users','FontSize',12);
    saveas(gcf,'Output\swStepsR.eps','epsc');
else
    title('Steps of the Algorithm for Casual Users','FontSize',12);
    saveas(gcf,'Output\swStepsC.eps','epsc');
end

% Final Test Error for full model
%-----------------------------------
b0=stats.intercept;
XTestOnes=[ones(size(XTest,1),1) XTest];

beta=beta.*inmodel';
beta=[b0;beta];
Pred=XTestOnes*beta;

test_err_mse=mean((Pred-YTest).^2);
test_err_mae=mean(abs(Pred-YTest));

disp('Final beta (including intercept)');
disp([beta]);

disp('Test Error (MSE):')
disp(test_err_mse);

disp('Test Error (MAE):')
disp(test_err_mae);

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
        saveas(gcf, 'Output\swPredTimeR.eps', 'epsc');
    else
        title('Predictions Plotted Over Time for Casual Users','FontSize',12);
        saveas(gcf, 'Output\swPredTimeC.eps', 'epsc');
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
    saveas(gcf, 'Output\swPredTimeSortR.eps', 'epsc');
else
     title('Predicted and Actual Values Srted According to Number of Trips for Casual')
    saveas(gcf, 'Output\swPredTimeSortC.eps', 'epsc');
end



