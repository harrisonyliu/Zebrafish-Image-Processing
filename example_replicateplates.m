%This file is a demo script showing how to go from starting off with an
%Excel file with raw data, to an 96xN array where rows represent individual
%wells and the Nth column is the replicates

filename = 'C:\Users\harri_000\20150911MassValidation\20150911MassValidationImage.csv';
plate_struct = separateReplicatePlates(filename,'Count_Neurons_inner','ghettoconv','TotalIntensity_inner','position_measure');
features = fieldnames(plate_struct);
%Go through each feature and group replicate data together
for i = 1:length(features)
    eval(['[grouped_data.' features{i} ', grouped_data.wellname] = groupReplicateData(plate_struct.' features{i} ');']);
end

%% This section is specific for the data from 2015.09.11

well_letter = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
well_number = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'};
wellname_array = cell(8, 5);

for row = 1:8
    for col = 1:12
        wellname_array{row,col} = [well_letter{row} ' - ' well_number{col}];
    end
end

%Now let's rotate and align the data properly from each plate so we end up
%with six replicates per compound
for idx = 1:length(features)
    eval(['temp_data = plate_struct.' features{idx} ';']);
    array_a = cell(1,numel(temp_data));
    array_b = array_a;
    pos_controls = zeros(6,numel(temp_data));
    neg_controls = zeros(8,numel(temp_data));
    for i = 1:numel(temp_data)
        temp_array = temp_data{i};
        %First let's deal with the control data
        pos_controls(:,i) = temp_array(1:6,1);
        wellname_array_input = wellname_array(1:6,1);
        neg_controls(:,i) = temp_array(:,12);
        wellname_array_input = {wellname_array_input{:} wellname_array{:,12}};
        %Now we split the acquired data in half and rotate the right half
        %by 180 degrees
        array_a{i} = temp_array(:,2:6);
        wellname_array_input = {wellname_array_input{:} wellname_array{:,2:6}};
        array_b_temp = temp_array(:,7:11);
        array_b{i} = rot90(rot90(array_b_temp));
    end
    final_array = {array_a{:,:} array_b{:,:}};
    ctrl_array = [pos_controls; neg_controls];
    offset = nanmean(nanmean(ctrl_array));scaling = nanstd(nanstd(ctrl_array));
    pos_ctrl_scaled = (pos_controls - offset) ./ scaling;
    neg_ctrl_scaled = (neg_controls - offset) ./ scaling;
    data_scaled = cell(1,numel(final_array));
    for i = 1:numel(final_array)
        temp = final_array{i};
        data_scaled{i} = (temp - offset) ./ scaling;
    end
    eval(['finaldata.' features{idx} '_scaled = data_scaled;']);
    eval(['finaldata_ctrls_pos.' features{idx} ' = pos_ctrl_scaled;']);
    eval(['finaldata_ctrls_neg.' features{idx} ' = neg_ctrl_scaled;']);
    eval(['finaldata_names.' features{idx} ' = wellname_array_input;']);
    [res, ~] = groupReplicateData(final_array);
    createManhattanPlot(pos_controls, neg_controls, res, wellname_array_input, ['Validation 2015.09.11 ' features{idx}],0);
%     xticklabel_rotate;
end

%Now let's create the meta-score (SVM)
fields = fieldnames(finaldata);
num_plates = length(eval(['finaldata.' fields{1}]));
w = [0.3425, -1.1846, -0.4643, -0.9152]; %Weight vectors from the SVM training
SVM_score = cell(1,num_plates);
for i = 1:num_plates
    temp_array = zeros([size(eval(['finaldata.' fields{1} '{1};'])), numel(fields)]);
    temp_result = temp_array(:,:,1);
    %Get each plate within the structure
    for j = 1:numel(fields)
        temp_array(:,:,j) = eval(['finaldata.' fields{j} '{' num2str(i) '}']);
    end
    %Now that we have the plate, combine each data point from each feature
    %into one using the scaling given to us by the SVM.
    for m = 1:size(temp_array,1)
        for n = 1:size(temp_array,2)
            temp_result(m,n) = dot(squeeze(temp_array(m,n,:)), w);
        end
    end
    SVM_score{i} = temp_result;
end

fields = fieldnames(finaldata_ctrls_pos);
num_plates = length(eval(['finaldata_ctrls_pos.' fields{1}]));
w = [0.3425, -1.1846, -0.4643, -0.9152]; %Weight vectors from the SVM training
SVM_score_ctrls = cell(1,num_plates);

for j = 1:numel(fields)
    temp_array_pos(:,:,j) = eval(['finaldata_ctrls_pos.' fields{j} ';']);
    temp_array_neg(:,:,j) = eval(['finaldata_ctrls_neg.' fields{j} ';']);
end
%Now that we have the plate, combine each data point from each feature
%into one using the scaling given to us by the SVM.
for m = 1:size(temp_array_pos,1)
    for n = 1:size(temp_array_pos,2)
        temp_result_pos(m,n) = dot(squeeze(temp_array_pos(m,n,:)), w);
    end
end
for m = 1:size(temp_array_neg,1)
    for n = 1:size(temp_array_neg,2)
        temp_result_neg(m,n) = dot(squeeze(temp_array_neg(m,n,:)), w);
    end
end
pos_controls = temp_result_pos;
neg_controls = temp_result_neg;
    
[res, ~] = groupReplicateData(SVM_score);
createManhattanPlot(pos_controls, neg_controls, res, wellname_array_input, ['Validation 2015.09.11 ' features{idx}],1);