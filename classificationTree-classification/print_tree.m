function [nodeids_,nodevalue_] = print_tree(tree)

global nodeid nodeids nodevalue;
nodeids(1)=0; 
nodeid=0;
nodevalue={};
if isempty(tree) 
    disp('empty tree！');
    return ;
end

queue = queue_push([],tree);
while ~isempty(queue)  
     [node,queue] = queue_pop(queue); 

     visit(node,queue_curr_size(queue));
     if ~strcmp(node.left,'null') 
        queue = queue_push(queue,node.left); 
     end
     if ~strcmp(node.right,'null') 
        queue = queue_push(queue,node.right); 
     end
end

nodeids_=nodeids;
nodevalue_=nodevalue;
end
