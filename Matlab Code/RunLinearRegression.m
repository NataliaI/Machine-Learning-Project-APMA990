% LINEAR REGRESSION
%--------------------------------------------------------------------
% Performing several types of linear regression on bike-sharing data
% including:
% - Ordinary Least Squares Regression (OLS)
% - Forward Stepwise Selection
% - Ridge Regression
% - Lasso
% - Subset Selection using built in Matlab function stepwise fit
%       - based on F-statistic 
% All methods besides OLS and stepwisefit are applied with CV to determine
% optimal parameters
% File can be run all at once, or cell by cell for each method.
%-------------------------------------------------------------------------
%%
clear; clc; close all;

% turning off warning about rank-deficient matrices 
% both OLS and FSS have problems with this when XTrain or XTest contain
% highly correlated variables 
% FSS is able to resolve this with the final model but with intermediate
% models it will show warnings
warning('off', 'MATLAB:rankDeficientMatrix');

%     Reading Data
%----------------------
load RandomData/XTrain
load RandomData/XTest
load RandomData/YTrainRC
load RandomData/YTestRC
load RandomData/YTime
load RandomData/Test

num_train=size(XTrain,1);
num_test=size(XTest,1);
num_predictors=size(XTrain,2);

% Standardizing With Respect to Training Data
%-----------------------------------------------
Xmean=mean(XTrain);
Xstd=std(XTrain);

XTrain=(XTrain-repmat(Xmean,num_train,1))./repmat(Xstd,num_train,1);
XTest=(XTest-repmat(Xmean,num_test,1))./repmat(Xstd,num_test,1);

% Folds for Cross Validaton
%-----------------------------
num_folds=10;
foldAssignment=ceil(num_folds*rand(num_train,1));

%% Correlation Matrix for Input Data
%---------------------------------------
CorrMat=corrcoef(XTrain);

%% Ordinary Least Squares Regression
%--------------------------------------------------------------------------
XTrainOnes=[ones(num_train,1) XTrain];
XTestOnes=[ones(num_test,1) XTest];

beta_OLS=XTrainOnes\YTrainRC;
Yhattrain=XTrainOnes*beta_OLS;
train_error_OLS=mean((Yhattrain-YTrainRC).^2);
Yhattest=XTestOnes*beta_OLS;

test_error_mse=mean((YTestRC-Yhattest).^2);
test_error_mae=mean(abs(YTestRC-Yhattest));

disp(' ');
disp('Ordinary Least Squares Regression');
disp('----------------------------------');
disp(' ')
disp('Test Error: Mean Squared Error (MSE)')
disp('Registered    Casual');
disp(test_error_mse)
disp('Test Error: Mean Absolute Error (MAE)')
disp('Registered   Casual');
disp(test_error_mae)

%% FSS
%--------------------------------------------------------------------------
disp(' ');
disp('Forward Stepwise Selection');
disp('-----------------------------');

% For Registered Users:
Registered=1;
YTrain=YTrainRC(:,1);
YTest=YTestRC(:,1);

disp('Results for Predicting Registered Users:')
FSS

% For Casual Users:
Registered=0;
YTrain=YTrainRC(:,2);
YTest=YTestRC(:,2);

disp('Results for Predicting Casual Users: ')
FSS

%% RIDGE 
%--------------------------------------------------------------------------
disp(' '); 
disp('Ridge Regression');
disp('------------------');

% For Registered Users:
Registered=1;
YTrain=YTrainRC(:,1);
YTest=YTestRC(:,1);

disp('Results for Predicting Registered Users: ')
RIDGEReg

% For Casual Users:
Registered=0;
YTrain=YTrainRC(:,2);
YTest=YTestRC(:,2);

disp('Results for Predicting Casual Users: ')
RIDGEReg

%% LASSO
%--------------------------------------------------------------------------
disp(' ');
disp('Lasso')
disp('------');

% For Registered Users:
YTrain=YTrainRC(:,1);
YTest=YTestRC(:,1);

disp('Results for Predicting Registered Users:')
Registered=1;
LASSOReg

% For Casual Users:
YTrain=YTrainRC(:,2);
YTest=YTestRC(:,2);

disp('Results for Predicting Casual Users:')
Registered=0;
LASSOReg

%% stepwisefit (based on F-Statistic and p-value)
%--------------------------------------------------------------------------
disp(' ');
disp('Matlab stepwise');
disp('-----------------');

% For Registered Users:
YTrain=YTrainRC(:,1);
YTest=YTestRC(:,1);

disp('Results for Predicting Registered Users:')
Registered=1;
STEPMatlab

% For Casual Users
YTrain=YTrainRC(:,2);
YTest=YTestRC(:,2);
disp('Results for Predicting Casual Users:')
Registered=0;
STEPMatlab


