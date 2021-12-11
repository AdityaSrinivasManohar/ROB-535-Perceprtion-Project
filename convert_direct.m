%% read file
clear
fileName = 'result3.json';
data = jsondecode(fileread(fileName));
label = zeros(size(data,1),1);
name = strings(size(data,1),1);

%% get max confidence and corresponding label
for i = 1:size(data,1)    
    obj = {data(i).objects};
    title = {data(i).filename};
    name(i,:) = string(extractBetween(title{1,1},37,77));
    if (isempty(obj{1,1})==1)
        label(i,:) = 2; % set custom value
    else
        x = {obj{1,1}.confidence};
        max_conf = max(cell2mat({obj{1,1}.confidence}));
        for j = 1:size(obj{1,1},1)
            if (obj{1,1}(j).confidence == max_conf)
                label(i,:) = obj{1,1}(j).class_id;
            end
        end
    end
end
clear i j

%% output to .csv file
tab = table;
tab.name = name;
tab.label = label;
tab.Properties.VariableNames = {'guid/image' 'label'};
writetable(tab,'result.csv');
clear