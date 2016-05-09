%The purpose of this script is to distill X number of features into the
%minimum amount that will return good classification accuracy.

%We will proceed in the following steps: A) Group the data into positive
%and negative controls. B) Create a training and test data set C) Run a
%t-test filter analysis on all features using the training data set and
%select only the features that are statistically significant for future
%exploration. D) Apply sequential feature selection to narrow down the
%feature list further

close all
clear all

%First let's load the excel file
filename = fullfile('F:\CellProfiler Output\20160324_zfactor_reanalysis_datafrom20151112','20160324_zfactor_reanalysisImage.csv');
[~, txt, ~]=xlsread(filename); 
%Here we want to extract all the features except for the filename
features = {txt{1,:}};col_notdata = [];
for i = 1:size(txt,2)
    if strfind(features{i},'FileName') == 1
        col_notdata = [col_notdata i];
    elseif strfind(features{i},'ImageNumber') == 1
        col_notdata = [col_notdata i];
    end
end
features(col_notdata) = [];

%Then let's extract all the data from the file
plate_struct = separateReplicatePlates(filename,features{:});

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
pos_ctrl_temp = zeros(96,numel(features));
neg_ctrl_temp = zeros(96,numel(features));

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

%% The data set is now ready, the next step is to split the data into training and test sets
obs = [pos_ctrl_data; neg_ctrl_data];
grp = zeros(size(obs,1),1); grp(1:size(pos_ctrl_data,1)) = 1;

%We have 114 data points total. Let's use 34 for testing and 80 for
%training
holdoutCVP = cvpartition(grp,'holdout',34);
dataTrain = obs(holdoutCVP.training,:);
grpTrain = grp(holdoutCVP.training);

%Now run the t-tests
dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');

%And plot the results
ecdf(p);
xlabel('P value');
ylabel('CDF value')

%More plots
[~,featureIdxSortbyP] = sort(p,2); % sort the features by p-value
features(featureIdxSortbyP)

%% Principal component analysis
%103 of the features pass the alpha = 0.05 threshold, however, many may
%still be linearly dependent on each other (there is a lot of redundancy in
%the features). Thus we will start by running a PCA analysis to find the
%variables that are most independent from each other and further narrow
%down the list from 91 features to a smaller number.

pcainput = zscore(pos_ctrl_data(:,featureIdxSortbyP(1:103))); %Normalized data
[pc,score,latent,tsquare] = princomp(pcainput); %Note: PC is the coefficients on how to get the observation in PC space
%Score is the repesentation of each observation in principal component
%space. You can obtain score by calculating x * pc where x is the initial
%data/observations. (e.g. score = pcainput * pc) each pc is a column
firstpc = pc(:,1); firstpc_mag = firstpc .^ 2
'This is the amount of variance accounted for each principal component'
cumsum(latent(1:10))./sum(latent(1:10))
[~,featureIdxSortbyPC] = sort(firstpc_mag,'descend');
firstpc(featureIdxSortbyPC); %This is a list of feature importance sorted by principal component score
features(featureIdxSortbyP(featureIdxSortbyPC)); % This is a list of the features in importance from PCA

%% We just selected some features manually from the p-value sorted list, now let's put them to use
% chosen_feat = {'Intensity_TotalIntensity_eyes_removed_cropped_Neurons', ...
%     'Intensity_TotalIntensity_ghettoconv',...
%     'Mean_Neurons_Intensity_IntegratedIntensity_inner_brain',...
%     'Intensity_StdIntensity_ghettoconv',...
%     'Intensity_MADIntensity_inner_brain_Neurons',...
%     'Intensity_UpperQuartileIntensity_eyes_removed_cropped_Neurons',...
%     'Mean_Neurons_Intensity_StdIntensity_inner_brain',...
%     'Intensity_MedianIntensity_eyes_removed_cropped_Neurons',...
%     'StDev_Neurons_Location_CenterMassIntensity_Y_inner_brain',...
%     'Intensity_TotalArea_position_measure'};
chosen_feat = {'Intensity_TotalIntensity_ghettoconv', ...
    'Intensity_MADIntensity_eyes_removed_cropped_Neurons',...
    'Intensity_TotalIntensity_eyes_removed_cropped_Neurons'};
    
