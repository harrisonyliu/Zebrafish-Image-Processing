%This script will look in a folder for all the max z-projected neuron
%images produced by fishImageBrowser.m. It will read in these images, do a
%Laplacian pyramid to achieve a bandpass filtered image of the fish,
%removing the background and leaving only neuron puncta. It will then save
%these images in a new folder.

%Reading in the images
im_folder = 'Z:\Harrison\Zebrafish Screening Data\2015213\Plate 2 Raw\17-Mar-2015 Plate2';
im_dir = dir(im_folder);
for i = 3:numel(im_dir)-1
    im_stack(:,:,i-2) = imread(fullfile(im_folder,im_dir(i).name));
    [~,im_name{i-2}] = fileparts(im_dir(i).name);
end

%% Creating bandpassed filtered versions of the images.
kernel_size = 18;
h_small = fspecial('Gaussian'); %0.5pix, 3x3 box
h_large = fspecial('Gaussian',[kernel_size,kernel_size],3);
scale = 2200;
save_folder = fullfile('C:\Users\harri_000\Downloads', date);
mkdir(save_folder);

for i = 1:size(im_stack,3)
    z_proj = im_stack(:,:,i);
    smallBlur_Im = imfilter(z_proj,h_small,'same');
    largeBlur_Im = imfilter(z_proj,h_large,'same');
    diff_Im = smallBlur_Im - largeBlur_Im;
    diff_Im(diff_Im < 0) = 0;
    trim = round(kernel_size/2) + 1;
    diff_Im = uint16(diff_Im(1+trim:end - trim,11:end - trim));
    z_proj = z_proj(1+trim:end - trim,11:end - trim);
%     figure();imshowpair(z_proj,diff_Im,'montage');
%     title('Before/After Convolutional Filtering');
%     print('-dpng','-r0',fullfile(folder,num2str(i)));
%     close();
    imwrite(diff_Im, fullfile(save_folder,[im_name{i} '.tif']));
end

