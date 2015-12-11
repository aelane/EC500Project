% Annie Lane
% EC500 B1
% Fall 2015
% Final Project

% Application of Adaboost to Thyroid data

% Use Hypothyroid data!

%% Load and do final processing on data
%clear;
%clc;

load('Hypo_Thyroid.mat');
num_train = length(train_hypo_labels);

%train_thyroid_features(2,:

% Map the training labels using following system
% -1 is negative (class 0)
% +1 is any version of hypothyroid

train_hypo_binary = zeros(num_train, 1);
train_hypo_binary(train_hypo_labels ~= 0) = 1;
train_hypo_binary(train_hypo_labels == 0) = -1;

num_train_pos = sum(train_hypo_binary == 1); %220 examples of 2800

 [model, ada_predict] = train_adaboost(train_thyroid_features, train_hypo_binary, 50);

 %% Plot the error
 
 fig3 = figure(3);
 clf(fig3)
 error=zeros(1,length(model)); 
 for i=1:length(model) 
     error(i)=model(i).error; 
 end 
 plot(error); 
 hold on;
  poserror=zeros(1,length(model)); 
 for i=1:length(model) 
     poserror(i)=model(i).poserror; 
 end
 plot(poserror)
 negerror=zeros(1,length(model));
 for i=1:length(model) 
     negerror(i)=model(i).negerror; 
 end 
 plot(negerror)
 legend('Total Error', 'Positive Error', 'Negative Error');

 title('Classification error versus number of weak classifiers');
 % Add axes titles
 
 confusionmat(ada_predict, train_hypo_binary);
 

