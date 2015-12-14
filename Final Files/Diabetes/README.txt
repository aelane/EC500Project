***************************************
* README - DIABETES DATA SET ADABOOST *
***************************************

In this folder there are MatLab codes, raw cvs files and text files as well. Below is a list:

RAW FILES:
Diabetes_Comments.txt
diabetic_data.csv
IDs_mapping.csv

MATLAB CODE:
DiabetesTest.m
Diabetes_Data.mat
test_adaboost.m
train_adaboost.m
ApplyClassThreshold.m
Data_statistics.m

TEXT FILES:
Preprocessing.txt

————————————————————————————————————

The Raw Files is the data set we obtained directly from the a repository: https://archive.ics.uci.edu/ml/datasets/Diabetes+130-US+hospitals+for+years+1999-2008
There is a comments text file that outlines how the data was collected and which features did the study decide to not include in the final set.
The entire file is diabetic_data.csv and can be opened in excel to view. The IDs_mapping.csv is a file that outlines what each feature is called.

The MatLab file Diabetes_Data.mat is the matrix version of the above file that is suited for MatLab. Some values were reassigned and classified, more information of some of the specific changes are included in the Preprocessing.txt file that we’ve prepared.

Next we have two sets of codes. The first are the AdaBoost test and train function files along with the applyclassthreshold which is the weak learner that AdaBoost will utilise.
These functions are then used in the DiabetesTest.m script that will process the diabetes data against three classifiers: AdaBoost, Decision Tree, and SVM. The code is commented and structured as such.

Lastly there is also a Data_statistics.m file that is a visual tool to see how the total data set looks like in terms of it’s demographics and patient statistics. It produces various bar plots to visualise these differences.

To run the experiment all one needs to do is open MatLab and run the DiabetesTest.m script. Note: the svm runs the longest and might take 20 minutes to finalise.



