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
 
 
 % Training results
 % Show results
  blue = Xtrain(classestimate==-1,:); 
  red = Xtrain(classestimate==1,:);
  I=zeros(161,161);
  for i=1:length(model)
      if(model(i).feature==1)
          if(model(i).direction==1), rec=[-80 -80 80+model(i).threshold 160];
          else rec=[model(i).threshold -80 80-model(i).threshold 160 ];
          end
      else
          if(model(i).feature==1), rec=[-80 -80 160 80+model(i).threshold];
          else rec=[-80 model(i).threshold 160 80-model(i).threshold];
          end
      end
      rec=round(rec);
      y=rec(1)+81:rec(1)+81+rec(3); x=rec(2)+81:rec(2)+81+rec(4);
      I=I-model(i).alpha; I(x,y)=I(x,y)+2*model(i).alpha;    
  end
 subplot(2,2,2), imshow(I,[]); colorbar; axis xy;
 colormap('jet'), hold on
 plot(blue(:,1)+81,blue(:,2)+81,'bo');
 plot(red(:,1)+81,red(:,2)+81,'ro');
 title('Training Data classified with adaboost model');

 % Show the error verus number of weak classifiers
 fig3 = figure(3)
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

 % Make some test data
  angle=rand(200,1)*2*pi; l=rand(200,1)*70; testdata=[sin(angle).*l cos(angle).*l];

 % Classify the testdata with the trained model
  testclass = test_adaboost(testdata, model);

 % Show result
  blue=testdata(testclass==-1,:); 
  red=testdata(testclass==1,:);

 % Show the data
  subplot(2,2,4), hold on
  plot(blue(:,1),blue(:,2),'b*');
  plot(red(:,1),red(:,2),'r*');
  axis equal;
  title('Test Data classified with adaboost model');