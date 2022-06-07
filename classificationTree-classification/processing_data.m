function [matrix,names,activeAttributes] = processing_data(table)


studentData = table;
if (isempty(studentData))
    error('fail to read the data from this file');
end
% convert all the datas into zeros and ones;

grades = studentData(:,end - 2 : end);
grades = table2array(grades);
grades(grades < 10) = 0;
grades(grades >= 10) = 1;
studentData.G1 = grades(:,1);
studentData.G2 = grades(:,2);
studentData.G3 = grades(:,3);
Nnames = studentData.Properties.VariableNames;
names = Nnames(1:length(Nnames) -1);

student_Array = table2array(studentData);
attributesdata = student_Array(:,1:end-3);
[number_attributes,number_Features] = size(attributesdata);
meanFeatures = [];
for k = 1: number_Features
    meanFeatures(end + 1 ) = mean(attributesdata(:,k));
end
for a = 1 : number_Features
    for b = 1 : number_attributes
        if(attributesdata(b,a) < meanFeatures(a))
            attributesdata(b,a) = 0;
        else
            attributesdata(b,a) = 1;
        end
    end
end
student_Array = [attributesdata,grades];
studentData = array2table(student_Array,"VariableNames",Nnames);
%set activeAttributes as to control the label;

activeAttributes = ones(1,length(Nnames) - 1);
matrix = table2array(studentData);
% 
%%
% [nodeids,nodevalues] = print_tree(Tree);
% tree_plot(nodeids,nodevalues)
% %%
% ClassifyByTree(Tree,testfeatures);
% %%
end