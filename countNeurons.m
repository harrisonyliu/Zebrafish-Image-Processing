function countNeurons(z_proj)

%Creating some Gaussian filters
kernel_size = 18;
h_small = fspecial('Gaussian'); %0.5pix, 3x3 box
h_large = fspecial('Gaussian',[kernel_size,kernel_size],3);

%Lots of convolutional operations to remove background
smallBlur_Im = imfilter(z_proj,h_small,'same');
largeBlur_Im = imfilter(z_proj,h_large,'same');
diff_Im = smallBlur_Im - largeBlur_Im;
diff_Im(diff_Im < 0) = 0;
trim = round(kernel_size/2) + 1;
diff_Im = diff_Im(1+trim:end - trim,11:end - trim);
z_proj = z_proj(1+trim:end - trim,11:end - trim);

%Some thresholding in preparation for neuron identification
temp_diff = double(diff_Im) ./ max(max(double(diff_Im)));
graythresh(temp_diff) * 0.75
10*mean(mean(temp_diff))
var(var(temp_diff))
level = max(graythresh(temp_diff) * 0.75, 10*mean(mean(temp_diff)));
bw_temp = im2bw(temp_diff,level);
bw = bwareaopen(bw_temp,4);

%Neuron identification
cc = bwconncomp(bw, 4);
numNeurons = cc.NumObjects;
numPix = sum(sum(bw));
temp = reshape(z_proj,1,numel(z_proj));
normVar = var(double(temp)) / mean(double(temp));
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled, @jet,'k', 'shuffle');

%% Image display
figure();subplot(2,2,1);imshowpair(z_proj,RGB_label,'montage');axis image;axis off;
title('Max Z-Project, Identified Neurons');
% figure();imshowpair(diff_Im,bw);axis image;axis off;
% title('After Filtering, Thresholded Binary Overlay');
subplot(2,2,3);imshowpair(z_proj,bw);axis image;axis off;
title('Max z-proj and Thresholded Binary Overlay');
subplot(2,2,4);imagesc(diff_Im);axis image;axis off;
title('Filtered Image');
subplot(2,2,2);imagesc(z_proj);axis image;axis off;title('Z projection');

%% Display for presentations
% figure();imagesc(z_proj);colormap gray;axis off;axis image;
% title('Max Z-Projection');
% figure();imagesc(diff_Im);colormap gray;axis off;axis image;
% title('Convolutionally Filtered');
% figure();imagesc(bw_temp);colormap gray;axis off;axis image;
% title('Binary Thresholded (Otsu)');
% figure();imagesc(bw);colormap gray;axis off;axis image;
% title('Noise Removal');
% figure();imshow(RGB_label);axis off;axis image;
% title('Final Neuron Identification');

%% Make a movie for presentations (z-projection)
% writerObj = VideoWriter('z_zoom.avi'); 
% writerObj.FrameRate = 8;
% open(writerObj);
% 
% figure();
% imagesc(im_arr(:,:,4));colormap gray;axis off;axis image;
% caxis manual;hold on;
% 
% for k = 1:size(im_arr,3)
%    imagesc(im_arr(:,:,k));colormap gray;axis off;axis image;
%    frame = getframe;
%    writeVideo(writerObj,frame);
% end
% 
% close(writerObj);