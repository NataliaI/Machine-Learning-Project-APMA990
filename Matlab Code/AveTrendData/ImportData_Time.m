% Importing Data - keeping in order according to time
%-------------------------------------------------------
% Processing data and creating testing and training set without randomizing
% over time
% Used for average trend analysis and descriptive plots 
%--------------------------------------------------------

% Data Headings:
%-----------------
% 1. ID 
% 2. MonthVal
% 3. DayVal
%-----------------------
% 4. NumRegistered
% 5. NumCasual
%-----------------------
% 6. Capacity
% 7. CityCapacity
% 8. OutskirtsCapacity
% 9. MeanTempC
% 10. MeanVisibilityKm
% 11. MeanWindSpeedKm_h
% 12. Precipmm
% 13. Holiday  
% 14. Workday
% 15. YearVal 
% 16. DayOfWeek 
% 17. Season 
% 18. CloudCover 
%-----------------------
% 13 Inputs, 2 Outputs

close all; clear; clc;
numInputs=13;
numOutputs=2;

load BikeDataWash.txt
TimeData=BikeDataWash(:,[2,3,15]);

% Inputs/Outputs
XData=BikeDataWash(:,6:end);
YData=BikeDataWash(:,4:5);
Nobs=size(XData,1); % number of observations

% Plotting Trip Data
%-------------------
figure; 
plot(1:Nobs, YData(:,1),'.-', 'MarkerSize', 10);
hold on 
plot(1:Nobs, YData(:,2), 'r.-', 'MarkerSize', 10);
for i=1:2
    plot(1:365, mean(YData(1:365,i)),'k-');
    plot(366:366+365, mean(YData(366:366+365,i)),'k-');
    plot(732:1096, mean(YData(732:1096,i)),'k-');
    hold on
end
title('Number of Bike Trips Made by Bike Share Users from 2011-2013','FontSize', 12)
xlabel('Day (1-1096)','FontSize', 12);
ylabel('Number of Trips', 'FontSize', 12);
legend('Registered', 'Casual','Yearly Mean','Location', 'Best'); 

saveas(gcf, 'Output/DataOverTime.eps','epsc');

% Display Trip Data Ranges
%---------------------

disp('Range of Trips Per Day')
disp('Min/Max Registered:');
disp([min(YData(:,1)) max(YData(:,1))]);
disp('Min/Max Casual');
disp([min(YData(:,2)) max(YData(:,2))]);

disp(' ');
disp('Averages Per Year')
disp('           Registered')
disp('      2011     2012     2013');
disp([mean(YData(1:365,1)) mean(YData(366:366+365,1)) mean(YData(732:1096,1))]);
disp('             Casual')
disp('      2011     2012     2013');
disp([mean(YData(1:365,2)) mean(YData(366:366+365,2)) mean(YData(732:1096,2))]);

% Make Training/ Testing Set
%-------------------------------
% 70/30 split

NTrain=round(0.7*Nobs);
Train=(1:NTrain);
Test=(NTrain+1:Nobs);

TimeTrain=TimeData(Train,:);
TimeTest=TimeData(Test,:);
YTrain=YData(Train,:);
YTest=YData(Test,:);

save TimeTrain
save TimeTest
save YTrain 
save YTest