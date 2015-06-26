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
    idx1 = idx1(1);
    well_str = wellname(idx1-1:idx1+4);
    underscore_idx = strfind(wellname,'_');
    date = wellname(1:underscore_idx(1)-1);
    temp_plate = wellname;temp_plate(underscore_idx(2)) = ' ';
    plate = temp_plate(underscore_idx(1)+1:underscore_idx(3)-1);
elseif isempty(idx2) == 0
    %This means the file was from an Excel file directly and follows the
    %convention: '20150514_Plate 2_A - 6'
    idx2 = idx2(1);
    well_str = wellname(idx2-1:idx2+4);
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

%We sometimes have trouble with two digit numbers (e.g. B - 1 vs B -
%10)
if isempty(strfind(well_str,'(')) == 0
    well_str = well_str(1:end-1);
    numeric = str2num(well_str(end));
else
    numeric = str2num(well_str(end-1:end));
end
%Now convert this into useful things!
alpha = well_str(1); 
row = strfind(letters,alpha);col = numeric;