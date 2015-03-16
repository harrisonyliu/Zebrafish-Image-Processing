%This script will look at the background in the fish as well as the
%integrated sum. Simply point it into the folders containing the control
%and mtz embryos

%Additionally this will also auto-subtract the background from each neuron
%image using convolutional filters and save the images under a specified
%folder (16-bit TIFF). To get the proper filename run renameFiles.m in the
%same folder containing the images.

control_folder = 'F:\Zebrafish neuron projections\27-Jan-2015 - Copy\Control';
mtz_folder = 'F:\Zebrafish neuron projections\27-Jan-2015 - Copy\Mtz';
control_dir = dir(control_folder);
mtz_dir = dir(mtz_folder);

%Read in the images
control_stack = zeros(221,191,numel(control_dir) - 2);
control_name = cell(1,size(control_stack,3));
mtz_stack = zeros(221,191,numel(mtz_dir) - 2);
mtz_name = cell(1,size(mtz_stack,3));

for i = 3:numel(control_dir)
    control_stack(:,:,i-2) = imread(fullfile(control_folder,control_dir(i).name));
    [~,control_name{i-2}] = fileparts(control_dir(i).name);
end

for i = 3:numel(mtz_dir)
    mtz_stack(:,:,i-2) = imread(fullfile(mtz_folder,mtz_dir(i).name));
    [~,mtz_name{i-2}] = fileparts(mtz_dir(i).name);
end

%Now find the median of each image
control_med = zeros(1,size(control_stack,3));
control_sum = control_med;
mtz_med = zeros(1,size(mtz_stack,3));
mtz_sum = mtz_med;

for i = 1:size(control_stack,3)
    temp = reshape(control_stack(:,:,i),1,numel(control_stack(:,:,i)));
    control_med(i) = median(temp);
    control_sum(i) = sum(temp);
end

for i = 1:size(mtz_stack,3)
    temp = reshape(mtz_stack(:,:,i),1,numel(mtz_stack(:,:,i)));
    mtz_med(i) = median(temp);
    mtz_sum(i) = sum(temp);
end

%Calculating statistics
%Median (background)
control_se = std(control_med) / sqrt(numel(control_med));
mtz_se = std(mtz_med) / sqrt(numel(mtz_med));
['The control background 95% CE is: ' num2str(mean(control_med)) ' +/- ' num2str(1.96 * control_se)]
['The Mtz background 95% CE is: ' num2str(mean(mtz_med)) ' +/- ' num2str(1.96 * mtz_se)]

%Integrated sum (brightness)
control_se = std(control_sum) / sqrt(numel(control_sum));
mtz_se = std(mtz_sum) / sqrt(numel(mtz_sum));
['The control background 95% CE is: ' num2str(mean(control_sum)) ' +/- ' num2str(1.96 * control_se)]
['The Mtz background 95% CE is: ' num2str(mean(mtz_sum)) ' +/- ' num2str(1.96 * mtz_se)]
num = max(numel(control_sum),numel(mtz_sum));
figure();plot(linspace(1,num,numel(control_sum)),control_sum,'b.');
hold on; plot(linspace(1,num,numel(mtz_sum)),mtz_sum,'r.');
legend('Control','Mtz');title('Integrated Sums');

%% Creating bandpassed filtered versions of the images.
kernel_size = 18;
h_small = fspecial('Gaussian'); %0.5pix, 3x3 box
h_large = fspecial('Gaussian',[kernel_size,kernel_size],3);
scale = 2200;
save_folder = 'C:\Users\harri_000\Downloads';

for i = 1:size(control_stack,3)
    z_proj = control_stack(:,:,i);
    smallBlur_Im = conv2(z_proj,h_small,'same');
    largeBlur_Im = conv2(z_proj,h_large,'same');
    diff_Im = smallBlur_Im - largeBlur_Im;
    diff_Im(find(diff_Im < 0)) = 0;
    trim = round(kernel_size/2) + 1;
    diff_Im = uint16(diff_Im(1+trim:end - trim,11:end - trim));
    z_proj = z_proj(1+trim:end - trim,11:end - trim);
%     figure();imshowpair(z_proj,diff_Im,'montage');
%     title('Before/After Convolutional Filtering');
%     print('-dpng','-r0',fullfile(folder,num2str(i)));
%     close();
    imwrite(diff_Im, fullfile(save_folder,[control_name{i} '.tif']));
end

for i = 1:size(mtz_stack,3)
    z_proj = mtz_stack(:,:,i);
    smallBlur_Im = conv2(z_proj,h_small,'same');
    largeBlur_Im = conv2(z_proj,h_large,'same');
    diff_Im = smallBlur_Im - largeBlur_Im;
    diff_Im(find(diff_Im < 0)) = 0;
    trim = round(kernel_size/2) + 1;
    diff_Im = uint16(diff_Im(1+trim:end - trim,11:end - trim));
    z_proj = z_proj(1+trim:end - trim,11:end - trim);
%     figure();imshowpair(z_proj,diff_Im,'montage');
%     title('Before/After Convolutional Filtering');
%     print('-dpng','-r0',fullfile(folder,num2str(i)));
%     close();
    imwrite(diff_Im, fullfile(save_folder,[mtz_name{i} '.tif']));
end

