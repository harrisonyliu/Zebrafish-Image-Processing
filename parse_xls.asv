function [fnames, neuroncount, conv] = parse_xls(fname)
%This function will automatically read an Excel file containing relevant
%zebrafish screening data and return the well name, neuron count and convolutional
%shape measure as arrays
[num,txt,~]=xlsread(fname); %num contains numeric data, txt contains any text and raw contains mixed data

for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0
        col_fname = i;
    elseif isempty(strfind(txt{1,i},'Count_Neurons_inner')) == 0
        col_neuroncount = i;
    elseif isempty(strfind(txt{1,i},'ghettoconv')) == 0
        col_conv = i;
    end
end

try
    fnames = txt(2:end,col_fname);
    neuroncount = num(:,col_neuroncount);
    conv = num(:,col_conv);
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end
