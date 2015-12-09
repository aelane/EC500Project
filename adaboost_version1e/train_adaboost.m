function model= train_adaboost(feature_matrix, class_labels, num_iter)
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
%   model: struct with weak classifiers

%% Initialize Variables

% The output is a struct
model=struct;

% Number of examples
num_examples = length(class_labels);

% Initialize all examples to the same training weight
train_weight=ones(num_examples,1)/num_examples;

% This variable will contain the results of the single weak
% classifiers weight by their alpha
% Initialize vector to store the predicted result of current weak classifier in a vector
weak_predict = zeros(num_examples, 1); %Previously estimateclassnum

% Calculate max min of the data
% Calculate the range of each feature in the data set
range_features = [min(feature_matrix); max(feature_matrix)]; %Previously boundary
boundary=[min(datafeatures) max(datafeatures,[],1)];
% Do all model training itterations
for t=1:num_iter
    % Find the best threshold to separate the data in two classes
    [estimateclass,error,h] = WeightedThresholdClassifier(feature_matrix, class_labels, train_weight);
    
    % Weak classifier influence on total result is based on the current
    % classification error
    alpha=1/2 * log((1-error)/max(error,eps));
    
    % Store the model parameters
    model(t).alpha = alpha;
    model(t).dimension=h.dimension;
    model(t).threshold=h.threshold;
    model(t).direction=h.direction;
    model(t).boundary = boundary;
    % We update D so that wrongly classified samples will have more weight
    train_weight = train_weight.* exp(-model(t).alpha.*dataclass.*estimateclass);
    train_weight = train_weight./sum(train_weight);
    
    % Calculate the current error of the cascade of weak
    % classifiers
    estimateclasssum=estimateclasssum +estimateclass*model(t).alpha;
    estimateclasstotal=sign(estimateclasssum);
    model(t).error=sum(estimateclasstotal~=dataclass)/length(dataclass);
    if(model(t).error==0), break; end
end


function [estimateclass,err,h] = WeightedThresholdClassifier(datafeatures,dataclass,dataweight)
% This is an example of an "Weak Classifier", it caculates the optimal
% threshold for all data feature dimensions.
% It then selects the dimension and  threshold which divides the
% data into two class with the smallest error.

% Number of threshold steps
num_threshold_steps=200000;

% Split the data in two classes 1 and -1
r1=datafeatures(dataclass<0,:); 
w1=dataweight(dataclass<0);
r2=datafeatures(dataclass>0,:); 
w2=dataweight(dataclass>0);

% Calculate the min and max for every dimensions
minr=min(datafeatures,[],1)-1e-10; 
maxr=max(datafeatures,[],1)+1e-10;

% Make a weighted histogram of the two classes
p2c= ceil((bsxfun(@rdivide,bsxfun(@minus,r2,minr),(maxr-minr)))*(num_threshold_steps-1)+1+1e-9);   p2c(p2c>num_threshold_steps)=num_threshold_steps;
p1f=floor((bsxfun(@rdivide,bsxfun(@minus,r1,minr),(maxr-minr)))*(num_threshold_steps-1)+1-1e-9);  p1f(p1f<1)=1;
ndims=size(datafeatures,2);
i1=repmat(1:ndims,size(p1f,1),1);  i2=repmat(1:ndims,size(p2c,1),1);
h1f=accumarray([p1f(:) i1(:)],repmat(w1(:),ndims,1),[num_threshold_steps ndims],[],0);
h2c=accumarray([p2c(:) i2(:)],repmat(w2(:),ndims,1),[num_threshold_steps ndims],[],0);

% This function calculates the error for every all possible treshold value
% and dimension
h2ic=cumsum(h2c,1);
h1rf=cumsum(h1f(end:-1:1,:),1); h1rf=h1rf(end:-1:1,:);
e1a=h1rf+h2ic;
e2a=sum(dataweight)-e1a;

% We want the treshold value and dimension with the minimum error
[err1a,ind1a]=min(e1a,[],1);  dim1a=(1:ndims); dir1a=ones(1,ndims);
[err2a,ind2a]=min(e2a,[],1);  dim2a=(1:ndims); dir2a=-ones(1,ndims);
A=[err1a(:),dim1a(:),dir1a(:),ind1a(:);err2a(:),dim2a(:),dir2a(:),ind2a(:)];
[err,i]=min(A(:,1)); dim=A(i,2); dir=A(i,3); ind=A(i,4);
thresholds = linspace(minr(dim),maxr(dim),num_threshold_steps);
thr=thresholds(ind);

% Apply the new treshold
h.dimension = dim;
h.threshold = thr;
h.direction = dir;
estimateclass=ApplyClassTreshold(h,datafeatures);

function y = ApplyClassTreshold(h, x)
% Draw a line in one dimension (like horizontal or vertical)
% and classify everything below the line to one of the 2 classes
% and everything above the line to the other class.
if(h.direction == 1)
    y =  double(x(:,h.dimension) >= h.threshold);
else
    y =  double(x(:,h.dimension) < h.threshold);
end
y(y==0) = -1;

