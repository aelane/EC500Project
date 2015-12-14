% Example for adaboost.m
%
% Type "edit adaboost.m" to see the code


%% Load KNN Simulation Data
clear;
clc;

load('data_knnSimulation.mat');

% Determine number of examples
num_examples = length(ytrain);

% Update labels to -1 for original class 1 and 2 and 
% +1 for original class 3
ybinary = zeros(num_examples, 1);
ybinary(ytrain == 1) = -1;
ybinary(ytrain == 2) = -1;
ybinary(ytrain == 3) = 1;

% Show the data
fig1 = figure(1);
clf(fig1);
gscatter(Xtrain(:,1),Xtrain(:,2),ybinary, 'br');
title('Training Data in dataknnSimulation.mat with Binary Mapping');
xlabel('First Column Features');
ylabel('Second Column Features');
set(findall(gcf,'type','text'),'FontSize',20);
saveas(fig1, 'Plot_KNN_TrainData','epsc');

 % Use Adaboost to make a classifier
 [model, ada_predict] = train_adaboost(Xtrain,ybinary,50);
 
 %model = test_adaboost(Xtrain, model);

 fig2 = figure(2);
clf(fig2);
gscatter(Xtrain(:,1),Xtrain(:,2),ada_predict, 'br');
title('AdaBoost on Training Data in dataknnSimulation.mat with Binary Mapping');
xlabel('First Column Features');
ylabel('Second Column Features');
set(findall(gcf,'type','text'),'FontSize',20);
saveas(fig2, 'Plot_KNN_TrainData_AdaPredict','epsc');
 
 % Show the error verus number of weak classifiers
 fig3 = figure(3);
 clf(fig3)
 error=zeros(1,length(model)); 
 for i=1:length(model) 
     error(i)=model(i).error; 
 end 
 plot(error, 'LineWidth',3); 
 hold on;
  poserror=zeros(1,length(model)); 
 for i=1:length(model) 
     poserror(i)=model(i).poserror; 
 end
 plot(poserror, 'LineWidth',2)
 negerror=zeros(1,length(model));
 for i=1:length(model) 
     negerror(i)=model(i).negerror; 
 end 
 plot(negerror, 'LineWidth', 2)
 legend('Total Error', 'Positive Error', 'Negative Error');
 title('Classification error versus number of weak classifiers');
