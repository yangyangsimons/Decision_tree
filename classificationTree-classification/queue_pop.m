function [ item,newqueue ] = queue_pop( queue )

if isempty(queue)
    disp('it empty!!');
    return;
end

item = queue(1);
newqueue=queue(2:end); 

end
