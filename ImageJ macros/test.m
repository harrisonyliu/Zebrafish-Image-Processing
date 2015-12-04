folder = 'F:\2015.10.07 Nurr1 tests\Processed_images\FL';
fnames = dir(folder);

% for i = 3:length(fnames)
%     [~,name] = fileparts(fnames(i).name);
%     %Now search for if a parenthesis exists
%     temp = strfind(name,'MAX_C2-');
%     oldname = fullfile(folder,fnames(i).name);
%     if isempty(temp) == 0
%         newname = [name(8:end) '.tif'];
%     else
%         newname = [name(5:end) '.tif'];
%     end
%     newname = fullfile(folder,newname);
%     movefile(oldname,newname);
% end

for i = 3:length(fnames)
    [~,name] = fileparts(fnames(i).name);
    %Now search for if a parenthesis exists
    temp = strfind(name,'MAX_C2-');
    oldname = fullfile(folder,fnames(i).name);
    newname = [name '.ome.tif'];
    newname = fullfile(folder,newname);
    movefile(oldname,newname);
end