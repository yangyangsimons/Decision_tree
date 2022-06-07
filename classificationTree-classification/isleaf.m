function flag = isleaf(node)
    if strcmp(node.left,'null') && strcmp(node.right,'null') 
        flag =1;
    else
        flag=0;
    end
end