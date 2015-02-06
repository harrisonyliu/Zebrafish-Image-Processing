function res = autorotate_small(im,bf)
% [im_crop_final im_crop_final_bf, eye1, eye2, neuron, midpt]
scale = 2; %We wish to do all the processing on a half-sized image
im = imresize(im,1/scale);
bf = imresize(bf,1/scale);

res = struct();
%Image preprocessing and binarization
im_normalized = im ./ max(max(im));
level = graythresh(im_normalized);
im_bw = im2bw(im_normalized,level);

% figure();imshowpair(im,im_bw,'montage');
im_noiseRemoved = bwareaopen(im_bw,100/scale);
% figure();imshowpair(im_bw,im_noiseRemoved,'montage');

SE = strel('disk',100/scale);
im_closed = imclose(im_noiseRemoved,SE);
im_noiseRemoved_2 = bwareaopen(im_closed,20000/scale);
% figure();imshowpair(im_noiseRemoved, im_noiseRemoved_2,'montage');

%PCA Analysis
im_reshape = reshape(im_noiseRemoved_2,numel(im_closed),1);
[X,Y] = meshgrid(1:size(im,1),1:size(im,2));
x_reshape = reshape(X,numel(X),1);
y_reshape = reshape(Y,numel(Y),1);
pca_matrix = [im_reshape, x_reshape, y_reshape];
pca_matrix_final = zeros(sum(pca_matrix(:,1)),2);
idx = 1;

for i = 1:size(pca_matrix,1)
    if pca_matrix(i,1) == 1
        pca_matrix_final(idx,:) = pca_matrix(i,[2,3]);
        idx = idx + 1;
    end
end

x_center = round(sum(pca_matrix_final(:,2)) / size(pca_matrix_final,1));
y_center = round(sum(pca_matrix_final(:,1)) / size(pca_matrix_final,1));
bounds = [(x_center - 1), (size(im,1) - x_center), (y_center - 1), (size(im,2) - y_center), 1050/scale];
%Find the smallest distance from the center to the edge of the image in
%order to find the largest possible cropped image;
crop_size = bounds(find(bounds == min(bounds)));
cropy1 = x_center - crop_size; cropy2 = x_center + crop_size;
cropx1 = y_center - crop_size; cropx2 = y_center + crop_size;
res.crop1 = 2*[cropy1 cropy2 cropx1 cropx2];
im_cropped = im(cropy1:cropy2, cropx1:cropx2);
im_cropped_bw = im_closed(cropy1:cropy2, cropx1:cropx2);
im_cropped_bf = bf(cropy1:cropy2, cropx1:cropx2);
% figure();imagesc(im_cropped);colormap gray;axis off;axis image;

[COEFF,SCORE,latent] = pca(pca_matrix_final);
p1 = COEFF(:, 1); m1 = p1(1)/p1(2);
p2 = COEFF(:, 2); m2 = p2(1)/p2(2);
% figure();imagesc(im_closed);colormap gray;axis off;axis image;
% hold on;
% plot([y_center (500*p1(1) + y_center)], [x_center, (500*p1(2) + x_center)], 'b-', 'linewidth', 3);
% plot([y_center (500*p2(1) + y_center)], [x_center, (500*p2(2) + x_center)], 'r-', 'linewidth', 3);
% plot(y_center, x_center, 'go');

%Image Rotation
deltax = p1(2);deltay = p1(1);
theta = abs(atand(p1(2) / p1(1)));
if deltax > 0 && deltay > 0
        phi = 270 + theta;
    elseif deltax > 0 && deltay < 0
        phi = 270 - theta;
    elseif deltax < 0 && deltay > 0
        phi = 90 - theta;
    else
        phi = 90 +  theta;
end    
res.phi = phi;
im_rotated = imrotate(im_cropped, phi,'crop');
im_rotated_bw = imrotate(im_cropped_bw, phi,'crop');
im_rotated_bf = imrotate(im_cropped_bf, phi,'crop');
cropped_center = round(size(im_rotated,1)/2);

smallcropy1 = cropped_center - 450/scale; smallcropy2 = cropped_center + 450/scale;
smallcropx1 = cropped_center - 250/scale; smallcropx2 = cropped_center + 250/scale;
res.crop2 = 2*[smallcropy1 smallcropy2 smallcropx1 smallcropx2];
try
im_crop_final = im_rotated(smallcropy1:smallcropy2, smallcropx1:smallcropx2);
catch err
    disp 'Fish cannot be cropped out - likely a bad image';
    res = [];
%     figure();imagesc(bf);colormap gray;axis image;
    return
end
im_crop_final_bw = im_rotated_bw(smallcropy1:smallcropy2, smallcropx1:smallcropx2);
im_crop_final_bf = im_rotated_bf(smallcropy1:smallcropy2, smallcropx1:smallcropx2);
% figure();imshowpair(im,im_rotated,'montage');
% figure();imagesc(im_cropped_bf);colormap gray;axis image;

