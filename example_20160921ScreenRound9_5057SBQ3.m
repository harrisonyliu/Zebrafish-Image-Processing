close all
clear all

%% Plate 1

% filename = fullfile('F:\CellProfiler Output\2016.06.29 Screen Round 2 5052SBQ3','5052SBQ3Image.csv');
filename = fullfile('Y:\Harrison\Data\Zebrafish - CellProfiler Output\2016.09.21 5057SBQ3','2016.09.21 5057SBQ3Image.csv');
plateQuadrant = '5057SBQ3'; %We must tell the program what plate quadrant to look at - this will be saved in the Excel file as well

%First rip all the relevant data from the excel file for each features
plate_struct = separateReplicatePlates(filename,'Intensity_TotalIntensity_ghettoconv');
% plate_struct = separateReplicatePlates(filename,'Count_Neurons',...
%     'Intensity_TotalIntensity_ghettoconv',...
%     'Intensity_TotalIntensity_eyes_removed_cropped_Neurons',...
%     'Intensity_MADIntensity_eyes_removed_cropped_Neurons');

%% This part is boring, just how to assign wells of data
%Next tell the computer which wells should be grouped together
platemap.posctrl = createWellGroups('A', 'H', 1, 1);
platemap.negctrl = createWellGroups('A', 'H', 12, 12);
rows = 'ABCDEFGH'; cols = [2 3 4 5 6 7 8 9 10 11];
for i = 1:numel(rows)
    for j = 1:numel(cols)
        eval(['platemap.' rows(i) '_' num2str(cols(j)) ' = createWellGroups(''' ...
            rows(i) ''',''' rows(i) ''',' num2str(cols(j)) ',' num2str(cols(j)) ');'])
    end
end

%% Now back to actual plotting of the data

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

createManhattan_grouped_forscreens(aggregateData)
title([plateQuadrant ', Brain Health Score (non-log normalized)']);

%This section is just for sanity checking our SSMD calculations
datablock = calcSSMD(aggregateData,'Intensity_TotalIntensity_ghettoconv',plateQuadrant);
addToDatabase(datablock); %Here we add the data to the master list

% ssmdscore = cell2mat(datablock(4:end,5));bhs = cell2mat(datablock(4:end,6));
% ssmdscore_norm = ssmdscore - min(ssmdscore); ssmdscore_norm = ssmdscore_norm ./ max(ssmdscore_norm);
% bhs_norm = bhs - min(bhs); bhs_norm = bhs_norm ./ max(bhs_norm);
% numobs = cell2mat(datablock(4:end,end));
% figure();bar([bhs_norm, ssmdscore_norm, numobs/3]);
% legend('Brain Health Score','SSMD*','Observations/3');
% xticklabel_rotate(1:numel(bhs_norm),90,datablock(4:end,2),'Fontsize',7);
% title([plateQuadrant ' SSMD Calculation Checking']);