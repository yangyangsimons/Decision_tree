function visit(node,length_)
    global nodeid nodeids nodevalue;
    if isleaf(node)
        nodeid=nodeid+1;
        fprintf('leafnode，node: %d\t，feature: %s\n', ...
        nodeid, node.value);
        nodevalue{1,nodeid}=node.value;
    else 
        %if isleaf(node.left) && ~isleaf(node.right) 
        nodeid=nodeid+1;
        nodeids(nodeid+length_+1)=nodeid;
        nodeids(nodeid+length_+2)=nodeid;

        fprintf('node: %d\feature: %s\t，leftnode：node%d，rightnode：node%d\n', ...
        nodeid, node.value,nodeid+length_+1,nodeid+length_+2);
        nodevalue{1,nodeid}=node.value;
    end
end