cc = detectEyes(im_crop_final_bf,scale);
centroids = regionprops(cc,'centroid','area');
%Error checking: a "good" fish has exactly two eyes
if numel(centroids) < 2
    disp 'Less than two eyes detected for fish, quitting'
    res = [];
%     figure();imagesc(bf);colormap gray;axis image;
    return
elseif numel(centroids) > 2
    %If more than two eyes detected, start deleting additional eyes,
    %starting with the "eye" with the smallest area, until only 2 are left
    while numel(centroids) > 2
        area = [centroids.Area];
        min_idx = find(area == min(area));
        centroids(min_idx) = [];
    end
end

%Now we check to see if the eyes are in the bottom or top of the image. If
%it's located at the bottom of the image we flip the image upside down and
%rerun the eye analysis.
%Find the locations of the pupils
y_half = round(size(im_crop_final_bf,1) / 2);
x1 = centroids(1).Centroid(1);x2 = centroids(2).Centroid(1);
y1 = centroids(1).Centroid(2);y2 = centroids(2).Centroid(2);
if y1 > y_half
    im_crop_final = imrotate(im_crop_final,180);
    %     im_crop_final_bw = imrotate(im_crop_final_bw,180);
    im_crop_final_bf = imrotate(im_crop_final_bf,180);
    res.phi = res.phi + 180;
    cc = detectEyes(im_crop_final_bf,scale);
    centroids = regionprops(cc,'centroid','area');
    x1 = centroids(1).Centroid(1);x2 = centroids(2).Centroid(1);
    y1 = centroids(1).Centroid(2);y2 = centroids(2).Centroid(2);
end
pupil_distance = sqrt((x2 - x1)^2 + (y2 - y1)^2); neuron_distance = 75/scale;

% figure();imagesc(im_crop_final_bw);colormap gray; axis off;axis image;title('Final Crop BW');
% figure();imagesc(im_crop_final_bf);colormap gray; axis off;axis image;title('Final Crop BF');
% figure();imagesc(im_crop_final);colormap gray; axis off;axis image;title('Final Crop FL');

%Now that we know where the pupils are, the brain is some distance
%away in the perpendicular direction to the eyes
if x1 < x2
    x0 = x1; y0 = y1;
    theta = atand((y2-y1) / (x2-x1));
else
    x0 = x2; y0 = y2;
    theta = atand((y1-y2) / (x1-x2));
end
midpt_x = x0 + pupil_distance/2*cosd(theta);
midpt_y = y0 + pupil_distance/2*sind(theta);
neuron_x = midpt_x + neuron_distance * sind(-theta);
neuron_y = midpt_y + neuron_distance * cosd(-theta);
res.eye1 = 2*[x1, y1];res.eye2 = 2*[x2, y2];
res.neuron = 2*[neuron_x, neuron_y];res.midpt = 2*[midpt_x, midpt_y];

% figure();imagesc(im_crop_final);colormap gray; axis off;axis image;title('Final Crop');
% title('After Tail-Head Correction');hold on;plot(x1,y1,'r*');plot(x2,y2,'r*');plot([x1 x2],[y1 y2],'r-');
% plot(midpt_x,midpt_y,'go');plot(neuron_x,neuron_y,'go');plot([midpt_x neuron_x],[midpt_y neuron_y],'g-');hold off;
% 
% figure();imagesc(im_crop_final_bf);colormap gray; axis off;axis image;title('Final Crop BF');
% title('After Tail-Head Correction');hold on;plot(x1,y1,'r*');plot(x2,y2,'r*');hold off;
end

function [cc] = detectEyes(BF_im,scale)
load('eye_mask.mat');
eyeFilter = imresize(eyeFilter, 1/scale);

res = conv2(BF_im,eyeFilter,'same');
%Normalize and threshold to find hot spots
res_norm = res./max(max(res));
lvl = graythresh(res_norm);
res_bw = im2bw(res_norm,lvl);
res_noise_removed = bwareaopen(res_bw,750/scale);

%Now to analyze and find the centers of the two largest hits
cc = bwconncomp(res_noise_removed, 4);

%Plotting
% centroids = regionprops(cc,'centroid');
% x1 = centroids(1).Centroid(1);x2 = centroids(2).Centroid(1);
% y1 = centroids(1).Centroid(2);y2 = centroids(2).Centroid(2); 
% figure();imagesc(BF_im);colormap gray;axis image;
% figure();imagesc(res);axis image;
% figure();imagesc(res_noise_removed);colormap gray;axis off;axis image;
% hold on;plot(x1,y1,'r*');plot(x2,y2,'r*');hold off;
% figure();imshowpair(BF_im,res_noise_removed);
% hold on;plot(x1,y1,'b*');plot(x2,y2,'b*');hold off;
end