% Importing Data -random order 
%-------------------------------------------------------
% Processing data and creating testing and training set randomizing
% training and testing sets
% Used for KNN,regression and regression tree 
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
numCat=4; % number of categorical variables

load BikeDataMatlabWash.txt

% Removing outlier due to hurricane Sandy
ind=find(BikeDataMatlabWash(:,2)==10 & BikeDataMatlabWash(:,3)==29 & BikeDataMatlabWash(:,15)==2);
BikeDataMatlabWash(ind,:)=[];

% Inputs/Outpus
XData=BikeDataMatlabWash(:,7:end); %not including capacity as it is just a linear combination of city and outskirt capacity
YData=BikeDataMatlabWash(:,4:5);
YTime=YData; % YData ordered according to time
Nobs=size(XData,1);
XDataTree=XData;  % data for tree- does not need to recode categorical variable into dummy variables

%Adding Categorical Dummy Variables
Categorical=XData(:,end-3:end);
XData=XData(:,1:8);
for i=1:numCat
    Dummy=dummyvar(Categorical(:,i));
    XData=[XData Dummy];
end

% Splitting into Training and Testing
%--------------------------------------
% 70/30 split

% Run this once to randomize
% But kept the same afterwards to compare results 
%P=randperm(Nobs);
load RandPerm

NTrain=round(0.7*Nobs);
Train=P(1:NTrain);
Test=P(NTrain+1:end);

XTrain=XData(Train,:);
XTest=XData(Test,:);
YTrainRC=YData(Train,:);
YTestRC=YData(Test,:);
XTrainTree=XDataTree(Train,:);
XTestTree=XDataTree(Test,:);


save XTrain
save XTest
save YTrainRC 
save YTestRC
save YTime
save Test
save XTrainTree
save XTestTree