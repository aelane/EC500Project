function [model, final_predict] = train_adaboost(feature_matrix, class_labels, num_t)
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
%   class_labels: a vector of labels for each example (either -1 or 1)
%   num_iter: number of weak classifiers to be use for training

% Output:
%   model: struct with num_t weak classifiers; each weak classifier has:
%       alpha - the weight of the classifier
%       feature - the feature used to make the decision
%       threshold - the threshold value on the feature to split the data
%       direction - which side of the threshold is which class
%       boundary -
%       error - the error with this classifier
%       poserror - the percent of actually positive examples misclassified
%       negerror - the percent of actually negative examples misclassified

%% Initialize Variables

% Initialize output as a struct
model = struct;

% Number of examples
num_examples = length(class_labels);
ind_positive = find(class_labels == 1);
ind_negative = find(class_labels == -1);
num_positive = length(ind_positive);
num_negative = length(ind_negative);

% Initialize all examples to the same training weight
sample_weight=ones(num_examples,1)/num_examples;

% This variable will contain the results of the single weak
% classifiers weight by their alpha
% Initialize vector weak_predict_sum to store the predicted result of all weak classifiers
% so far -- the sum of the classifier times the classifier weight
predict_sum = zeros(num_examples, 1); %Previously estimateclassnum

% Calculate the range (min and max) of each feature in the data set
% min_feature_vals = min(feature_matrix);
% max_feature_vals = max(feature_matrix);
boundary=[min(feature_matrix, [], 1) max(feature_matrix,[],1)];
%% Do all model training iterations
for t=1:num_t
    % Find the best threshold to separate the data in two classes
    [weak_predict, error, weak_classifier] = WeightedThresholdClassifier(feature_matrix, class_labels, sample_weight);
    
    % Alpha is the weight for the weak classifier, based on classification
    % error (where eps is the floating-point relative accuracy - avoid
    % dividing by zero)
    alpha= 1/2 * log((1-error)/max(error,eps));
    
    % Store the model parameters
    model(t).alpha = alpha;
    model(t).feature=weak_classifier.feature;
    model(t).threshold=weak_classifier.threshold;
    model(t).direction=weak_classifier.direction;
    model(t).boundary = boundary;
    % Update the weights for each sample so wrongly classified samples will have more weight
    % in next iteration
    sample_weight = sample_weight .* exp(-alpha * class_labels .* weak_predict);
    sample_weight = sample_weight./sum(sample_weight); %Normalize the weights
    
    % Update the predict_sum and determine the current cascade of
    % classifiers prediction
    predict_sum = predict_sum + weak_predict * alpha;
    curr_predict_label = sign(predict_sum);
    % Calculate the current error of the cascade of weak classifiers
    model(t).error = sum(curr_predict_label ~= class_labels)/num_examples;
    
    % Calculate the misclassification error for the positive and negative examples
    model(t).poserror = sum(curr_predict_label(ind_positive) ~= 1)/num_positive;
    model(t).negerror = sum(curr_predict_label(ind_negative) ~= -1)/num_negative;
    % If the error is 0, then break out of loop
    if(model(t).error==0) 
        break; 
    end
    
    final_predict = curr_predict_label;
    
end


function [estimateclass,err,h] = WeightedThresholdClassifier(datafeatures,dataclass,dataweight)
% This is an example of an "Weak Classifier", it calculates the optimal
% threshold for all data feature dimensions.
% It then selects the dimension and  treshold which divides the 
% data into two class with the smallest error.

% Number of treshold steps
ntre=2e5;

% Split the data in two classes 1 and -1
r1=datafeatures(dataclass<0,:); 
w1=dataweight(dataclass<0);
r2=datafeatures(dataclass>0,:); 
w2=dataweight(dataclass>0);

% Calculate the min and max for every dimensions
minr=min(datafeatures,[],1)-1e-10; 
maxr=max(datafeatures,[],1)+1e-10;

% Make a weighted histogram of the two classes
p2c= ceil((bsxfun(@rdivide,bsxfun(@minus,r2,minr),(maxr-minr)))*(ntre-1)+1+1e-9);   
p2c(p2c>ntre)=ntre;
p1f=floor((bsxfun(@rdivide,bsxfun(@minus,r1,minr),(maxr-minr)))*(ntre-1)+1-1e-9);  
p1f(p1f<1)=1;
ndims=size(datafeatures,2);
i1=repmat(1:ndims,size(p1f,1),1);  
i2=repmat(1:ndims,size(p2c,1),1);
h1f=accumarray([p1f(:) i1(:)],repmat(w1(:),ndims,1),[ntre ndims],[],0);
h2c=accumarray([p2c(:) i2(:)],repmat(w2(:),ndims,1),[ntre ndims],[],0);

% This function calculates the error for every all possible threshold value
% and dimension
h2ic=cumsum(h2c,1);
h1rf=cumsum(h1f(end:-1:1,:),1); h1rf=h1rf(end:-1:1,:);
e1a=h1rf+h2ic;
e2a=sum(dataweight)-e1a;

% We want the treshold value and dimension with the minimum error
[err1a,ind1a]=min(e1a,[],1);  
dim1a=(1:ndims); 
dir1a=ones(1,ndims);
[err2a,ind2a]=min(e2a,[],1);  
dim2a=(1:ndims); 
dir2a=-ones(1,ndims);
A=[err1a(:),dim1a(:),dir1a(:),ind1a(:);err2a(:),dim2a(:),dir2a(:),ind2a(:)];
[err,i]=min(A(:,1)); 
dim=A(i,2); dir=A(i,3); ind=A(i,4);
thresholds = linspace(minr(dim),maxr(dim),ntre);
thr=thresholds(ind);

% Apply the new treshold
h.feature = dim; 
h.threshold = thr; 
h.direction = dir;
estimateclass=ApplyClassThreshold(h,datafeatures);




