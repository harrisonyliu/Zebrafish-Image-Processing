close all
clear all

%% Plate 1

filename = fullfile('F:\CellProfiler Output\20160324_zfactor_reanalysis_datafrom20151112','20160324_zfactor_reanalysisImage.csv');

%First rip all the relevant data from the excel file for each features
plate_struct = separateReplicatePlates(filename,'Intensity_TotalIntensity_ghettoconv');

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

createManhattan_grouped(aggregateData)

for i = 1:numel(features)
    eval(['mean_pos = nanmean(aggregateData.' features{i} '.' groups{1} ');'])
    eval(['mean_neg = nanmean(aggregateData.' features{i} '.' groups{2} ');'])
    eval(['std_pos = nanstd(aggregateData.' features{i} '.' groups{1} ');'])
    eval(['std_neg = nanstd(aggregateData.' features{i} '.' groups{2} ');'])
    zfactor = 1 - 3*(std_pos + std_neg) / (abs(mean_pos - mean_neg));
    [features{i} ' = ' num2str(zfactor)]
end

%% Here let's see how increasing the number of samples to average will affect the overall Z'-factor
for i = 1:numel(features)
    Z_array = zeros(100,10);
    pos_avg_array = Z_array; neg_avg_array = Z_array;
    pos_std_array = Z_array; neg_std_array = Z_array;
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
            pos_avg_array(k,j) = mean_pos; neg_avg_array(k,j) = mean_neg; 
            pos_std_array(k,j) = std_pos; neg_std_array(k,j) = std_neg; 
        end
    end
    figure(); plot(mean(Z_array),'bo-');
    title(['Z-factor for ' features{i} ' as sample number is increased']);
    xlabel('Number of averaged larvae');ylabel('Z-factor');
end

%% Here let's see the ROC curve - how likely we are to see FP/TP using our particular assay
%The point here is to see at what scale our particular assay can perform at
%( e.g. can be potentially scaled up to a 10,000 compound screen)

pos_data = aggregateData.Intensity_TotalIntensity_ghettoconv.posctrl;
pos_data(isnan(pos_data)) = [];
neg_data = aggregateData.Intensity_TotalIntensity_ghettoconv.negctrl;
neg_data(isnan(neg_data)) = [];
num_pos = floor(numel(pos_data)/3); num_neg = floor(numel(neg_data)/3);
pos_idx = randperm(numel(pos_data)); neg_idx = randperm(numel(neg_data));
pos_data = pos_data(pos_idx(1:3*num_pos)); neg_data = neg_data(neg_idx(1:3*num_neg));
pos_data = reshape(pos_data,3,num_pos); neg_data = reshape(neg_data,3,num_neg);
pos_avg = nanmean(pos_data); pos_std = nanstd(pos_avg);
neg_avg = nanmean(neg_data); neg_std = nanstd(neg_avg);
thresh_range = .1:.1:15;
TP = zeros(1,numel(thresh_range)); FP = TP;

for i = 1:numel(thresh_range)
    thresh = thresh_range(i) * neg_std + mean(neg_avg);
    TP(i) = sum(pos_avg > thresh) / numel(pos_avg);
    FP(i) = sum(neg_avg > thresh) / numel(neg_avg);
end

figure();plot(FP,TP,'b.-');title('ROC Curve');
xlabel('FP rate');ylabel('TP rate');
    