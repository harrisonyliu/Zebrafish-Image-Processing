close all
clear all

%% Plate 1
pathname = 'File Pathname Here';
fname = 'Filename Here';
filename = fullfile(pathname,fname);

%First rip all the relevant data from the excel file for each features
plate_struct = separateReplicatePlates(filename,...
    'Intensity_TotalIntensity_ghettoconv');

%Next tell the computer which wells should be grouped together
platemap.DMSO = createWellGroups('A', 'H', 1, 1);
platemap.Mtz = createWellGroups('A', 'H', 12, 12);
platemap.col2 = createWellGroups('A', 'H', 2, 2);
platemap.col3 = createWellGroups('A', 'H', 3, 3);
platemap.col4 = createWellGroups('A', 'H', 4, 4);
platemap.col5 = createWellGroups('A', 'H', 5, 5);
platemap.col6 = createWellGroups('A', 'H', 6, 6);
platemap.col7 = createWellGroups('A', 'H', 7, 7);
platemap.col8 = createWellGroups('A', 'H', 8, 8);
platemap.col9 = createWellGroups('A', 'H', 9, 9);
platemap.col10 = createWellGroups('A', 'H', 10, 10);
platemap.col11 = createWellGroups('A', 'H', 11, 11);

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

createManhattan_grouped(aggregateData)
plotTitle = inputdlg('How should the graph be titled?');%input('How should the graph be titled? ','s');
ylabel('BHS (non-log normalized, a.u.)');
title(plotTitle{1});

% for i = 1:numel(features)
%         eval(['mean_pos = nanmean(aggregateData.' features{i} '.' groups{1} ');'])
%         eval(['mean_neg = nanmean(aggregateData.' features{i} '.' groups{2} ');'])
%         eval(['std_pos = nanstd(aggregateData.' features{i} '.' groups{1} ');'])
%         eval(['std_neg = nanstd(aggregateData.' features{i} '.' groups{2} ');'])
%         zfactor = 1 - 3*(std_pos + std_neg) / (abs(mean_pos - mean_neg));
%         [features{i} ' = ' num2str(zfactor)]
% end

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
%     placeholder = [];color = 'gymcbkr';colorIdx = 1;
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