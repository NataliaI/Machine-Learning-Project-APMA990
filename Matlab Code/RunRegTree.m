% Making Regression Trees
%---------------------------

clear; clc; close all;

load RandomData/XTrainTree
load RandomData/XTestTree
load RandomData/YTrainRC
load RandomData/YTestRC

disp('Regression Tree Results')
disp('------------------------');
for i=1:2
    if i==1
        disp('Registered Users: ')
    else 
        disp('Casual Users: ');
    end
    
    YTrain=YTrainRC(:,i);
    YTest=YTestRC(:,i);
    
    %making full regression tree on training data
    t=classregtree(XTrainTree,YTrain, 'names', {'CCap', 'OCap', 'Temp', 'Vis', 'Wind', 'Rain', 'Hol', 'Work', 'Year', 'Day', 'Seas','Cloud'},'categorical', [7:12],'splitmin',5);

    %applying cross validation to tree to find the optimal pruning level
    [c,s,n,best]=test(t, 'cross', XTrainTree, YTrain);
    tmin=prune(t, 'level',best);
    view(tmin);
    % trees saved separately because they don't have figure handles

    % plotting cross validation results
    figure;
    [mincost, minloc]=min(c);
    plot(n,c,'b-o', n(best+1), c(best+1), 'rs', n, (mincost+s(minloc))*ones(size(n)), 'r--','LineWidth',1.4,'MarkerSize',4);
    xlabel('Tree size (number of terminal nodes)');
    ylabel('Cost(MSE)')
    if i==1
        title('Cross Validation for Registered Users');
        saveas(gcf,'Output/TreeCVR.eps','epsc');
    else
        title('Cross Validation for Casual Users');
        saveas(gcf,'Output/TreeCVC.eps','epsc');
    end

    % applying tree to test data
    cost=test(tmin, 'test', XTestTree,YTest);
    
    disp('Test Error MSE:')
    disp(mean(cost));
end