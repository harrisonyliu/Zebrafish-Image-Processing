function visualPlateData
[filename, pathname] = uigetfile('*.csv');
fullname = fullfile(pathname,filename);
[fnames, neuroncount, conv] = parse_xls(fullname);

[row,col,date,plate] = parse_wellname(fnames{1});

plate1 = assign_plate_data(date,'Plate 1',fnames,neuroncount);
plate2 = assign_plate_data(date,'Plate 2',fnames,neuroncount);
plate3 = assign_plate_data(date,'Plate 3',fnames,neuroncount);
plate4 = assign_plate_data(date,'Plate 4',fnames,neuroncount);

rows = {'H' 'G' 'F' 'E' 'D' 'C' 'B' 'A'};
columns = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'};
 h1 = HeatMap(plate1,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h1.addTitle([date ' Plate 1']);
 h2 = HeatMap(plate2,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h2.addTitle([date ' Plate 2']);
 h3 = HeatMap(plate3,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h3.addTitle([date ' Plate 3']);
 h4 = HeatMap(plate4,'Colormap','jet','RowLabels',rows,'ColumnLabels',columns,'Annotate',1,'AnnotColor','k','Symmetric',0,'ColumnLabelsRotate',1);h4.addTitle([date ' Plate 4']);
