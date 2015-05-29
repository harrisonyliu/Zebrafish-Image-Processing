function success = autoextract_brain(FL, BF, save_option, folder, well_name)
%Will autorotate the fish, ID the brain, and take a z-projection of the
%neurons as well as a filtered version of the image. Save option 0 = don't
%save anything, save option 1 = save only the filtered and unfiltered
%z-projections, save option 2 = save everything (including image of the
%fish)

%Making the appropriate folders to save all the data in
[temp,pose_name,ext] = fileparts(folder);
[temp,protocol_name,ext] = fileparts(temp);
[temp,plate_name,ext] = fileparts(temp);
[temp,assay_date,ext] = fileparts(temp);
dir_neuron = fullfile(temp, assay_date, plate_name, 'Extracted neurons');
dir_neuron_filter = fullfile(temp, assay_date, plate_name, 'Extracted neurons filtered');
dir_brain_ID = fullfile(temp, assay_date, plate_name, 'Brain ID');
dir_BF = fullfile(temp, assay_date, plate_name, 'BF');

%Autorotating fish and processing
try
    res = autorotate_small(FL(:,:,1),BF);
catch err
    disp('Something is wrong with this fish! Quitting...');
end

try
    first_crop = FL(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4),1:end-1);
    rotate_im = imrotate(first_crop,res.phi,'crop');
    first_crop_BF = BF(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4),end);
    rotate_im_BF = imrotate(first_crop_BF,res.phi,'crop');
    
    final_crop = rotate_im(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4),:);
    final_crop_BF = rotate_im_BF(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4));
    fig = figure; imagesc(final_crop(:,:,1));colormap gray; axis image;axis off;title(well_name);
    hold on;plot(res.eye1(1),res.eye1(2),'r*');plot(res.eye2(1),res.eye2(2),'r*');plot([res.eye1(1) res.eye2(1)],[res.eye1(2) res.eye2(2)],'r-');
    plot(res.neuron(1),res.neuron(2),'go');plot([res.midpt(1) res.neuron(1)],[res.midpt(2) res.neuron(2)],'g-');hold off;
    z_proj = neuron_z_proj(res.neuron(1),res.neuron(2),final_crop);
%         figure();imagesc(z_proj);colormap gray; axis image;axis off;
    z_proj_filtered = filter_neuron(z_proj);
    brain_BF = crop_brain_area(res.neuron(1),res.neuron(2),final_crop_BF);
%         figure();imagesc(z_proj_filtered);colormap gray; axis image;axis off;
    if save_option > 0
        mkdir(dir_neuron); mkdir(dir_neuron_filter);
        save_image(z_proj, well_name, dir_neuron);
        save_image(z_proj_filtered, well_name, dir_neuron_filter);
    end
    
    if save_option == 2
        mkdir(dir_brain_ID);
        print(fig,fullfile(dir_brain_ID,[assay_date '_' plate_name '_' well_name]),'-dpng')
        close(fig);
        mkdir(dir_BF);
        imwrite(uint16(brain_BF(11:end-10,11:end-10),fullfile(dir_BF,[assay_date '_' plate_name '_' well_name '.tif']));
    end
    success = 1;
catch err
%     msgbox('Something is wrong with this fish! See command line for error. Try manually extracting neurons');
    success = 0;
    err
end

function z_proj = neuron_z_proj(x,y,im)
%This function will take the image passed to it, and crop out a 191 x 221
%z-project image around the central point
neuron_crop = crop_brain_area(x,y,im);
%Doing max z-projection
z_proj = max(neuron_crop,[],3);

function crop = crop_brain_area(x,y,im)
x1 = x - 95; x2 = x + 95;
y1 = y - 110; y2 = y + 110;
crop = im(y1:y2, x1:x2, :);

function filtered_res = filter_neuron(img)
%This will bandpass filter the image passed to it.
%First set the filtering parameters
kernel_size = 18;
h_small = fspecial('Gaussian'); %0.5pix, 3x3 box
h_large = fspecial('Gaussian',[kernel_size,kernel_size],3);
%Now start the filtering process
smallBlur_Im = imfilter(img,h_small,'same');
largeBlur_Im = imfilter(img,h_large,'same');
diff_Im = smallBlur_Im - largeBlur_Im;
diff_Im(diff_Im < 0) = 0;
trim = round(kernel_size/2) + 1;
filtered_res = diff_Im(1+trim:end - trim,11:end - trim);
