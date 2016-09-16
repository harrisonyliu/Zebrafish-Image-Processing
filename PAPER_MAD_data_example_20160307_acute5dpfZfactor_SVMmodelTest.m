close all
clear all

filename = fullfile('F:\CellProfiler Output\20160307_acute5dpfZfactor_relaxedthresh','20160307_acute5dpfZfactor_relaxedthreshImage.csv');
% [~, txt, ~]=xlsread(filename); 
% %Here we want to extract all the features except for the filename
% features = {txt{1,:}};col_notdata = [];
% for i = 1:size(txt,2)
%     if strfind(features{i},'FileName') == 1
%         col_notdata = [col_notdata i];
%     elseif strfind(features{i},'ImageNumber') == 1
%         col_notdata = [col_notdata i];
%     end
% end
% features(col_notdata) = [];
% ghettoconv_col = 69;


%First rip all the relevant data from the excel file for each features
% plate_struct = separateReplicatePlates(filename,'Intensity_MADIntensity_eyes_removed_cropped_Neurons',...
%     'Intensity_MeanIntensity_position_measure',...
%     'StDev_Neurons_Intensity_IntegratedIntensity_inner_brain',...
%     'StDev_Neurons_Intensity_MaxIntensityEdge_inner_brain',...
%     'Intensity_TotalIntensity_ghettoconv');

% plate_struct = separateReplicatePlates(filename,'Intensity_MADIntensity_eyes_removed_cropped_Neurons',...
%     'Intensity_TotalIntensity_ghettoconv');
plate_struct = separateReplicatePlates(filename,'Intensity_MADIntensity_eyes_removed_cropped_Neurons',...
    'Intensity_TotalIntensity_ghettoconv', 'Intensity_TotalIntensity_eyes_removed_cropped_Neurons');

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

%% Here I test out the metascore classification accuracy

%First step is to group the data into positive and negative controls
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

%Now let's start creating the data set that we will use to do the t-tests
%on. In general, each row is a different observation and each column
%represents a different feature. We will create two arrays. One for the
%positive controls and the other for the negative controls.
stringname = ['aggregateData.' features{1} '.posctrl;'];
numctrls = numel(eval(stringname)); %Note this assumes that the number of positive and negative controls are equal
pos_ctrl_temp = zeros(numctrls,numel(features));
neg_ctrl_temp = zeros(numctrls,numel(features));

for i = 1:numel(features)
    %First get hold of the positive control data belonging to the current
    %features and reshape it to a Nx1 array, where N is the number of
    %observations
    eval(['temp = aggregateData.' features{i} '.posctrl;']);
    temp = reshape(temp,numel(temp),1);
    pos_ctrl_temp(:,i) = temp;
    
    eval(['temp = aggregateData.' features{i} '.negctrl;']);
    temp = reshape(temp,numel(temp),1);
    neg_ctrl_temp(:,i) = temp;
end

pos_ctrl_data = pos_ctrl_temp(~any(isnan(pos_ctrl_temp(:,1)),2),:);
neg_ctrl_data = neg_ctrl_temp(~any(isnan(neg_ctrl_temp(:,1)),2),:);
data = [pos_ctrl_data; neg_ctrl_data];
pos_size = size(pos_ctrl_data,1);
groups = zeros(size(data,1),1); groups(1:pos_size) = 1;

load('SVM_model_all.mat');
pred = svmclassify(svmModel, data, 'Showplot',false);
num_incorrect = pos_size - sum(pred(1:pos_size)) + sum(pred(pos_size + 1:end)); 
total_obsv = size(data,1);
accuracy = 1 - num_incorrect/total_obsv

%% Calculating Z'-factor of SVM model
metascore = zeros(size(data,2),1);
shift = svmModel.ScaleData.shift; scale = svmModel.ScaleData.scaleFactor;
shift = repmat(shift,size(data,1),1);
scale = repmat(scale,size(data,1),1);
x = (data + shift) .* scale;
for i = 1:size(data,1)
    metascore(i) = dot(w,x(i,:))+b;
end
pos_idx = find(groups==1);
neg_idx = find(groups==0);
aggregateData.metascore.posctrl = metascore(pos_idx);
aggregateData.metascore.negctrl = metascore(neg_idx);
features{end+1} = 'metascore';
mean_pos = mean(metascore(pos_idx)); std_pos = std(metascore(pos_idx));
mean_neg = mean(metascore(neg_idx)); std_neg = std(metascore(neg_idx));
Z_score = 1 - 3*(std_pos + std_neg)/abs(mean_pos - mean_neg)

%% Here let's see how increasing the number of samples to average will affect the overall Z'-factor
numgroups = 8;
simulated_zprime = zeros(numel(features),numgroups);
simulated_avg_pos = simulated_zprime; simulated_avg_neg = simulated_zprime;
simulated_avg_pos = simulated_zprime; simulated_avg_neg = simulated_zprime;
for i = 1:numel(features)
    Z_array = zeros(500,numgroups);
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
    simulated_zprime(i,:) = mean(Z_array);
    simulated_avg_pos(i,:) = mean(pos_avg_array);simulated_avg_neg(i,:) = mean(neg_avg_array);
    simulated_std_pos(i,:) = mean(pos_std_array);simulated_std_neg(i,:) = mean(neg_std_array);
    figure(); plot(mean(Z_array),'bo-');
    title(['Z-factor for ' features{i} ' as sample number is increased']);
    xlabel('Number of averaged larvae');ylabel('Z-factor');
end

simulated_zprime(1,3)
1-3*(simulated_std_pos(1,3)+simulated_std_neg(1,3))/(simulated_avg_pos(1,3)-simulated_avg_neg(1,3))
figure();plot(simulated_zprime(1,:),'bo-'); hold on;
plot(simulated_zprime(end,:),'r*-');
title(['Z-factor for ' features{i} ' as sample number is increased']);
xlabel('Number of averaged larvae');ylabel('Z-factor');
legend('MAD feature','Multiparametric feature','Location','best');

%% ROC curve generation
thresh_idx = 1:.1:6;
FP = zeros(size(simulated_avg_pos,2),length(thresh_idx));
FN = FP;
for i = 1:size(simulated_avg_pos,2)
    for j = 1:length(thresh_idx)
        thresh = simulated_avg_neg(1,i) + thresh_idx(j)*simulated_std_neg(1,i);
        FP(i,j) = 1-normcdf(thresh_idx(j),0,1);
        FN(i,j) = normcdf((thresh - simulated_avg_pos(1,i))/simulated_std_pos(1,i),0,1);
    end
end

%Now to plot
figure();hold on;
for i = 1:5
    plot(FP(i,:),1-FN(i,:),'-');
end
