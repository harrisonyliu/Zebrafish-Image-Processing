function [fnames, neuroncount, conv, fnames_pos, neuroncount_pos, conv_pos, fnames_neg, neuroncount_neg, conv_neg] = Zfactor_script

%First locate the Excel file that CellProfiler spits out (use the one with
%the suffix "Image"
[filename, pathname, filterindex] = uigetfile('*.csv');
fname = fullfile(pathname,filename);
[num, txt, raw]=xlsread(fname);
[fnames, neuroncount, conv] = process_xls(num,txt,raw);

[wellname_array, well_array, well_array_conv] = assignReplicatePlates(fnames, neuroncount, conv);
wellname_array = wellname_array(:,1);
well_array_mean = nanmean(well_array,2);
well_array_conv_mean = nanmean(well_array_conv,2);
[fnames_pos_avg, neuroncount_pos_avg, conv_pos_avg, fnames_neg_avg, neuroncount_neg_avg, conv_neg_avg] = parseControls(wellname_array, well_array_mean, well_array_conv_mean,1);
[fnames_pos, neuroncount_pos, conv_pos, fnames_neg, neuroncount_neg, conv_neg] = parseControls(fnames, neuroncount, conv,0);

%Plotting the results
figure();plot(neuroncount_pos, conv_pos, 'b.', neuroncount_neg, conv_neg, 'r.');
title('Positive and Negative Controls, Features Combined');xlabel('Neuron Count');
ylabel('Convolution Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

%Averaged version
figure();plot(neuroncount_pos_avg, conv_pos_avg, 'b.', neuroncount_neg_avg, conv_neg_avg, 'r.');
title('Positive and Negative Controls, Features Combined and Averaged');xlabel('Neuron Count');
ylabel('Convolution Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');

%Looking at differences between neuron counts
figure();bar(neuroncount_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(neuroncount_pos)) neuroncount_neg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Neuron Counts Only');xlabel('Fish Number');
ylabel('Neuron Count');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;

%Now look at difference between the convolutional measure
figure();bar(conv_pos,'FaceColor','b','EdgeColor','w');hold on;bar([zeros(1,length(conv_pos)) conv_neg],'FaceColor','r','EdgeColor','w');
title('Positive and Negative Controls, Convolutional Measure Only');xlabel('Fish Number');
ylabel('Convolutional Measure (au)');legend('DMSO', '9mM Mtz', 'Location','Best');axis image;

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

%Calculating Z-factors
sigma_pos = std(conv_pos); sigma_neg = std(conv_neg);
mu_pos = mean(conv_pos); mu_neg = mean(conv_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the convolutional feature is: '
Z_factor

sigma_pos_avg = std(conv_pos_avg); sigma_neg_avg = std(conv_neg_avg);
mu_pos_avg = mean(conv_pos_avg); mu_neg_avg = mean(conv_neg_avg);
Z_factor = 1 - 3*(sigma_pos_avg + sigma_neg_avg) / abs(mu_pos_avg - mu_neg_avg);
'The Z-factor calculated from the convolutional feature averaged across three wells is: '
Z_factor

sigma_pos = std(neuroncount_pos); sigma_neg = std(neuroncount_neg);
mu_pos = mean(neuroncount_pos); mu_neg = mean(neuroncount_neg);
Z_factor = 1 - 3*(sigma_pos + sigma_neg) / abs(mu_pos - mu_neg);
'The Z-factor calculated from the neuron count feature is: '
Z_factor

%SVM training
positives = [neuroncount_pos' conv_pos' ones(length(conv_pos),1)];
negatives = [neuroncount_neg' conv_neg' zeros(length(conv_neg),1)];
figure();SVMStruct = svmtrain([positives(:,1:2); negatives(:,1:2)],[positives(:,3); negatives(:,3)],'ShowPlot','true');

%Normalize the data to zero mean and unit variance
% neuroncount_pos_norm = neuroncount_pos - mean(neuroncount_pos);
% neuroncount_pos_norm = neuroncount_pos_norm ./ std(neuroncount_pos_norm);
% neuroncount_neg_norm = neuroncount_neg - mean(neuroncount_neg);
% neuroncount_neg_norm = neuroncount_neg_norm ./ std(neuroncount_neg_norm);
% conv_pos_norm = conv_pos - mean(conv_pos);
% conv_pos_norm = conv_pos_norm ./ std(conv_pos_norm);
% conv_neg_norm = conv_neg - mean(conv_neg);
% conv_neg_norm = conv_neg_norm ./ std(conv_neg_norm);

neuroncount_pos_norm = neuroncount_pos ./ std(neuroncount_pos);
neuroncount_neg_norm = neuroncount_neg ./ std(neuroncount_neg);
conv_pos_norm = conv_pos ./ std(conv_pos);
conv_neg_norm = conv_neg ./ std(conv_neg);

%Create a feature that is the linear sum of the normalized neuroncounts and
%convolutional measures
feat_pos = neuroncount_pos_norm + conv_pos_norm;
feat_neg = neuroncount_neg_norm + conv_neg_norm;

%Now plot the results!
figure();plot(1:numel(feat_pos), feat_pos, 'b.', 1:numel(feat_neg), feat_neg, 'r.');
title('Positive and Negative Controls, Normalized Features');xlabel('Observation');
ylabel('Summed Features (a.u.)');legend('DMSO', '9mM Mtz', 'Location','Best');

function [fnames_pos, neuroncount_pos, conv_pos, fnames_neg, neuroncount_neg, conv_neg] = parseControls(fnames, neuroncount, conv,option)
fnames_pos = []; neuroncount_pos = []; conv_pos = [];
fnames_neg = []; neuroncount_neg = []; conv_neg = [];
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
    else
        fnames_pos = [fnames_pos, fnames(i)];
        neuroncount_pos = [neuroncount_pos neuroncount(i)];
        conv_pos = [conv_pos conv(i)];
    end
end

function [fnames, neuroncount, conv] = process_xls(num,txt,raw)
for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0 && isempty(strfind(txt{1,i},'BF')) == 1
        col_fname = i;
    elseif isempty(strfind(txt{1,i},'Count_Neurons_inner')) == 0 
        col_neuroncount = i;
    elseif isempty(strfind(txt{1,i},'ghettoconv')) == 0
        col_conv = i;
    end
end

try
    fnames = txt(2:end,col_fname);
    neuroncount = num(:,col_neuroncount);
    conv = num(:,col_conv);
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end

function [wellname_array, well_array, well_array_conv] = assignReplicatePlates(fnames, neuroncount, conv)
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
idx = 1;

for i = 1:length(unique_dates)
    for j = 1:length(unique_plates)
        plate_aggregate{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,neuroncount);
        plate_conv{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,conv);
        idx = idx + 1;
    end
end

well_array = nan(96,numel(plate_aggregate));
well_array_conv = well_array;
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
            wellname_array{idx,i} = [well_letter{j} ' - ' well_number{k}];
            idx = idx + 1;
        end
    end
end