featvec = [];
for i = 1:numel(features)
    for j = 1:numel(chosen_feat)
        if isempty(strfind(chosen_feat{j},features{i})) == 0
            featvec = [featvec i];
        end
    end
end

% %% Forward feature selection
% classf = @(xtrain,ytrain,xtest,ytest) ...
%              sum(~strcmp(ytest,classify(xtest,xtrain,ytrain,'quadratic')));
% tenfoldCVP = cvpartition(grpTrain,'kfold',10);
% % fs1 = featureIdxSortbyP(1:40);
% fs1 = featvec;
% fsLocal = sequentialfs(classf,dataTrain(:,fs1),grpTrain,'cv',tenfoldCVP);
% fs1(fsLocal)
% 
% [fsCVfor50,historyCV] = sequentialfs(classf,dataTrain(:,fs1),grpTrain,...
%     'cv',tenfoldCVP,'Nfeatures',10);
% plot(historyCV.Crit,'o');
% xlabel('Number of Features');
% ylabel('CV MCE');
% title('Forward Sequential Feature Selection with cross-validation');


%% SVM training
k=10;
meas = [pos_ctrl_data(:,featvec); neg_ctrl_data(:,featvec)];
groups = grp;
% meas = [positives(:,1:4); negatives(:,1:4)];
% groups = [positives(:,5); negatives(:,5)];
cvFolds = crossvalind('Kfold', groups, k);   %# get indices of 10-fold CV
cp = classperf(groups);                      %# init performance tracker

for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    svmModel = svmtrain(meas(trainIdx,:), groups(trainIdx));

    %# test using test instances
    pred = svmclassify(svmModel, meas(testIdx,:), 'Showplot',false);

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
end

%# get accuracy
cp.CorrectRate

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
% cp.CountingMatrix

%% Now to actually fit the SVM data now that we've narrowed it down to the 10 most useful features
% SVMModel = svmtrain(meas(:,6:7),groups,'ShowPlot',true);title('Matlab in-built result');
[w,b,x] = svm_param_calc(meas,groups);

% SVMModel = svmtrain(meas(:,1:2),groups,'ShowPlot',true);

%% Recursive feature elimination

%We will begin with the entire unbiased list of possible features. We will
%then train a SVM, find the feature with the lowest weight and then remove
%it from the list. We will then repeat until all the features have been
%removed. The first feature in the r vector is thus the best predictive
%feature
s = 1:numel(features);
r = [];
data = [pos_ctrl_data; neg_ctrl_data];
while isempty(s) == 0
    train_data = data(:,s);
    [w,b] = svm_param_calc(train_data,groups);
    c = w.^2;
    idx = find(c==min(c));
    r = [s(idx) r]; 
    s(idx) = [];
end
r_curated = r;
% r_curated(5:7) = [];
% rfe_featlist = [r_curated(1:4) 69]; %This includes ghettoconv
rfe_featlist = [11 69]; %This includes ghettoconv, MAD, and total neuron intensity
new_data = data(:,rfe_featlist); meas = new_data; %Using recursive
% meas = data; %Using recursive
% feature list
% new_data = data(:,featvec); meas = new_data; %Using chosen feature list
k=10;
cvFolds = crossvalind('Kfold', groups, k);   %# get indices of 10-fold CV
cp = classperf(groups);                      %# init performance tracker

for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    svmModel = svmtrain(meas(trainIdx,:), groups(trainIdx));

    %# test using test instances
    pred = svmclassify(svmModel, meas(testIdx,:), 'Showplot',false);

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
end

%# get accuracy
cp.CorrectRate

%% Calculation of Z-score
[w,b,x] = svm_param_calc(meas,groups);
metascore = zeros(size(meas,2),1);
for i = 1:size(meas,1)
    metascore(i) = dot(w,x(i,:))+b;
end
pos_idx = find(groups==1);
neg_idx = find(groups==0);
mean_pos = mean(metascore(pos_idx)); std_pos = std(metascore(pos_idx));
mean_neg = mean(metascore(neg_idx)); std_neg = std(metascore(neg_idx));
Z_score = 1 - 3*(std_pos + std_neg)/abs(mean_pos - mean_neg)

% Saving the features
save('SVM_model_all','w','b','x','svmModel');