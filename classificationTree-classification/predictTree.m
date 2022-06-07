function [Accuracy,Precision,Recall] = predictTree(trainingData,testData)
% clear all;
% clc;
% 
% %data processing
% 
% data = readtable("student-mat.csv");
% dataTable = data(:,24:end);
trainingSet = trainingData;
[trainmatrix,attributes_label,activeAttributes] = processing_data(trainingSet);

tree = ID3CAL(trainmatrix, attributes_label, activeAttributes);

% [nodeids,nodevalues] = print_tree(tree);
% tree_plot(nodeids,nodevalues);

testingSet = testData;
[testingMatrix,test_attributes_label,test_activeAttributes] = processing_data(testingSet);
testingMatrix_No_calss = testingMatrix(:,1:end - 1);

compare_test_right = [];
[testingSetSize, numAttributes] = size(testingMatrix_No_calss);

for k = 1 : length(testingMatrix)
    ID3_Classifications =  make_tree(tree, test_attributes_label, testingMatrix(...
        k,:));
    compare_test_right = [compare_test_right;ID3_Classifications];
end
TP_number = 0;
FN_number = 0;
FP_number = 0;
TN_number = 0;
countRight = 0;
for j = 1 : length(testingMatrix)
    if (compare_test_right(j,1) == compare_test_right(j,2))
        countRight = countRight + 1;
    end
    if((compare_test_right(j,1) == 1) & (compare_test_right(j,2) == 1))
        TP_number = TP_number + 1;
    end
    if((compare_test_right(j,1) == 1 & (compare_test_right(j,2)) == 0))
        FP_number = FP_number + 1;
    end
    if((compare_test_right(j,1) == 0) & (compare_test_right(j,2) == 1))
        FN_number = FN_number + 1;
    end
    if((compare_test_right(j,1) == 0) & (compare_test_right(j,2) == 0))
        TN_number = TN_number + 1;
    end
end
% Accuracy = countRight / length(compare_test_right);
Accuracy = (TP_number + TN_number) / length(compare_test_right);
Precision = TP_number / (TP_number + FP_number);
Recall = TP_number / (TP_number + FN_number);
return
end