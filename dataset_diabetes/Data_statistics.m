%% This code is to calculate and obtain some interesting statistics about
% the data set that we're working with. We'll be looking at gender, race, 
% age, hospital readmission rates, Time in the hospital

clear
close all
load('Final_Data.mat')

%% Here we look at gender: second column.
figure
col = 2;
tb = tabulate(X_Data(:,col));
bar(tb(:,3))
set(gca,'XTickLabel',{'Female', 'Male'})
title('Gender of Patients')
ylabel('Percent')

%% Here we look at race: first column
figure
col = 1;
tb = tabulate(X_Data(:,col));
bar(tb(:,3))
set(gca,'XTickLabel',{'Caucasian', 'African American', 'Asian','Hispanic','Other/Unknown'})
title('Race of Patients')
ylabel('Percent')

%% Here we look at Ages: Third column
figure
col = 3;
tb = tabulate(X_Data(:,col));
bar(tb(:,3))
set(gca,'XTickLabel',{'0-10', '10-20', '20-30','30-40','40-50','50-60', '60-70', '70-80','80-90','90-100'})
title('Age Range of Patients')
ylabel('Percent')

%% Here we look at Time spent in the hospital: Seventh column
figure
col = 7;
tb = tabulate(X_Data(:,col));
bar(tb(:,3))
title('Time spent in the Hospital')
ylabel('Percent')


%% Here we look at Re-admissionn rates: Labels column
figure
tb = tabulate(Y_Label);
bar(tb(:,3))
title('Readmission Rates')
set(gca,'XTickLabel',{'Not Readmitted', 'Within 30 days'})
ylabel('Percent')

