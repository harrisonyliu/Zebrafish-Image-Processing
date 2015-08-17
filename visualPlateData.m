function visualPlateData(filename)

rows = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
columns = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'};
[fnames, neuroncount, conv] = parse_xls(filename);

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
        h1 = HeatMap(plate_aggregate{idx},'Colormap','cool','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h1.addTitle([unique_dates{i} ' ' unique_plates{j}]);
        idx = idx + 1;
    end
end

createManhattanPlot(plate_aggregate, 'Neuron Counts');
createManhattanPlot(plate_conv, 'Convolutional Feature');

function createManhattanPlot(plate_aggregate, chart_title)
well_array = nan(80,numel(plate_aggregate));
wellname_array = cell(80, numel(plate_aggregate));
wellname_pos = cell(8,numel(plate_aggregate));
wellname_neg = wellname_pos;
positive_ctrls = nan(8,numel(plate_aggregate)); 
negative_ctrls = positive_ctrls;
well_letter = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
well_number = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'};
for i = 1:numel(plate_aggregate)
    idx = 1; pos_idx = 1; neg_idx = 1;
    for j = 1:size(plate_aggregate{i},1)
        for k = 1:size(plate_aggregate{i},2)
            %For each well check if it is a positive control, negative
            %control, or an experimental well. Place into appropriate
            %array.
            if k == 1
                positive_ctrls(pos_idx,i) = plate_aggregate{i}(j,k);
                wellname_pos{pos_idx,i} = [well_letter{j} ' - ' well_number{k}];
                pos_idx = pos_idx + 1;
            elseif k == 12
                negative_ctrls(neg_idx,i) = plate_aggregate{i}(j,k);
                wellname_neg{neg_idx,i} = [well_letter{j} ' - ' well_number{k}];
                neg_idx = neg_idx + 1;
            else
                well_array(idx,i) = plate_aggregate{i}(j,k);
                wellname_array{idx,i} = [well_letter{j} ' - ' well_number{k}];
                idx = idx + 1;
            end
        end
    end
end

figure();hold on;title([chart_title ' Manhattan Plot']);
ylabel('Neuron Count');xlabel('Observation');
%First plot the positive controls
placeholder = [];color = 'ymcbwk';coloridx = 1;

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
negative_std = std(negative_mean);
cutoff = mean(negative_mean) + 3*negative_std;
plot([0 length(placeholder)],[cutoff cutoff], 'r--');hold off;

%Now add well labels
well_labels = [wellname_pos(:,1); wellname_neg(:,1); wellname_array(:,1)];
set(gca,'XTick',2:3:length(placeholder)-1);
% set(gca,'XTick',1:length(placeholder));
set(gca,'XTickLabel',well_labels);

% plate1 = assign_plate_data(date,'Plate 1',fnames,neuroncount);
% plate2 = assign_plate_data(date,'Plate 2',fnames,neuroncount);
% plate3 = assign_plate_data(date,'Plate 3',fnames,neuroncount);
% plate4 = assign_plate_data(date,'Plate 4',fnames,neuroncount);
% 
% h1 = HeatMap(plate1,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h1.addTitle([date ' Plate 1']);
% h2 = HeatMap(plate2,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h2.addTitle([date ' Plate 2']);
% h3 = HeatMap(plate3,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h3.addTitle([date ' Plate 3']);
% h4 = HeatMap(plate4,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h4.addTitle([date ' Plate 4']);
