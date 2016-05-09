folder = 'C:\Users\harri_000\Google Drive\Lab Stuff\Paper writing\Image processing pipeline\zebrafish imaging pipeline\Raw images';
well_name = 'B - 4';
im_array = readInCell(folder,well_name);

% for i = 1:size(im_array,3)
% figure();imagesc(im_array(:,:,i));axis image;axis off;colormap gray;
% end

FL = im_array(:,:,1:end-1);
BF = im_array(:,:,end);
FL = imresize(FL,4);
BF = imresize(BF,4);
figure();imagesc(FL(:,:,1));axis off;axis image;colormap gray;
figure();imagesc(BF);axis off;axis image;colormap gray;

zproj = max(FL,[],3);
figure();imagesc(zproj);axis off;axis image;colormap gray;

[res, eyes] = autorotate_small(FL,BF,2);