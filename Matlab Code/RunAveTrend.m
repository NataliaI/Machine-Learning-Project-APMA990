%   Average Trend
%----------------------------------------------------------
% Makes predictions for 2013 using 2011 and 2012 data
% For each 2013 test point (D,M,2013)
%   The matching day and month are found in 2011 and 2012: 
%   (D,M,2011), (D,M,2012)
%   difference=(D,M,2012)-(D,M,2011)
%   Prediction for (D,M,2013)=(D,M,2012)+difference
%----------------------------------------------------------

clear; clc; close all;

load AveTrendData/TimeTrain
load AveTrendData/TimeTest
load AveTrendData/YTrain
load AveTrendData/YTest

num_train=size(TimeTrain,1);
num_test=size(TimeTest,1);

disp('Average Trend Prediction');
disp('-------------------------');

figure; 
for i=1:2  % for registered and casual
    Pred=zeros(size(YTest,1),1);
    for j=1:num_test
        testpt=TimeTest(j,:);
        % find matching days in training set
        ind=find(TimeTrain(:,1)==testpt(1) & TimeTrain(:,2)==testpt(2));
        ind=sort(ind);
        y1=YTrain((ind(1)),i);
        y2=YTrain((ind(2)),i);
        diff=y2-y1; % difference between 2011 and 2012
        Pred(j)=y2+diff;
    end
    if i==1
        disp('Testing Error for Registered Users');
    else 
        disp('Testing Error for Casual Users');
    end
    disp('Mean Squared Error (MSE):')
    err_mse=mean((Pred-YTest(:,i)).^2)
    disp('Mean Absolute ERROR (MAE):')
    err_mae=mean(abs(Pred-YTest(:,i)))
    subplot(2,1,i)
        plot([YTrain(:,i); Pred], 'r.','MarkerSize', 10);
        hold on 
        plot([YTrain(:,i); YTest(:,i)],'.', 'MarkerSize',10);
        xlabel('Day (1-1096)', 'FontSize', 12);
        ylabel('Number of Trips');
        legend('Predicted', 'Actual','Location', 'Best');
        if i==1
            title('Average Trend Prediction for Registered','FontSize',12);
        else
            title('Average Trend Prediction for Casual','FontSize',12);
        end
end

saveas(gcf, 'Output/AverageTrend.eps', 'epsc');