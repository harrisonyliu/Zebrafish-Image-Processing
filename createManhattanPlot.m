function createManhattanPlot(positive_ctrls, negative_ctrls, well_array, wellname_array, chart_title, option)
%Will create a manhattan plot from cell data passed to it. Option 0 if you
%want individual well data, option 1 if you wish to average data across
%wells

if option == 1
    positive_ctrls = nanmean(positive_ctrls,2);
    negative_ctrls = nanmean(negative_ctrls,2);
    well_array = nanmean(well_array,2);
end

figure();hold on;title([chart_title ' Manhattan Plot']);
ylabel('Convolutional Measure');xlabel('Observation');
%First plot the positive controls
placeholder = [];color = 'ymcbk';coloridx = 1;

for i = 1:size(positive_ctrls,1)
    bar([placeholder positive_ctrls(i,:)],'g', 'EdgeColor','w');
    placeholder = [placeholder zeros(1,size(positive_ctrls,2))];
end
%Now plot the negative controls
for i = 1:size(negative_ctrls,1)
    bar([placeholder negative_ctrls(i,:)],'r', 'EdgeColor','w');
    placeholder = [placeholder zeros(1,size(negative_ctrls,2))];
end
%Now plot everything else!
for i = 1:size(well_array,1)
    bar([placeholder well_array(i,:)],color(coloridx), 'EdgeColor','w');
    if coloridx == length(color)
        coloridx = 1;
    else
        coloridx = coloridx + 1;
    end
    placeholder = [placeholder zeros(1,size(well_array,2))];
end

%Calculate and display neuron count cutoffs (3 standard deviations above
%the mean neuron count of the negative controls)
negative_mean = nanmean(negative_ctrls,2);
negative_std = nanstd(negative_mean);
cutoff = nanmean(negative_mean) + 3*negative_std;
% plot([0 length(placeholder)],[cutoff cutoff], 'r--');hold off;

%Now add well labels
well_labels = wellname_array;
if option == 1
    set(gca,'XTick',1:length(placeholder));
    set(gca,'XTickLabel',well_labels);
    xticklabel_rotate;
else
    set(gca,'XTick',3:6:length(placeholder)-1);
    set(gca,'XTickLabel',well_labels);
end
% set(gca,'XTick',1:length(placeholder));
% set(gca,'XTickLabel',well_labels);