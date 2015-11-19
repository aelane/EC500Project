% For Thyroid Data
% Annie Lane
% November 18, 2015
% EC500 B1 - Project

%% Load Thyroid Data
load('all_thyroid.mat');

[num_samples, num_features] = size(Thyroid_Features);

%% Randomly divide up the data with True/False Features

% Select the true/false features
TF_Feature_Inds = [3:17 19 21 23 25 27];
num_TF_features = length(TF_Feature_Inds);
TF_Names = Feature_Names(TF_Feature_Inds);
TF_Features = Thyroid_Features(:,TF_Feature_Inds);

% Fix the random seed (randstream)
s = RandStream('mt19937ar','Seed',0);
randInd = randperm(s, num_samples);

% Set training set to 70%
% Set test set to remainig examples
numTrain = ceil(num_samples * 0.7);
numTest = num_samples - numTrain;

X_train = TF_Features(randInd(1:numTrain), :);
Y_train = allhypo_labels(randInd(1:numTrain), :);
X_test = TF_Features(randInd((numTrain+1):end), :);
Y_test = allhypo_labels(randInd((numTrain+1):end), :);

possible_labels = unique(allhypo_labels);
num_classes = length(possible_labels);

num_train_per_class = zeros(1,num_classes);

for i=1:num_classes
    num_train_per_class(i) = length(ismember(Y_train, possible_labels(i)));
end

%% Perform Naive Bayes with True/False Features

% This is where I create the Beta Matrix based on the training set

%initialize the Beta matrix
Beta = zeros(num_TF_features, num_classes);
Raw_Beta = zeros(num_TF_features, num_classes);


% Iterate over the full training feature matrix
for n=1:numTrain
    for f=1:num_features
        Raw_Beta(Train_WordID(i), Train_True_Label(i)) = Raw_Beta(Train_WordID(i), Train_True_Label(i)) + Train_WordCount(i);
    end
end

% Normalize Beta
Beta_numWordsInClass = sum(Raw_Beta);
for i=1:numGroupLabels
   Beta(:,i) = Raw_Beta(:,i)/Beta_numWordsInClass(i); 
end

% Confirm that all columns sum to 1
sum_ofNormBeta = sum(Beta);

%Compute prior probabilty (Pi) based on training set
Pi = zeros(numGroupLabels, 1);
for i=1:numGroupLabels
    %Find the training examples with current class = i
    Pi(i) = length(find(train_label == i));
end

Pi = Pi/length(train_label);


% Take the logs so that you can sum 
Ln_Beta = log(Beta);
Ln_Pi = log(Pi);


%% WAIT - How to deal with missing values...



