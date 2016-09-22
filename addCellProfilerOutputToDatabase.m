function addCellProfilerOutputToDatabase(filename, plateQuadrant,outputFolder)
%This function will parse the raw CellProfiler output, look for the brain
%health score and make a Manhattan plot of all the (raw) scores shown. It
%will then take the scores and save them to the "CURRENT Consolidated
%Screen Data.xls" file. It will also copy as save the previous version as
%"OLD Current"... with the date that this backup was made at the end of the
%filename.
%addCellProfilerOutputToDatabase(plateQuadrant,outputFolder)
%The input plateQuadrant refers to the COMPOUND plate that is represented
%in the CellProfiler output (e.g. 5057SBQ2) and outputFolder is where the
%files should be saved.

% [fname,pathname] = uigetfile('F:\CellProfiler Output/*.csv');
% filename = fullfile(pathname,fname);
% plateQuadrant = '5057SBQ3'; %We must tell the program what plate quadrant to look at - this will be saved in the Excel file as well

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
addToDatabase(datablock,outputFolder); %Here we add the data to the master list