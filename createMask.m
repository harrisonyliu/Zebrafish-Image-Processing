m = -100/70;
p = 'F:\2015213\Plate 3\24-Mar-2015 Extracted neurons filtered';
f = 'B - 2(wv Cy3 - Cy3).tif';
fname = fullfile(p,f);
im = imread(fname);
mask = ones(size(im));
figure();imagesc(im);colormap gray;axis image;
% figure();imagesc(mask);colormap gray;axis image;

b = 100 - m;
c = 1 + 101*m;

for i = 1:size(mask,1)
    for j = 1:size(mask,2)
        if i - m*j < b
            mask(i,j) = 0;
        end
    end
end
figure();imagesc(mask);colormap gray;axis image;

for i = 1:size(mask,1)
    for j = 1:size(mask,2)
        if i + m*j < c
            mask(i,j) = 0;
        end
    end
end
figure();imagesc(mask);colormap gray;axis image;
imwrite(uint16(mask),'process_Mask.tif');

%% Creating brain mask
mask_brain = zeros(size(im));
c_x = round(size(im,2)/2); c_y = round(size(im,1)/2);

for i = 1:size(mask,1)
    for j = 1:size(mask,2)
        temp = ((j-c_x)/45)^2 + ((i-c_y)/75)^2;
        if temp < 1
            mask_brain(i,j) = 1;
        end
    end
end

figure();imagesc(mask_brain);colormap gray;axis image;
figure();imshowpair(im,mask_brain);