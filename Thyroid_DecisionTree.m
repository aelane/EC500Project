% For Thyroid Data
% Annie Lane
% November 18, 2015
% EC500 B1 - Project

% Decision Tree Classifier

%% Load Thyroid Data
clear;
clc;
load('all_thyroid.mat');

[num_examples, num_features] = size(Thyroid_Features);

possible_hypo_labels = unique(allhypo_labels);
num_hypo_labels = length(possible_hypo_labels);

num_ex_per_class = zeros(1,num_hypo_labels);
for i=1:num_hypo_labels
    num_ex_per_class(i) = sum(ismember(allhypo_labels, possible_hypo_labels(i)));
end

%% Randomly divide up the data with True/False Features

% Select the true/false features
TF_Feature_Inds = [3:17 19 21 23 25 27];
num_TF_features = length(TF_Feature_Inds);
TF_Names = Feature_Names(TF_Feature_Inds);
TF_Features = Thyroid_Features(:,TF_Feature_Inds);

% Fix the random seed (randstream)
s = RandStream('mt19937ar','Seed',0);
randInd = randperm(s, num_examples);

% Set training set to 70%
% Set test set to remainig examples
numTrain = ceil(num_examples * 0.7);
numTest = num_examples - numTrain;

X_train_TF = TF_Features(randInd(1:numTrain), :);
Y_train_TF = allhypo_labels(randInd(1:numTrain), :);
X_test_TF = TF_Features(randInd((numTrain+1):end), :);
Y_test_TF = allhypo_labels(randInd((numTrain+1):end), :);

num_train_per_class = zeros(1,num_hypo_labels);

for i=1:num_hypo_labels
    num_train_per_class(i) = sum(ismember(Y_train_TF, possible_hypo_labels(i)));
end

%% Use decision tree

tree_TF = fitctree(X_train_TF, Y_train_TF);
Y_predict_test_TF = predict(tree_TF, X_test_TF);
Y_predict_train_TF = predict(tree_TF, X_train_TF);

% Get the confusion matrix
confusionmat_Test_TF = confusionmat(Y_test_TF, Y_predict_test_TF);
confusionmat_Train_TF = confusionmat(Y_train_TF, Y_predict_train_TF);

% CONCLUSIONS: Does a really poor job when evaluating the confusion matrix
% Need other metrics that will place weight on 
% the only non-negative class that is correctly classified in the original
% Training set is for compensated hypothyroid, which was the next most
% frequently occuring
% In the full set, this is the breakdown of examples
% 2580 == negative
% 64   == primary hypothyroid
% 154   == compensated hypothyroid
% 2     == secondary hypothyroid


%% WAIT - How to deal with missing values...
% HOW to deal with many more negative than other classes


