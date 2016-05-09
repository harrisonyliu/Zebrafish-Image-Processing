close all
clear all

filename = fullfile('F:\CellProfiler Output\20160307_acute5dpfZfactor_relaxedthresh','20160307_acute5dpfZfactor_relaxedthreshImage.csv');

%First rip all the relevant data from the excel file for each features
plate_struct = separateReplicatePlates(filename,'Count_Neurons',...
    'Intensity_TotalIntensity_ghettoconv','Intensity_TotalIntensity_inverted_conv',...
    'TotalIntensity_inner','Intensity_TotalIntensity_position_measure',...
    'Intensity_TotalIntensity_eyes_removed_cropped_Neurons',...
    'Mean_Neurons_Intensity_MedianIntensity_inner_brain',...
    'Correlation_Correlation_eyes_removed_cropped_avg_brain');

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

aggregateData.strict.posctrl = aggregateData.Intensity_TotalIntensity_ghettoconv.posctrl - aggregateData.Intensity_TotalIntensity_inverted_conv.posctrl;
aggregateData.strict.negctrl = aggregateData.Intensity_TotalIntensity_ghettoconv.negctrl - aggregateData.Intensity_TotalIntensity_inverted_conv.negctrl;

%Now let's create a Manhattan plot for every feature with the appropriate
%groupings!

createManhattan_grouped(aggregateData)

for i = 1:numel(features)
        eval(['mean_pos = nanmean(aggregateData.' features{i} '.' groups{1} ');'])
        eval(['mean_neg = nanmean(aggregateData.' features{i} '.' groups{2} ');'])
        eval(['std_pos = nanstd(aggregateData.' features{i} '.' groups{1} ');'])
        eval(['std_neg = nanstd(aggregateData.' features{i} '.' groups{2} ');'])
        zfactor = 1 - 3*(std_pos + std_neg) / (abs(mean_pos - mean_neg));
        [features{i} ' = ' num2str(zfactor)]
end


