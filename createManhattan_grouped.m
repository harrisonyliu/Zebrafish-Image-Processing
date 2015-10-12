function createManhattan_grouped(aggregateData)
%Use this function when you have wells that need to be grouped together for
%some reason (e.g. multiple wells are replicates of each other vs. when
%you're doing a screen and each well is a singleton). This function will
%create a bar chart with error bars that represent the averaged data from
%each of the group data

features = fieldnames(aggregateData);
groups = fieldnames(eval(['aggregateData.' features{1}]));
for i = 1:numel(features)
    bar_data = zeros(1,numel(groups));
    bar_std = bar_data;
    num_obsv = bar_data;
    for j = 1:numel(groups)
        eval(['temp_data = aggregateData.' features{i} '.' groups{j} ';']);
        temp_data_reshaped = reshape(temp_data,1,numel(temp_data));
        bar_data(j) = nanmean(temp_data_reshaped);
        bar_std(j) = nanstd(temp_data_reshaped);
        %Find out how many observations there were
        num_obsv = numel(temp_data_reshaped) - sum(isnan(temp_data_reshaped));
    end
    CI = bar_data - 1.96 * (bar_std ./ sqrt(num_obsv));
    figure();bar(bar_data,'g','EdgeColor','w');hold on;
    title(features{i});
    set(gca,'XTickLabel',groups)
    xticklabel_rotate;
    errorbar(1:numel(groups),bar_data,CI,'.');
end

end

