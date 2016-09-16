function res = calcSSMD(aggregateData,attributeName,plateQuadrant)
%Note: all formulas are taken from the paper: "Illustration of SSMD,
%zScore, SSMD*, z* Score, and t Statistic for Hit Selection in RNAi
%High-Throughput Screens" by Xiaohua Douglas Zhang (2011) Journal of
%Biomolecular Screening. This function will calculate the SSMD and brain
%health score (log2 of convolutional score) and save the well each data
%came from and how many observations there were. Everything is normalized
%by the negative controls, allowing for across-plate comparisons. The
%output of this function can be passed to addToDatabase.m, a function that
%will save the output to an evergrowing Excel file that tracks the progress
%of our screen.

%These will be the categories in the final Excel file
headers = {'Plate Quadrant','Tag','Cmpd_ID','Date','SSMD','Brain Health Score','NumObs'};
temp = eval(['aggregateData.' attributeName ';']);
wellNames = fieldnames(temp);
numWells = numel(wellNames);

%First thing's first: let's grab the appropriate data and assign it into
%the cell array that we will be creating.
data = cell(numWells+1, numel(headers)); %This will be a cell array containing our data
data(1,:) = headers;

%Now let's extract out the data
for i = 1:numWells
    curr_wellName = wellNames{i};
    curr_wellData = eval(['temp.' curr_wellName ';']);
    curr_wellData_reshaped = reshape(curr_wellData,numel(curr_wellData),1);
    curr_wellData_reshaped(curr_wellData_reshaped==0) = NaN;
    curr_wellData_log = log2(curr_wellData_reshaped);
    temp_mean = nanmean(curr_wellData_log);
    temp_std = nanstd(curr_wellData_log);
    %To start off, let's find out how many samples
    %were able to capture.
    numMissing = sum(isnan(curr_wellData_reshaped)); %How many fish we are missing data from
    numObs = numel(curr_wellData_reshaped) - numMissing; %How many total observations we have.
    if strcmp(curr_wellName, 'posctrl') == 1
        tag = 'DMSO';
        pos_mean = temp_mean;
        pos_std = temp_std;
        ssmd_score = NaN;
    elseif strcmp(curr_wellName, 'negctrl') == 1
        tag = 'Mtz';
        neg_mean = temp_mean;
        neg_std = temp_std;
        ssmd_score = NaN;
        numObs_neg = numObs; %How many total observations we have.
    else
        tag = curr_wellName;
        %Here's the tricky part. We need to check how many examples we see of
        %each compound. If we see only one or fewer examples we cannot get a
        %good estimate of the standard deviation needed to calculate the SSMD
        %score, so therefore we will need to substitute the std of the negative
        %controls to compensate.
        if numObs == 0
            ssmd_score = NaN;
        elseif numObs == 1
            %Here we have to use the SSMD calculation assuming no replicates
            %since we are only working with one sample. SSMD based on the UMVUE
            %(nonrobust version)
            temp_std = neg_std;
            avg_deviation = mean(curr_wellData_log - neg_mean);
            k = 2*(gamma((numObs_neg-1)/2)/gamma((numObs_neg-2)/2))^2;
            ssmd_score = (temp_mean - neg_mean)/(neg_std*sqrt(2/k*(numObs_neg-1)));
        elseif numObs == 2
            %Two observations is not enough to make a good conclusion, but
            %we'll do the best we can. We'll take the additional
            %observations into account by averaging the scores and modify
            %the standard deviation by pooling it with a 50% weight with
            %the Mtz controls.
            temp_std = sqrt(0.5*neg_std^2 + 0.5*temp_std^2);
            avg_deviation = nanmean(curr_wellData_log - neg_mean);
            k = 2*(gamma((numObs_neg-1+2)/2)/gamma((numObs_neg-2+2)/2))^2;
            ssmd_score = (temp_mean - neg_mean)/(temp_std*sqrt(2/k*(numObs_neg-1+2)));
        else
            %This is the formula for SSMD based on UMVUE
            avg_deviation = nanmean(curr_wellData_log - neg_mean);
            ssmd_score = (gamma((numObs-1)/2)/gamma((numObs-2)/2))*...
                sqrt(2/(numObs-1))*avg_deviation/nanstd(curr_wellData_log);
        end
    end
    %headers = {'Plate Quadrant','Tag','Cmpd_ID','Date','SSMD','Brain Health Score','NumObs'};
    %Finally we fill out the data cell array
    data{i+1,1} = plateQuadrant;  data{i+1,2} = tag; data{i+1,3} = [plateQuadrant '-' tag];
    data{i+1,4} = date; data{i+1,5} = ssmd_score; data{i+1,6} = temp_mean;
    data{i+1,7} = numObs;
    res = data;
end
