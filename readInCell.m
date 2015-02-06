function im_array = readInCell(folder,well_name)
p = folder;
filenames = dir(fullfile(folder,['*' well_name '*']));
names_list = cell(1,numel(filenames));
%Here we sort the list of names properly so we go in the right image order
for i = 1:numel(filenames)
    temp_name = filenames(i).name;
    idx = strfind(temp_name,'wix') + 3;
    if temp_name(idx + 2) == ')';
        names_list{i} = [temp_name(1:idx) '0' temp_name(idx+1:end)];
    else
        names_list{i} = temp_name;
    end
end
[names_list,order] = sort(names_list');

%Now create the image array and start filling it in
tic
temp_name = filenames(1).name;
temp_im = imread(fullfile(folder,temp_name));
w = size(temp_im,1);
h = size(temp_im,2);
im_array = zeros(w,h,numel(filenames));
im_array(:,:,order(1)) = temp_im;

for i = 2:numel(filenames)
    temp_name = filenames(order(i)).name;
    im_array(:,:,i) = imread(fullfile(folder,temp_name));
end
disp('Reading image files takes this long: ');
toc

fishImageBrowser(im_array, well_name);
% showFish(im_array);
% for i = 1:numel(filenames)
%     figure();imagesc(im_array(:,:,i));colormap gray;axis off;axis image;
% end