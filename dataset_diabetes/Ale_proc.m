%Time to process that data

col = 45;
for i = 1:length(T)
    
    if ischar(T{i,col})
        fprintf('%s\n',T{i,col});
        
        if strcmp(T{i,col},'<30')
                T{i,col} = -1;
        end
        
%           if strcmp(T{i,j},'Up')
%               T{i,j} = 2;
%           
%           elseif strcmp(T{i,j},'Down')
%               T{i,j} = -2;
%     
%           elseif strcmp(T{i,j},'Steady')
%               T{i,j} = 1;
%           end
        
    end
    
end
