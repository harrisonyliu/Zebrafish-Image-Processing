function res = createWellGroups(letter_start, letter_end, column_start, column_end)
%This function will return an 8x12 array that is zero everywhere except for
%wells that are meant to be grouped together. These wells will have the
%value 1. This function is meant to be used in conjunction with
%groupWells

letters = 'ABCDEFGH';
idx_start = strfind(letters, letter_start);
idx_end = strfind(letters, letter_end);

%Now create an 8x12 array of zeroes and look through it. Any well that falls inside
%the input area is marked with a 1.

res = zeros(8,12);
for row = 1:size(res,1)
    for col = 1:size(res,2)
        if row >= idx_start && row <= idx_end && col >= column_start && col <= column_end
            res(row,col) = 1;
        end
    end
end