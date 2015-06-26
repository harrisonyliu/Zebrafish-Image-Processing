function plate_grid = assign_plate_data(date,plate,fnames,datapoint)
%This function will search a list of filenames passed to it, identify
%datapoints belonging to the correct date and plate, and assign the data
%point to the appropriate 8x12 cell that represents a well in a 96-well
%plate.
%It will take a string that specifies the well to add data to (e.g.
%'20150514_Plate 4_H - 9(wv Cy3 - Cy3).tif', parse the string to figure out
%the correct placement in the grid, and add the data (i.e. neuron count) to that
%cell. It will then return the original cell array with the new data point
%placed in the correct position.

plate_grid = nan(8,12);
added = 0;

for i = 1:length(fnames)
    %Find the relevant plate and assay date info from the filename
    [row,col,date_read,plate_read] = parse_wellname(fnames{i}); 
    if strcmp(date,date_read) == 1 && strcmp(plate_read,plate) == 1
        plate_grid(row,col) = datapoint(i);
        added = added + 1;
    end
end

if added == 0
    msgbox('No data found matching your date and plate number, please check your syntax!');
end