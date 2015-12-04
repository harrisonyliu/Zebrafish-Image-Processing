function [res, wellname_array] = groupReplicateData(data)
%This function will accept an 1xN cell (3D array) where each element
%represents an individual plate. Within the element will be a MxO array in
%which each member of the array represents one measurement. This will
%return an x*y by z array (2D array) where rows represent a unique
%observation and columns represent replicates. Note this is usually a 96 x
%N array since we generally use 96-well plates. NOTE: THIS WILL GROUP BY
%COLUMNS THEN ROWS

well_letter = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
well_number = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'};
wellname_array = cell(96, numel(data));

res = zeros(numel(data{1}),numel(data));
for i=1:numel(data)
    temp = data{i};
    idx = 1;
    for row = 1:size(temp,1)
        for col = 1:size(temp,2)
            res(idx,i) = temp(row,col);
            wellname_array{idx,i} = [well_letter{row} ' - ' well_number{col}];
            idx = idx + 1;
        end
    end
end