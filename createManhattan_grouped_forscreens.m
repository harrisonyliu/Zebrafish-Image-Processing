function createManhattan_grouped(aggregateData)
%Use this function when you have wells that need to be grouped together for
%some reason (e.g. multiple wells are replicates of each other vs. when
%you're doing a screen and each well is a singleton). This function will
%create a bar chart with error bars that represent the averaged data from
%each of the group data. Note: This is the normal createManhattan_grouped
%function, but with some of the display elements optimized for showing
%96-well screening plate data.

features = fieldnames(aggregateData);
groups = fieldnames(eval(['aggregateData.' features{1}]));
for i = 1:numel(features)
    colors = 'grbcmyk';color_idx = 1;
    bar_data = zeros(1,numel(groups));
    bar_std = bar_data;
    num_obsv = bar_data;
    for j = 1:numel(groups)
        eval(['temp_data = aggregateData.' features{i} '.' groups{j} ';']);
        temp_data_reshaped = reshape(temp_data,1,numel(temp_data));
        bar_data(j) = nanmean(temp_data_reshaped);
        bar_std(j) = nanstd(temp_data_reshaped);
        %Find out how many observations there were
        num_obsv(j) = numel(temp_data_reshaped) - sum(isnan(temp_data_reshaped));
        y_amt = bar_data(2) + 3 * bar_std(2);
    end
    %     CI = 1.96 * (bar_std ./ sqrt(num_obsv)); %95% CI
    CI = bar_std ./ sqrt(num_obsv); %SEM
%     CI = bar_std; %standard dev
    figure();hold on;
    for k = 1:numel(groups)
        bar(k,bar_data(k),colors(color_idx),'EdgeColor','w');
        if color_idx == numel(colors)
            color_idx = 1;
        else
            color_idx = color_idx + 1;
        end
    end
    title(features{i});
    groups_display = strrep(groups,'_','');
    xticklabel_rotate(1:numel(groups),90,groups_display,'Fontsize',7);
    %Plot individual data observations
    for j = 1:numel(groups)
        eval(['temp_data = aggregateData.' features{i} '.' groups{j} ';']);
        temp_data_reshaped = reshape(temp_data,1,numel(temp_data));
        plot(j*ones(1,numel(temp_data_reshaped)),temp_data_reshaped,'o','Color', [0.5 0.5 0],'MarkerSize',3);
    end
    %Now add error bars
    errorbar(1:numel(groups),bar_data,CI,'.','LineWidth',0.5);
    cutoff = 3*CI(2) + bar_data(2); %3 SEM above negative control mean
    plot([1 numel(groups)], [cutoff cutoff],'r--');
    %     hold on;plot([1 numel(bar_data)],[y_amt y_amt],'r--');
    %     hold off;
    if strcmp(features{i},'Intensity_TotalIntensity_ghettoconv') == 1
        ylim([0,3]); %Set some concrete limits for the convolutional measure for post-screen comparisons
    end
end

end

