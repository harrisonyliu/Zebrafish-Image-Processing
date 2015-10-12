function [fnames, neuroncount, conv, fnames_pos, neuroncount_pos, conv_pos, int_pos, pos_pos,...
    fnames_neg, neuroncount_neg, conv_neg, int_neg, pos_neg] = Zfactor_script

%First locate the Excel file that CellProfiler spits out (use the one with
%the suffix "Image"
[filename, pathname, filterindex] = uigetfile('*.csv');
fname = fullfile(pathname,filename);
[num, txt, raw]=xlsread(fname);
[fnames, neuroncount, conv, int, pos] = process_xls(num,txt,raw);

[wellname_array, well_array, well_array_conv, well_array_int, well_array_pos] = assignReplicatePlates(fnames, neuroncount, conv, int, pos);
%Note: well_array contains raw neuron counts
wellname_array = wellname_array(:,1);
well_array_mean = nanmean(well_array,2);
well_array_conv_mean = nanmean(well_array_conv,2);
well_array_int_mean = nanmean(well_array_int,2);
well_array_pos_mean = nanmean(well_array_pos,2);
[fnames_pos_avg, neuroncount_pos_avg, conv_pos_avg, int_pos_avg, pos_pos_avg,...
    fnames_neg_avg, neuroncount_neg_avg, conv_neg_avg, int_neg_avg, pos_neg_avg] = ...
    parseControls(wellname_array, well_array_mean, well_array_conv_mean, ...
    well_array_int_mean, well_array_pos_mean, 1);
[fnames_pos, neuroncount_pos, conv_pos, int_pos, pos_pos,...
    fnames_neg, neuroncount_neg, conv_neg, int_neg, pos_neg] = ...
    parseControls(fnames, neuroncount, conv, int, pos, 0);

%% Looking at scatterplots

%Plotting the results
figure();plot(neuroncount_pos, conv_pos, 'b.', neuroncount_neg, conv_neg, 'r.');
title('Positive and Negative Controls, Features Combined');xlabel('Neuron Count');
ylabel('Convolution Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

% %Plotting the results (Position)
% figure();plot(neuroncount_pos, pos_pos, 'b.', neuroncount_neg, pos_neg, 'r.');
% title('Positive and Negative Controls, Position Measure');xlabel('Neuron Count');
% ylabel('Position Score (au)');legend('DMSO', '9mM Mtz', 'Location','Best');
% 
% %Plotting the results (Total Intensity)
% figure();plot(neuroncount_pos, int_pos, 'b.', neuroncount_neg, int_neg, 'r.');
% title('Positive and Negative Controls, Total Intensity');xlabel('Neuron Count');
% ylabel('Total Intensity (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

%Averaged version
figure();plot(neuroncount_pos_avg, conv_pos_avg, 'b.', neuroncount_neg_avg, conv_neg_avg, 'r.');
title('Positive and Negative Controls, Features Combined and Averaged');xlabel('Neuron Count');
ylabel('Convolution Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

% %Averaged Position
% figure();plot(neuroncount_pos_avg, pos_pos_avg, 'b.', neuroncount_neg_avg, pos_neg_avg, 'r.');
% title('Positive and Negative Controls, Position Measure Averaged');xlabel('Neuron Count');
% ylabel('Position Score (au)');legend('DMSO', '9mM Mtz', 'Location','Best');
% 
% %Averaged Total Intensity
% figure();plot(neuroncount_pos_avg, int_pos_avg, 'b.', neuroncount_neg_avg, int_neg_avg, 'r.');
% title('Positive and Negative Controls, Total Intensity Averaged');xlabel('Neuron Count');
% ylabel('Total Intensity (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

%% Manhattan Plots

%Looking at differences between neuron counts
figure();bar(neuroncount_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(neuroncount_pos)) neuroncount_neg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Neuron Counts Only');xlabel('Fish Number');
ylabel('Neuron Count');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;

%Now look at difference between the convolutional measure
figure();bar(conv_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(conv_pos)) conv_neg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Convolutional Measure Only');xlabel('Fish Number');
ylabel('Convolutional Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;

% %Now look at difference between the total intensity measure
% figure();bar(int_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(int_pos)) int_neg],'FaceColor','r','EdgeColor','w');
% title('Positive and Negative Controls,Total Intensity Only');xlabel('Fish Number');
% ylabel('Total Intensity Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;
% 
% %Now look at difference between the position measure
% figure();bar(pos_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(pos_pos)) pos_neg],'FaceColor','r','EdgeColor','w');
% title('Positive and Negative Controls, Position Measure Only');xlabel('Fish Number');
% ylabel('Position Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;

%And repeating for the averaged version
figure();bar(neuroncount_pos_avg,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(neuroncount_pos_avg)) neuroncount_neg_avg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Average Neuron Counts Only');xlabel('Fish Number');
ylabel('Neuron Count');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;
set(gca,'XTick',1:length(neuroncount_pos_avg) + length(neuroncount_neg_avg));
set(gca,'XTickLabel',[fnames_pos_avg,fnames_neg_avg]);

figure();bar(conv_pos_avg,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(conv_pos_avg)) conv_neg_avg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Average Convolutional Measure Only');xlabel('Fish Number');
ylabel('Convolutional Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;
set(gca,'XTick',1:length(conv_pos_avg) + length(conv_neg_avg));
set(gca,'XTickLabel',[fnames_pos_avg,fnames_neg_avg]);

% figure();bar(int_pos_avg,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(int_pos_avg)) int_neg_avg],'FaceColor','r','EdgeColor','w');
% title('Positive and Negative Controls, Average Total Intensity Only');xlabel('Fish Number');
% ylabel('Total Intensity (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;
% set(gca,'XTick',1:length(int_pos_avg) + length(int_neg_avg));
% set(gca,'XTickLabel',[fnames_pos_avg, fnames_neg_avg]);
% 
% figure();bar(pos_pos_avg,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(pos_pos_avg)) pos_neg_avg],'FaceColor','r','EdgeColor','w');
% title('Positive and Negative Controls, Average Position Measure Only');xlabel('Fish Number');
% ylabel('Position Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;
% set(gca,'XTick',1:length(pos_pos_avg) + length(pos_neg_avg));
% set(gca,'XTickLabel',[fnames_pos_avg,fnames_neg_avg]);

%% Calculating Z-factors
sigma_pos = std(conv_pos); sigma_neg = std(conv_neg);
mu_pos = mean(conv_pos); mu_neg = mean(conv_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the convolutional feature is: '
Z_factor

sigma_pos_avg = nanstd(conv_pos_avg); sigma_neg_avg = nanstd(conv_neg_avg);
mu_pos_avg = nanmean(conv_pos_avg); mu_neg_avg = nanmean(conv_neg_avg);
Z_factor = 1 - 3*(sigma_pos_avg + sigma_neg_avg) / abs(mu_pos_avg - mu_neg_avg);
'The Z-factor calculated from the convolutional feature averaged across three wells is: '
Z_factor

sigma_pos = std(neuroncount_pos); sigma_neg = std(neuroncount_neg);
mu_pos = mean(neuroncount_pos); mu_neg = mean(neuroncount_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the neuron count feature is: '
Z_factor

sigma_pos = std(int_pos); sigma_neg = std(int_neg);
mu_pos = mean(int_pos); mu_neg = mean(int_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the total intensity feature is: '
Z_factor

sigma_pos = std(pos_pos); sigma_neg = std(pos_neg);
mu_pos = mean(pos_pos); mu_neg = mean(pos_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the position feature is: '
Z_factor

%SVM training
positives = [neuroncount_pos' conv_pos' ones(length(conv_pos),1)];
negatives = [neuroncount_neg' conv_neg' zeros(length(conv_neg),1)];
figure();SVMStruct = svmtrain([positives(:,1:2); negatives(:,1:2)],[positives(:,3); negatives(:,3)],'ShowPlot','true');
title('Two Features');

%SVM training
positives = [neuroncount_pos' conv_pos' int_pos' pos_pos' ones(length(conv_pos),1)];
negatives = [neuroncount_neg' conv_neg' int_neg' pos_neg' zeros(length(conv_neg),1)];
figure();SVMStruct = svmtrain([positives(:,1:4); negatives(:,1:4)],[positives(:,5); negatives(:,5)]);
title('Four Features');

% neuroncount_pos_norm = neuroncount_pos ./ std(neuroncount_pos);
% neuroncount_neg_norm = neuroncount_neg ./ std(neuroncount_neg);
% conv_pos_norm = conv_pos ./ std(conv_pos);
% conv_neg_norm = conv_neg ./ std(conv_neg);
% 
% %Create a feature that is the linear sum of the normalized neuroncounts and
% %convolutional measures
% feat_pos = neuroncount_pos_norm + conv_pos_norm;
% feat_neg = neuroncount_neg_norm + conv_neg_norm;
% 
% %Now plot the results!
% figure();plot(1:numel(feat_pos), feat_pos, 'b.', 1:numel(feat_neg), feat_neg, 'r.');
% title('Positive and Negative Controls, Normalized Features');xlabel('Observation');
% ylabel('Summed Features (a.u.)');legend('DMSO', '9mM Mtz', 'Location','Best');

%% Useful functions
function [fnames_pos, neuroncount_pos, conv_pos, int_pos, pos_pos, ...
    fnames_neg, neuroncount_neg, conv_neg, int_neg, pos_neg] = ...
    parseControls(fnames, neuroncount, conv, int, pos, option)
%This function will separate the given filenames into positive and negative
%controls (where positives are between columns 1-6 and negative are between
%columns 7-12
fnames_pos = []; neuroncount_pos = []; conv_pos = []; int_pos = []; pos_pos = [];
fnames_neg = []; neuroncount_neg = []; conv_neg = []; int_neg = []; pos_neg = [];
for i = 1:numel(fnames)
    if option == 1
        col = str2num(fnames{i}(5:end));
    else
        [~,col,~,plate] = parse_wellname(fnames{i});
    end
    if col > 6
        fnames_neg = [fnames_neg, fnames(i)];
        neuroncount_neg = [neuroncount_neg neuroncount(i)];
        conv_neg = [conv_neg conv(i)];
        int_neg = [int_neg int(i)];
        pos_neg = [pos_neg pos(i)];
    else
        fnames_pos = [fnames_pos, fnames(i)];
        neuroncount_pos = [neuroncount_pos neuroncount(i)];
        conv_pos = [conv_pos conv(i)];
        int_pos = [int_pos int(i)];
        pos_pos = [pos_pos pos(i)];
    end
end

function [fnames, neuroncount, conv, int, pos] = process_xls(num,txt,raw)
%This function will search the xls file for columns with the appropriate
%data and return the data in array form
for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0 && isempty(strfind(txt{1,i},'BF')) == 1
        col_fname = i;
    elseif isempty(strfind(txt{1,i},'Count_Neurons_inner')) == 0 
        col_neuroncount = i;
    elseif isempty(strfind(txt{1,i},'ghettoconv')) == 0
        col_conv = i;
    elseif isempty(strfind(txt{1,i},'TotalIntensity_inner')) == 0
        col_int = i;
    elseif isempty(strfind(txt{1,i},'position_measure')) == 0
        col_pos = i;
    end
end

try
    fnames = txt(2:end,col_fname);
    neuroncount = num(:,col_neuroncount);
    conv = num(:,col_conv);
    int = num(:,col_int);
    pos = num(:,col_pos);
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end

function [wellname_array, well_array, well_array_conv, well_array_int, well_array_pos] = assignReplicatePlates(fnames, neuroncount, conv, int, pos)
%Now we wish to create a 96 x m array where the rows represent the wells in
%the plate and m represents the replicate plate data (e.g. when you have 3
%replicate plates and wish to average the data across wells)
date_list = cell(length(fnames),1);
plate_list = cell(length(fnames),1);
for i = 1:length(fnames)
    [~,~,date_list{i},plate_list{i}] = parse_wellname(fnames{i});
end
unique_dates = unique(date_list);unique_plates = unique(plate_list);
plate_aggregate = cell(length(unique_dates)*length(unique_plates),1);
plate_conv = plate_aggregate;
plate_label = plate_aggregate;
plate_int = plate_aggregate;
plate_pos = plate_aggregate;
idx = 1;

for i = 1:length(unique_dates)
    for j = 1:length(unique_plates)
        plate_aggregate{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,neuroncount);
        plate_conv{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,conv);
        plate_int{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,int);
        plate_pos{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,pos);
        idx = idx + 1;
    end
end

well_array = nan(96,numel(plate_aggregate));
well_array_conv = well_array;
well_array_int = well_array;
well_array_pos = well_array;
wellname_array = cell(96, numel(plate_aggregate));
well_letter = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
well_number = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'};

for i = 1:numel(plate_aggregate)
    idx = 1;
    for j = 1:size(plate_aggregate{i},1)
        for k = 1:size(plate_aggregate{i},2)
            %For each well check if it is a positive control, negative
            %control, or an experimental well. Place into appropriate
            %array.
            well_array(idx,i) = plate_aggregate{i}(j,k);
            well_array_conv(idx,i) = plate_conv{i}(j,k);
            well_array_int(idx,i) = plate_int{i}(j,k);
            well_array_pos(idx,i) = plate_pos{i}(j,k);
            wellname_array{idx,i} = [well_letter{j} ' - ' well_number{k}];
            idx = idx + 1;
        end
    end
end