folder = 'F:\Zebrafish neuron projections\27-Jan-2015';
fnames = dir(folder);

for i = 3:length(fnames)
    [~,name] = fileparts(fnames(i).name);
    %Now search for if a parenthesis exists
    temp = strfind(name,'(');
    oldname = fullfile(folder,fnames(i).name);
    if isempty(temp) == 0
        newname = [name 'wv Cy3 - Cy3).tif'];
    else
        newname = [name '(wv Cy3 - Cy3).tif'];
    end
    newname = fullfile(folder,newname);
    movefile(oldname,newname);
end