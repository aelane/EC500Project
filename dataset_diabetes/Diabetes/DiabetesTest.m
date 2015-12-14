%% Heres an attempt to compare ADABOOST, DECISION TREES, AND SVMS?
clear
close all
load('Diabetes_Data.mat');

% We partition the data into a training set and a testing set.
%Training will be 25% of the data
xtrain = X_Data(1:25000,:);
ytrain = Y_Label(1:25000);

%Testing will be 75% of the data
xtest = X_Data(25001:end,:);
ytest = Y_Label(25001:end);

%Below we attempt AdaBoost
[model, ada_predict] = train_adaboost(xtrain, ytrain, 50);
ada_predict = test_adaboost(xtest, model);
adaconf = confusionmat(ytest,ada_predict)
CCR_Ada = trace(adaconf)/length(ytest)

%Below we attempt fitting a classification tree
Tree = fitctree(xtrain, ytrain, 'MinLeafSize', 20, 'ResponseName', 'Re-admission', 'MaxNumSplits', 100);
tree_predict = predict(Tree, xtest);
treeconf = confusionmat(ytest,tree_predict)
CCR_tree = trace(treeconf)/length(ytest)

%Bellow we attempt an SVM classifier, default with a linear kernel.
svmmodel = fitcsvm(xtrain,ytrain);
svmpredict = predict(svmmodel, xtest);
svmconf = confusionmat(ytest,svmpredict)
CCR_svm = trace(svmconf)/length(ytest)



%% Plot CCR values
figure
bar((100*[CCR_Ada, CCR_tree, CCR_svm]))
title('Correct Clasification Rates of Classifiers')
set(gca,'XTickLabel',{'AdaBoost', 'Tree','SVM'}, 'FontSize',16)
ylabel('Percent')

%% Plot precision indexes

ada_pre = 100*adaconf(2,2)/sum(adaconf(:,2))
tree_pre = 100*treeconf(2,2)/sum(treeconf(:,2))
svm_pre = 100*svmconf(2,2)/sum(svmconf(:,2))

figure
bar([ada_pre, tree_pre, svm_pre])
title('Precision Rates of Classifiers')
set(gca,'XTickLabel',{'AdaBoost', 'Tree','SVM'}, 'FontSize',16)
ylabel('Percent')

%% Plot ROC curves for each:
[adaX, adaY, ~, adaAUC] = perfcurve(ada_predict,ytest,1);
[treeX, treeY, ~, treeAUC] = perfcurve(tree_predict,ytest,1);
[svmX, svmY, ~, svmAUC] = perfcurve(svmpredict,ytest,1);

figure
subplot(1,2,1)
plot(adaX,adaY,'b','LineWidth', 5);
hold on
plot(treeX,treeY,'r','LineWidth', 5);
hold on
plot(svmX,svmY,'k','LineWidth', 5);

title('ROC Curves', 'FontSize',16)
legend('AdaBoost','Tree','SVM','FontSize',16)
xlabel('False Positive Rate', 'FontSize',16)
ylabel('True Positive Rate', 'FontSize',16)

% Plot Area in AUC
subplot(1,2,2)
bar([adaAUC, treeAUC, svmAUC])
title('Area under the curve')
set(gca,'XTickLabel',{'AdaBoost', 'Tree','SVM'}, 'FontSize',16)
ylabel('Area')

