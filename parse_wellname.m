function [row,col,date,plate] = parse_wellname(wellname)
%This function will take in a well name like '20150514_Plate 2_A - 6' and turn
%it into the corresponding row and column on a 96-well plate as well as the
%assay date and plate number
letters = ['ABCDEFGH'];

idx1 = strfind(wellname,'_-_'); %in hit_list.txt files we add underscores to spaces
idx2 = strfind(wellname,' - '); %in the actual program itself we use spaces, this program needs to be robust against both

if isempty(idx1) == 0
    %This means the file was from a hit_list file and follows the
    %convention: '20150514_Plate_2_A_-_6'
    well_str = wellname(idx1-1:idx1+3);
    underscore_idx = strfind(wellname,'_');
    date = wellname(1:underscore_idx(1)-1);
    temp_plate = wellname;temp_plate(underscore_idx(2)) = ' ';
    plate = temp_plate(underscore_idx(1)+1:underscore_idx(3)-1);
elseif isempty(idx2 == 0)
    %This means the file was from an Excel file directly and follows the
    %convention: '20150514_Plate 2_A - 6'
    well_str = wellname(idx2-1:idx2+3);
    underscore_idx = strfind(wellname,'_');
    date = wellname(1:underscore_idx(1)-1);
    plate = wellname(underscore_idx(1) + 1: underscore_idx(2) - 1);
else
    row = [];
    col = [];
    date = [];
    plate = [];
    msgbox('Could not identify well string!');
    return
end

alpha = well_str(1); numeric = str2num(well_str(end));
row = strfind(letters,alpha);col = numeric;