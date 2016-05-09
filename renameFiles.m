folder = 'F:\20151112DPF5\Extracted neurons';
fnames = dir(folder);

% for i = 3:length(fnames)
%     [~,name] = fileparts(fnames(i).name);
%     %Now search for if a parenthesis exists
%     temp = strfind(name,'(');
%     oldname = fullfile(folder,fnames(i).name);
%     if isempty(temp) == 0
%         newname = [name 'wv Cy3 - Cy3).tif'];
%     else
%         newname = [name '(wv Cy3 - Cy3).tif'];
%     end
%     newname = fullfile(folder,newname);
%     movefile(oldname,newname);
% end

for i = 3:length(fnames)
    [~,name] = fileparts(fnames(i).name);
    %Now search for if a parenthesis exists
    temp = strfind(name,'_');
    oldname = fullfile(folder,fnames(i).name);
    if isempty(temp) == 0
        newname = [name(temp(1)+1:temp(2)-1) '_Plate 1' name(temp(2):end) '.tif'];
    else
        newname = [name '(wv Cy3 - Cy3).tif'];
    end
    newname = fullfile(folder,newname);
    movefile(oldname,newname);
end