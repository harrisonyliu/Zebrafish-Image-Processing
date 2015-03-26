m = -100/70;
p = 'F:\2015213\Plate 3\24-Mar-2015 Extracted neurons filtered';
f = 'A - 1(wv Cy3 - Cy3).tif';
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