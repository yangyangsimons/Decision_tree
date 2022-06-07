function [tree] = ID3(caldatas, attributes, activeAttributes)


% constant number for calculate
number_active_label = length(activeAttributes);
numberdatas = length(caldatas(:,1));

% Create the tree node
tree = struct('value', 'null', 'left', 'null', 'right', 'null');

% If last value of all rows in examples is 1, return tree labeled 'true'
lastColumnSum = sum(caldatas(:, number_active_label + 1));
if (lastColumnSum == numberdatas);
    tree.value = 'true';
    return
end
% If last value of all rows in examples is 0, return tree labeled 'false'
if (lastColumnSum == 0);
    tree.value = 'false';
    return
end

if (sum(activeAttributes) == 0);
    if (lastColumnSum >= numberdatas / 2);
        tree.value = 'true';
    else
        tree.value = 'false';
    end
    return
end

% Find the current entropy
Ptrue = lastColumnSum / numberdatas;
Pfalse = 1 - Ptrue;
if (Ptrue == 0 | Pfalse == 0)
    currentEntropy = 0;
else
    currentEntropy = -1 * (Ptrue * log2(Ptrue) + Pfalse * log2(Pfalse));
end

%Find the Gain of all features;
%create an array to store the all gains;
gains = -1*ones(1,number_active_label); 
%create an ilerator to calculate gains of all features;
for i=1:number_active_label;
    if (activeAttributes(i)) 
        %initiate number of positve lable 
        postive_f0 = 0; postive_f0_and_true = 0;
        postive_fi = 0; postive_f1_and_true = 0;
        for j=1:numberdatas;
            % count the number of positive lables
            if (caldatas(j,i)); 
                postive_fi = postive_fi + 1;
                if (caldatas(j, number_active_label + 1)); 
                    postive_f1_and_true = postive_f1_and_true + 1;
                end
            else
                postive_f0 = postive_f0 + 1;
                if (caldatas(j, number_active_label + 1)); 
                    postive_f0_and_true = postive_f0_and_true + 1;
                end
            end
        end
        
         %calculate probability of postive lable when feature value is true;
        if (~postive_fi);
            positive_p1_f1 = 0;
        else
            positive_p1_f1 = (postive_f1_and_true / postive_fi); 
        end
        if (positive_p1_f1 == 0);
            p1_eq = 0;
        else
            p1_eq = -1*(positive_p1_f1)*log2(positive_p1_f1);
        end
        if (~postive_fi);
            negative_p0_f0 = 0;
        else
            negative_p0_f0 = ((postive_fi - postive_f1_and_true) / postive_fi);
        end
        if (negative_p0_f0 == 0);
            p0_eq = 0;
        else
            p0_eq = -1*(negative_p0_f0)*log2(negative_p0_f0);
        end
        entropy_s1 = p1_eq + p0_eq;

        % Entropy for S(v=0)
        if (~postive_f0);
            positive_p1_f1 = 0;
        else
            positive_p1_f1 = (postive_f0_and_true / postive_f0); 
        end
        if (positive_p1_f1 == 0);
            p1_eq = 0;
        else
            p1_eq = -1*(positive_p1_f1)*log2(positive_p1_f1);
        end
        if (~postive_f0);
            negative_p0_f0 = 0;
        else
            negative_p0_f0 = ((postive_f0 - postive_f0_and_true) / postive_f0);
        end
        if (negative_p0_f0 == 0);
            p0_eq = 0;
        else
            p0_eq = -1*(negative_p0_f0)*log2(negative_p0_f0);
        end
        entropy_s0 = p1_eq + p0_eq;
        
        gains(i) = currentEntropy - ((postive_fi/numberdatas)*entropy_s1) - ((postive_f0/numberdatas)*entropy_s0);
    end
end

% Pick the attribute that maximizes gains
[~, bestAttribute] = max(gains);
% Set tree.value to bestAttribute's relevant string
tree.value = attributes{bestAttribute};
% Remove splitting attribute from activeAttributes
activeAttributes(bestAttribute) = 0;

% Initialize and create the new example matrices
examples_0 = []; examples_0_index = 1;
examples_1 = []; examples_1_index = 1;
for i=1:numberdatas;
    if (caldatas(i, bestAttribute)); % this instance has it as 1/true
        examples_1(examples_1_index, :) = caldatas(i, :); % copy over
        examples_1_index = examples_1_index + 1;
    else
        examples_0(examples_0_index, :) = caldatas(i, :);
        examples_0_index = examples_0_index + 1;
    end
end

% For both values of the splitting attribute
% For value = false or 0, corresponds to left branch
% If examples_0 is empty, add leaf node to the left with relevant label
if (isempty(examples_0));
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (lastColumnSum >= numberdatas / 2); % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.left = leaf;
else
    % Here is were we can recur
    tree.left = ID3CAL(examples_0, attributes, activeAttributes);
end
% For value = true or 1, corresponds to right branch
% If examples_1 is empty, add leaf node to the right with relevant label
if (isempty(examples_1));
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (lastColumnSum >= numberdatas / 2); % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.right = leaf;
else
    % Here is were we can recur
    tree.right = ID3CAL(examples_1, attributes, activeAttributes);
end

% Now we can return tree
return
end