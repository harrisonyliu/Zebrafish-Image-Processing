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
plate_label = plate_aggregate;
idx = 1;

for i = 1:length(unique_dates)
    for j = 1:length(unique_plates)
        plate_aggregate{idx} = assign_plate_data(unique_dates{i},unique_plates{j},fnames,neuroncount);
        h1 = HeatMap(plate_aggregate{idx},'Colormap','cool','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h1.addTitle([unique_dates{i} ' ' unique_plates{j}]);
        idx = idx + 1;
    end
end

% plate1 = assign_plate_data(date,'Plate 1',fnames,neuroncount);
% plate2 = assign_plate_data(date,'Plate 2',fnames,neuroncount);
% plate3 = assign_plate_data(date,'Plate 3',fnames,neuroncount);
% plate4 = assign_plate_data(date,'Plate 4',fnames,neuroncount);
% 
% h1 = HeatMap(plate1,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h1.addTitle([date ' Plate 1']);
% h2 = HeatMap(plate2,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h2.addTitle([date ' Plate 2']);
% h3 = HeatMap(plate3,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h3.addTitle([date ' Plate 3']);
% h4 = HeatMap(plate4,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h4.addTitle([date ' Plate 4']);
