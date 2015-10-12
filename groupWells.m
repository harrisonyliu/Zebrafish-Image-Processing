function [res, wellnames] = groupWells(inputPlate, data)
%This function will take in a 8x12 array where all wells that are to be
%grouped together have the value 1 and all other wells are 0. It will also
%take a 1xN cell in which each element represents an 8x12 array that
%contains the data/feature from the screening data across N replicate
%plates. The function will return an 96xN array res which contains
%individual wells in the row dimension and N replicates across the column
%dimension. It will also return a 1xN cell array called wellnames that
%contains the names of the wells that correspond to the rows in res.

res = zeros(sum(sum(inputPlate)),numel(data));
wellnames = cell(sum(sum(inputPlate)),numel(data));
row_name = 'ABCDEFGH'; 
for plate_idx = 1:numel(data)
    temp = data{plate_idx};
    idx = 1;
    %Scan through the plate and add data to the appropriate column
    for row = 1:size(inputPlate,1)
        for col = 1:size(inputPlate,2)
            if inputPlate(row,col) == 1
                res(idx,plate_idx) = temp(row,col);
                wellnames{idx,plate_idx} = [row_name(row) ' - ' num2str(col)];
                idx = idx + 1;
            end
        end
    end
end