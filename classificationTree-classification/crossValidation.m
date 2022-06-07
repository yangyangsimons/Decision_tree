clear all;
clc;
data = readtable("student-mat.csv");
dataTable = data(:,29:end);
alldata = dataTable;
[numberExamples,numberLabels] = size(alldata);

splitNumber = 5;
singleDataNumber = floor(numberExamples / 5); 

precisionArray = [];
accuracyArray = [];
recallArray = [];
for c = 1 : splitNumber
    testData = alldata((singleDataNumber*(c-1)+1): singleDataNumber*c,:);
    trainingData = [alldata((singleDataNumber*(c+1)+1):end,:);alldata(1: (singleDataNumber*c-singleDataNumber),:)];
    [accuracy,precision,recall] = predictTree(trainingData,testData);
    accuracyArray(end + 1) = accuracy;
    precisionArray(end + 1) = precision;
    recallArray(end + 1) = recall;
end
bestaccuracy = max(accuracyArray);
% bestprecision = max(precisionArray);
% bestreacall = max(recallArray);
% find the best training data which provide the best accuracy;
% also find this dataset's related precision and recall;
for b = 1 : length(bestaccuracy)
    if(bestaccuracy(b) == bestaccuracy)
        bestindex = b;
    end
end
relatedRecall = recallArray(bestindex);
relatedPrecision = precisionArray(bestindex);

bestData = [alldata((singleDataNumber*(bestindex+1)+1):end,:);alldata((singleDataNumber*(bestindex-1)+1): singleDataNumber*bestindex,:)];
[bestMatrix, attributes_label, activeAttributes] = processing_data(bestData);
bestTree = ID3CAL(bestMatrix, attributes_label, activeAttributes);

[nodeids,nodevalues] = print_tree(bestTree);
tree_plot(nodeids,nodevalues);

% print the best precision based on crossvalidation;

fprintf("bestAccuracy is = %s\n", bestaccuracy);
fprintf("under this accuracy the realted dataset's Precision is = %s\n'", relatedPrecision);
fprintf("under this accuracy the realted dataset's Recall is = %s\n'", relatedRecall);
%%