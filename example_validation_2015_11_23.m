close all
clear all
filename = fullfile('C:\Users\harri_000\20151123SingleCmpdValid','20151123SingleCmpdValidImage.csv');

%First rip all the relevant data from the excel file for each features
% plate_struct = separateReplicatePlates(filename,'Count_Neurons_inner',...
%     'ghettoconv','TotalIntensity_inner','position_measure');
plate_struct = separateReplicatePlates(filename,'Count_Neurons',...
    'ghettoconv','TotalIntensity_inner','position_measure',...
    'Intensity_TotalIntensity_eyes_removed_cropped_Neurons',...
    'Mean_Neurons_Intensity_MeanIntensity_inner_brain',...
    'Mean_Neurons_Intensity_MedianIntensity_inner_brain',...
    'Intensity_TotalIntensity_inner_brain_Neurons');

%Now create the metascore that combines all four features together
% w = [0.3425, -1.1846, -0.4643, -0.9152]; %Weight vectors from the SVM training
% plate_struct.metascore = calc_metascore(w,plate_struct,[],[]);

%Next tell the computer which wells should be grouped together
platemap.posctrl = createWellGroups('A', 'H', 1, 1);
platemap.negctrl = createWellGroups('A', 'H', 12, 12);
platemap.cmp1 = createWellGroups('A', 'H', 2, 2);
platemap.cmp2 = createWellGroups('A', 'H', 3, 3);
platemap.cmp3 = createWellGroups('A', 'H', 4, 4);
platemap.cmp4 = createWellGroups('A', 'H', 5, 5);
platemap.cmp5 = createWellGroups('A', 'H', 6, 6);
platemap.cmp6 = createWellGroups('A', 'H', 7, 7);
platemap.cmp7 = createWellGroups('A', 'H', 8, 8);
platemap.cmp8 = createWellGroups('A', 'H', 9, 9);
% platemap.cou = createWellGroups('A', 'H', 10, 10);
% platemap.nac = createWellGroups('A', 'H', 11, 11);

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

%Now let's create a Manhattan plot for every feature with the appropriate
%groupings!

createManhattan_grouped(aggregateData)

% features = fieldnames(aggregateData);
% groups = fieldnames(eval(['aggregateData.' features{1}]));
% for i = 1:numel(features)
%     bar_data = zeros(1,numel(groups));
%     bar_std = bar_data;
%     num_obsv = bar_data;
%     for j = 1:numel(groups)
%         eval(['temp_data = aggregateData.' features{i} '.' groups{j} ';']);
%         temp_data_reshaped = reshape(temp_data,1,numel(temp_data));
%         bar_data(j) = nanmean(temp_data_reshaped);
%         bar_std(j) = nanstd(temp_data_reshaped);
%         %Find out how many observations there were
%         num_obsv = numel(temp_data_reshaped) - sum(isnan(temp_data_reshaped));
%     end
%     CI = bar_data - 1.96 * (bar_std ./ sqrt(num_obsv));
%     figure();bar(bar_data,'g','EdgeColor','w');hold on;
%     title(features{i});
%     set(gca,'XTickLabel',groups)
%     xticklabel_rotate;
%     errorbar(1:numel(groups),bar_data,CI,'.');
% end

% %Now let's do the same as above, but let's plot each individual well data
% %out
% features = fieldnames(aggregateData);
% groups = fieldnames(eval(['aggregateData.' features{1}]));
% for i = 1:numel(features)
%     placeholder = [];color = 'grmcbky';colorIdx = 1;
%     figure();hold on;title(features{i});
%     bar_data = [];
%     for j = 1:numel(groups)
%         data_str = ['aggregateData.' features{i} '.' groups{j}];
%         temp_data = eval(['reshape(' data_str ''',[1,numel(' data_str ')]);']);
%         bar([placeholder, temp_data],color(colorIdx), 'EdgeColor','w');
%         placeholder = [placeholder, zeros(1,length(temp_data))];
%         
%         if colorIdx == length(color)
%             colorIdx = 1;
%         else
%             colorIdx = colorIdx + 1;
%         end
%     end
%     cutoff = round(numel(groups)/2);
%     axis normal;legend(groups,'Location', 'southoutside','Orientation','horizontal','fontsize',10);
% %     figure();bar(bar_data);
% %     set(gca,'XTickLabel',groups)
% %     xticklabel_rotate;
% end