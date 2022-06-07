function [classifications] = make_tree(tree, attributes, results)

comopare_result = results(1, length(results));

if (strcmp(tree.value, 'true'));
    classifications = [1, comopare_result];
    return
end

if (strcmp(tree.value, 'false'));
    classifications = [0, comopare_result];
    return
end

index = find(ismember(attributes,tree.value)==1);
if (results(1, index))
    classifications = make_tree(tree.right, attributes, results); 
else
  
    classifications = make_tree(tree.left, attributes, results);
end

return
end