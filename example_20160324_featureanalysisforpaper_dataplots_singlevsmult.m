close all
clear all

%% Plate 1

filename = fullfile('F:\CellProfiler Output\20160324_zfactor_reanalysis_datafrom20151112','20160324_zfactor_reanalysisImage.csv');
[~, txt, ~]=xlsread(filename); 
%Here we want to extract all the features except for the filename
features = {txt{1,:}};col_notdata = [];
for i = 1:size(txt,2)
    if strfind(features{i},'FileName') == 1
        col_notdata = [col_notdata i];
    elseif strfind(features{i},'ImageNumber') == 1
        col_notdata = [col_notdata i];
    end
end
features(col_notdata) = [];
ghettoconv_col = 69;

%First rip all the relevant data from the excel file for each features
plate_struct = separateReplicatePlates(filename,features{:});

%Now create the metascore that combines all four features together
% w = [0.3425, -1.1846, -0.4643, -0.9152]; %Weight vectors from the SVM training
% plate_struct.metascore = calc_metascore(w,plate_struct,[],[]);

%Next tell the computer which wells should be grouped together
platemap.posctrl = createWellGroups('A', 'D', 1, 12);
platemap.negctrl = createWellGroups('E', 'H', 1, 12);

%Now group the data together for each condition and each feature
features = fieldnames(plate_struct);
groups = fieldnames(platemap);
for i = 1:numel(features)
    for j = 1:numel(groups)
        struct_name = ['aggregateData.' features{i} '.' groups{j}];
        struct_wellname = ['aggregateData_wellname.' features{i} '.' groups{j}];
        eval(['[' struct_name ',' struct_wellname '] = groupWells(platemap.' groups{j} ', plate_struct.' features{i} ');']);
    end
end


%Now group the data together for each condition and each feature
features = fieldnames(plate_struct);
groups = fieldnames(platemap);
for i = 1:numel(features)
    for j = 1:numel(groups)
        struct_name = ['aggregateData.' features{i} '.' groups{j}];
        struct_wellname = ['aggregateData_wellname.' features{i} '.' groups{j}];
        eval(['[' struct_name ',' struct_wellname '] = groupWells(platemap.' groups{j} ', plate_struct.' features{i} ');']);
    end
end

%% Plotting data

%Now let's create a Manhattan plot for every feature with the appropriate
%groupings!

% createManhattan_grouped(aggregateData)
% 
% for i = 1:numel(features)
%     eval(['mean_pos = nanmean(aggregateData.' features{i} '.' groups{1} ');'])
%     eval(['mean_neg = nanmean(aggregateData.' features{i} '.' groups{2} ');'])
%     eval(['std_pos = nanstd(aggregateData.' features{i} '.' groups{1} ');'])
%     eval(['std_neg = nanstd(aggregateData.' features{i} '.' groups{2} ');'])
%     zfactor = 1 - 3*(std_pos + std_neg) / (abs(mean_pos - mean_neg));
%     [features{i} ' = ' num2str(zfactor)]
% end

%% Here let's see how increasing the number of samples to average will affect the overall Z'-factor

for i = 1:numel(features)
    Z_array = zeros(100,10);
    posname = ['aggregateData.' features{i} '.posctrl'];
    negname = ['aggregateData.' features{i} '.negctrl'];
    eval(['raw_pos = ' posname ';']) %Get the raw data
    eval(['raw_neg = ' negname ';'])
    eval(['raw_pos_reshape = reshape(' posname ',numel(' posname '),1);'])
    eval(['raw_neg_reshape = reshape(' negname ',numel(' negname '),1);'])
    raw_pos_reshape(isnan(raw_pos_reshape)) = [];
    raw_neg_reshape(isnan(raw_neg_reshape)) = [];
    for k = 1:size(Z_array,1)
        for j = 1:size(Z_array,2)
            idxpos = randperm(numel(raw_pos_reshape));
            idxneg = randperm(numel(raw_neg_reshape));
            numpos = floor(numel(raw_pos_reshape)/j);
            numneg = floor(numel(raw_neg_reshape)/j);
            select_pos = idxpos(1:j*numpos);
            select_neg = idxneg(1:j*numneg);
            select_pos_data = reshape(raw_pos_reshape(select_pos),j,numpos);
            select_neg_data = reshape(raw_neg_reshape(select_neg),j,numneg);
            if j > 1
                avg_pos_data = mean(select_pos_data); avg_neg_data = mean(select_neg_data);
            else
                avg_pos_data = select_pos_data; avg_neg_data = select_neg_data;
            end
            mean_pos = mean(avg_pos_data); mean_neg = mean(avg_neg_data);
            std_pos = std(avg_pos_data); std_neg = std(avg_neg_data);
            Z_array(k,j) = 1 - 3*(std_pos + std_neg) / (abs(mean_pos - mean_neg));
        end
    end
    figure(); plot(mean(Z_array),'bo-');
    title(['Z-factor for ' features{i} ' as sample number is increased']);
    xlabel('Number of averaged larvae');ylabel('Z-factor');
end
