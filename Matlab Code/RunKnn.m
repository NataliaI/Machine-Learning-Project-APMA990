% Running K-nearest neighbour
%------------------------------------------

clear; clc; close all;

load RandomData/XTrain
load RandomData/XTest
load RandomData/YTrainRC
load RandomData/YTestRC
load RandomData/YTime
load RandomData/Test

Ntrain=size(XTrain,1);
Ntest=size(XTest,1);

num_ind=1:7;  % indices of numerical variables
cat_ind=8:31; % indices of categorical variables

disp(' '); 
disp('Running K-nn');
disp('--------------');

for i=1:2 % for both registered and casual
    figure;
    if i==1
        disp('Results for Registered Users:');
        disp('------------------------------');
    else
        disp('Results for Casual Users'); 
        disp('--------------------------');
    end
    
    % Training Error
    I=form_dist_matrix(XTrain,XTrain, cat_ind, num_ind);
    knn_err_train=zeros(Ntrain,1);
    for k=1:Ntrain
        Pred=knn(YTrainRC(:,i),I,k);
        knn_err_train(k)=mean((Pred-YTrainRC(:,i)).^2);
    end
    % plotting training error
    a=semilogx(Ntrain*1./(1:Ntrain), knn_err_train,'.-', 'MarkerSize',10 );
    hold on
    
    disp('Min Training Error: ');
    disp(min(knn_err_train));
    
    % Testing Error
    I_test=form_dist_matrix(XTrain,XTest, cat_ind, num_ind);
    knn_err_test_mse=zeros(Ntrain,1); 
    knn_err_test_mae=zeros(Ntrain,1);
    Pred=zeros(k,Ntest);
    for k=1:Ntrain
        Pred(k,:)=knn(YTrainRC(:,i),I_test,k);
        knn_err_test_mse(k)=mean((Pred(k,:)'-YTestRC(:,i)).^2);
        knn_err_test_mae(k)=mean(abs(Pred(k,:)'-YTestRC(:,i)));
    end

    %plotting testing error
    b=semilogx(Ntrain*1./(1:Ntrain), knn_err_test_mse,'r.-', 'MarkerSize',10);
    xlabel('Degrees of Freedom: N/k', 'FontSize', 12);
    ylabel('Mean Squared Error (MSE)', 'FontSize', 12);
    legend([a,b], 'Training', 'Testing', 'Location', 'Best');
    if i==1
        title('Training and Testing Error with K-nn for Registered Users','FontSize',12);
        saveas(gcf,'Output\knnTrainTestR.eps', 'epsc');
    else
        title('Training and Testing Error with K-nn for Casual Users','FontSize',12);
        saveas(gcf,'Output\knnTrainTestC.eps', 'epsc');
    end
   
    [val, ind]=min(knn_err_test_mse);
    disp('Min Testing Error (MSE): ')
    disp(min(knn_err_test_mse));
    
    disp('Min Testing Error (MAE): ')
    disp(min(knn_err_test_mae));
    
    disp('Optimal k: ')
    disp(ind)
    
    % plotting prediction error over time
    figure;
    a=plot(YTime(:,i),'.', 'MarkerSize',10);
    hold on 
    b=plot(Test, Pred(ind,:),'r.','MarkerSize',10);
    xlabel('Day (1-1095)','FontSize',12);
    ylabel('Number of Trips','FontSize',12)
    legend([a,b], 'Actual', 'Predicted','Location', 'Best');
    if i==1
        title('Predictions Plotted Over Time for Registered Users','FontSize',12);
        saveas(gcf, 'Output\knnPredTimeR.eps', 'epsc');
    else
        title('Predictions Plotted Over Time for Casual Users','FontSize',12);
        saveas(gcf, 'Output\knnPredTimeC.eps', 'epsc');
    end
   

% Ploting actual and predicted values, sorting according to size
figure; 
[S,I]=sort(YTestRC(:,i));
plot(S,'.','MarkerSize', 10);
hold on 
Pred=Pred(ind,:);
plot(Pred(I), 'r.','MarkerSize',10);
ylabel('Number of Trips')
legend('Actual', 'Predicted','Location', 'Best');
if i==1
    title('Predicted and Actual Values Sorted According to Number of Trips for Registered')
    saveas(gcf, 'Output\knnPredTimeSortR.eps', 'epsc');
else
     title('Predicted and Actual Values Sorted According to Number of Trips for Casual')
    saveas(gcf, 'Output\knnPredTimeSortC.eps', 'epsc');
end
end

