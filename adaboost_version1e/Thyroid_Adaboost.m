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

ada_conmat = confusionmat(train_hypo_binary, ada_predict)
ada_CCR = trace(ada_conmat)/num_train

%% Get results for 5 trainers
num_T = 5;

predict_sum = zeros(size(train_thyroid_features,1),1);

% Limit feature_matrix to training set boundaries
if(length(model)>1);
    minb=model(1).boundary(1:end/2);
    maxb=model(1).boundary(end/2+1:end);
    train_thyroid_features=bsxfun(@min,train_thyroid_features,maxb);
    train_thyroid_features=bsxfun(@max,train_thyroid_features,minb);
end

% Add all results of the single weak classifiers weighted by their alpha
for t=1:num_T;
    predict_sum = predict_sum + model(t).alpha * ApplyClassThreshold(model(t), train_thyroid_features);
end

% For each example, if predict_sum(i) is less than zero, then predict class -1
% If predict_sum(i) is greater than zero, then predict class +1
ada_predict_5 =sign(predict_sum);
 
ada_5_conmat = confusionmat(train_hypo_binary, ada_predict_5);
ada_5_CCR = trace(ada_5_conmat)/num_train

 
 %% Plot the error
 
 fig3 = figure(3);
 clf(fig3)
 error=zeros(1,length(model)); 
 for i=1:length(model) 
     error(i)=model(i).error; 
 end 
 plot(error*100,'k','LineWidth',3); 
 hold on;
  poserror=zeros(1,length(model)); 
 for i=1:length(model) 
     poserror(i)=model(i).poserror; 
 end
 plot(poserror*100,'b', 'LineWidth',2)
 negerror=zeros(1,length(model));
 for i=1:length(model) 
     negerror(i)=model(i).negerror; 
 end 
 plot(negerror*100, 'r','LineWidth',2)
 legend('Total Classification Error', 'Classification Error for True Positive Examples', 'Classification Error for True Negative Examples');

title('Hypothyroid Classification Error as a function of number of Weak Classifiers');
xlabel('Number of Weak Classifiers');
ylabel('Percent Classification Error');
set(gca,'FontSize',20)

%% Apply Decision tree

thyroid_tree = fitctree(train_thyroid_features, train_hypo_binary);
tree_predict = predict(thyroid_tree, train_thyroid_features);

dt_conmat = confusionmat(train_hypo_binary, tree_predict)
dt_CCR = trace(dt_conmat)/num_train


%view(thyroid_tree,'Mode','graph')


%% Plot the ROCs

 [adaX,adaY,adaT,adaAUC] = perfcurve(train_hypo_binary,ada_predict,1);
 
 [adaX_5,adaY_5,adaT_5,adaAUC_5] = perfcurve(train_hypo_binary,ada_predict_5,1);
 
 [dtX,dtY,dtT,dtAUC] = perfcurve(train_hypo_binary,tree_predict,1);
 
 
 fig2 = figure(2);
 clf(2);
 plot(adaX, adaY,'--', 'LineWidth',3);
 hold on;
 plot(adaX_5, adaY_5,':','LineWidth',3);
 plot(dtX,dtY,'-.','LineWidth',3);
 legend('AdaBoost T = 50','AdaBoost T = 5', 'Decision Tree','Location','Southeast');
 title('Receiver Operating Characteristic for Thyroid Data set');
 xlabel('False Positive Rate');
 ylabel('True Positive Rate');
 set(gca,'FontSize',20);
 
 %% Run SVM
 
 
