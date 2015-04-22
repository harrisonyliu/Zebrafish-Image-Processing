function save_image(img, well_name, save_dir)
[temp, parent] = fileparts(save_dir);
[temp, plate_name] = fileparts(temp);
[temp, assay_date] = fileparts(temp);

if exist(save_dir) == 0
    mkdir(save_dir);
end

%Saving the images
well = strfind(well_name,'(');
if isempty(well) == 0
    newname = [assay_date '_' plate_name '_' well_name 'wv Cy3 - Cy3).tif'];
else
    newname = [assay_date '_' plate_name '_' well_name '(wv Cy3 - Cy3).tif'];
end
fname = fullfile(save_dir, newname);

try
    imwrite(uint16(img),fname);
catch err
    msgbox('Cannot access Z:/Badlands!');
    err
end