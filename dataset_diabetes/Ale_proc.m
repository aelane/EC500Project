%Time to process that data

col = 18;
for i = 1:length(T)
    if ischar(T{i,col})
        fprintf('%s\n',T{i,col});
        if strcmp(T{i,col},'>200')
            T{i,col} = 200;
        end
        
    end
end