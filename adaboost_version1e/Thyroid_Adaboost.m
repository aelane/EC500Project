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
H_predict_labels =sign(predict_sum);
 
confusionmat(train_hypo_binary, H_predict_labels)

 
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
 
 confusionmat(train_hypo_binary, ada_predict)
 
%% Apply Decision tree

thyroid_tree = fitctree(train_thyroid_features, train_hypo_binary);
tree_predict = predict(thyroid_tree, train_thyroid_features);

confusionmat(train_hypo_binary, tree_predict)
view(thyroid_tree,'Mode','graph')
