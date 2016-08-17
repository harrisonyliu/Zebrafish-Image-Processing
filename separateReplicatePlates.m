function plate_struct = separateReplicatePlates(varargin)
%This function will take in a filename, find all the unique plates in the
%file, and return a 1xN cell in which each element of the cell is an
%8x12 (96 well plate) array that represents a screening plate. You can pass
%this function a variable list of strings that represent different features
%and the function will return a structure that contains the data for that
%feature. For example plate_struct = separateReplicatePlates(filename,'Count_Neurons_inner','ghettoconv','TotalIntensity_inner','position_measure'); will return
%four fields under the structure corresponding to the three features it
%should look for.

%First let's find the appropriate data in the Excel file
fname = varargin{1};
[num, txt, ~]=xlsread(fname);
plate_data_raw = process_xls(num,txt,varargin(2:end));

%Find how many plates there are in the data set
date_list = cell(length(plate_data_raw.fnames),1);
plate_list = cell(length(plate_data_raw.fnames),1);
for i = 1:length(plate_data_raw.fnames)
    [~,~,date_list{i},plate_list{i}] = parse_wellname(plate_data_raw.fnames{i});
end
unique_dates = unique(date_list);unique_plates = unique(plate_list);

%Now let's assign the data to individual plates
idx = 1; %To keep track of what plate we are currently on
features = fieldnames(plate_data_raw);
for i = 1:length(unique_dates)
    for j = 1:length(unique_plates)
        %We need to make sure bad combinations of dates and plates are not
        %accidentally processed, so here we make a sanity check to ensure
        %that this plate and date combination even exists
        temp_date = unique_dates{i}; temp_date_idx = strcmp(temp_date,date_list);
        corresponding_plate = plate_list(temp_date_idx); %These are the plates corresponding to that date, we wish to check to see if the current plate exists!
        corr_plate_idx = strcmp(unique_plates{j},corresponding_plate);
        if sum(corr_plate_idx) > 0
            for k = 2:length(features)
                eval(['plate_' features{k} '{idx} = assign_plate_data(unique_dates{i},unique_plates{j},plate_data_raw.fnames,plate_data_raw.' features{k} ');']);
            end
            idx = idx + 1;
        end
    end
end

%Now for the final assignment of results
for i = 2:length(features)
    eval(['plate_struct.' features{i} ' =  plate_' features{i} ';']);
end

function res = process_xls(num,txt,field_str)
%This function will search the xls file for columns with the appropriate
%data and return the data in the res structure where each field represents
%a string that was searched for
for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0 && isempty(strfind(txt{1,i},'BF')) == 1
        col_fname = i;
    end
end

for idx = 1:numel(field_str)
    for i = 1:size(txt,2)
        if isempty(strfind(txt{1,i},field_str{idx})) == 0
            eval(['col_' field_str{idx} ' = ' num2str(i) ';']);
        end
    end
end

try
    res.fnames = txt(2:end,col_fname);
    for i = 1:numel(field_str)
        eval(['res.' field_str{i} ' = num(:,col_' field_str{i} ');']);
    end
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end