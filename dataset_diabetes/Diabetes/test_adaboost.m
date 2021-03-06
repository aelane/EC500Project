function H_predict_labels = test_adaboost(feature_matrix, model)
% Modified from Copyright (c) 2010, Dirk-Jan Kroon. All rights reserved.
% Function is written by D.Kroon University of Twente (August 2010)
% See license.txt

% Modified by Annie Lane
% Fall 2015
% ENG EC500 B1 - Boston University

% Overview of train_adaboost and test_adaboost (i.e. Adaboost)

% train_adaboost applies weak classifiers (thersholding on one feature)
% and boosting for binary classification problems

% The weak classifier selects one feature of the data set and finds the
% best threshold to split the data into 2 classes: -1 and 1

% Boosting means calling a series of the weak classifiers and adjusting
% weights for the misclassified examples. This "cascade" of weak
% classifiers together behave like a strong classifier with low error

% Inputs:
%   feature_matrix: matrix of features where each row is an example and each
%       column if a feature
%   model: struct with num_t weak classifiers; each weak classifier has:
%       alpha - the weight of the classifier
%       feature - the feature used to make the decision
%       threshold - the threshold value on the feature to split the data
%       direction - which side of the threshold is which class
%       boundary -
%       totalerror - the error with this classifier
%       poserror - the percent of actually positive examples misclassified
%       negerror - the percent of actually negative examples misclassified

% Output:
%   H_predict_labels: the predicted classification of all test examples

%Initialize predict_sum vector
predict_sum = zeros(size(feature_matrix,1),1);

% Limit feature_matrix to training set boundaries
if(length(model)>1);
    minb=model(1).boundary(1:end/2);
    maxb=model(1).boundary(end/2+1:end);
    feature_matrix=bsxfun(@min,feature_matrix,maxb);
    feature_matrix=bsxfun(@max,feature_matrix,minb);
end


% Add all results of the single weak classifiers weighted by their alpha
for t=1:length(model);
    predict_sum = predict_sum + model(t).alpha * ApplyClassThreshold(model(t), feature_matrix);
end

% For each example, if predict_sum(i) is less than zero, then predict class -1
% If predict_sum(i) is greater than zero, then predict class +1
H_predict_labels =sign(predict_sum);




