function varargout = fishImageBrowser(varargin)
% WORMIMAGEBROWSER MATLAB code for wormImageBrowser.fig
%      WORMIMAGEBROWSER, by itself, creates a new WORMIMAGEBROWSER or raises the existing
%      singleton*.
%
%      H = WORMIMAGEBROWSER returns the handle to a new WORMIMAGEBROWSER or the handle to
%      the existing singleton*.
%
%      WORMIMAGEBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WORMIMAGEBROWSER.M with the given input arguments.
%
%      WORMIMAGEBROWSER('Property','Value',...) creates a new WORMIMAGEBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wormImageBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wormImageBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wormImageBrowser

% Last Modified by GUIDE v2.5 06-Oct-2014 17:14:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @wormImageBrowser_OpeningFcn, ...
    'gui_OutputFcn',  @wormImageBrowser_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before wormImageBrowser is made visible.
function wormImageBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wormImageBrowser (see VARARGIN)
handles.current_data = varargin{1};
handles.maxNum = size(handles.current_data,3) - 1;
imagesc(handles.current_data(:,:,1),'Parent',handles.axes1);colormap gray;axis image;axis off;
imagesc(handles.current_data(:,:,end),'Parent',handles.axes2);colormap gray;axis image;axis off;
title(['Fish Z-stack 1 of ' num2str(handles.maxNum)]);
handles.color_bound = get(handles.axes1,'CLim');

set(handles.slider1,'Max',handles.maxNum);
set(handles.slider1,'Min',1);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/handles.maxNum , 3/handles.maxNum]);

% Choose default command line output for wormImageBrowser
handles.output = hObject;

%This array keeps track of all the bad images we do not wish to keep in our
%final, curated image set
handles.badImages = [];
handles.currentImIdx = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wormImageBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

function changeImage(imNum,hObject,handles)
axes(handles.axes1);
imagesc(handles.current_data(:,:,imNum),handles.color_bound);colormap gray;axis image;axis off;
title(['Fish ' num2str(imNum) ' of ' num2str(handles.maxNum)]);
handles.currentImIdx = imNum;
guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = wormImageBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imNum = round(get(hObject,'Value'));
changeImage(imNum, hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Autorotating fish and processing
im = handles.current_data(:,:,1);
res = autorotate_small(handles.current_data(:,:,1),handles.current_data(:,:,end));
try
    first_crop = handles.current_data(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4),1:end-1);
    % rotate_im = zeros(size(first_crop));
    % for i = 1:size(first_crop,3)
    % rotate_im(:,:,i) = imrotate(first_crop(:,:,i),res.phi,'crop');
    % end
    rotate_im = imrotate(first_crop,res.phi,'crop');
    final_crop = rotate_im(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4),:);
    imagesc(final_crop(:,:,1),'Parent',handles.axes4);colormap gray; axis image;axis off;axes(handles.axes4);
    hold on;plot(res.eye1(1),res.eye1(2),'r*');plot(res.eye2(1),res.eye2(2),'r*');plot([res.eye1(1) res.eye2(1)],[res.eye1(2) res.eye2(2)],'r-');
    plot(res.neuron(1),res.neuron(2),'go');plot([res.midpt(1) res.neuron(1)],[res.midpt(2) res.neuron(2)],'g-');hold off;
    z_proj = neuron_z_proj(res.neuron(1),res.neuron(2),final_crop);
    imagesc(z_proj,'Parent',handles.axes5);colormap gray; axis image;axis off;
    z_proj_filtered = filter_neuron(z_proj);
    imagesc(z_proj_filtered,'Parent',handles.axes6);colormap gray; axis image;axis off;
    save_image(z_proj, handles.well_name, fullfile(handles.dir_name,'Extracted neurons'));
    save_image(z_proj_filtered, handles.well_name, fullfile(handles.dir_name,'Extracted neurons filtered'));
catch err
    msgbox('Something is wrong with this fish! See command line for error. Try manually extracting neurons');
    err
end
end

function z_proj = neuron_z_proj(x,y,im)
%This function will take the image passed to it, and crop out a 191 x 221
%z-project image around the central point
neuron_crop = crop_brain_area(x,y,im);
%Doing max z-projection
z_proj = max(neuron_crop,[],3);
end

function crop = crop_brain_area(x,y,im)
x1 = x - 95; x2 = x + 95;
y1 = y - 110; y2 = y + 110;
crop = im(y1:y2, x1:x2, :);
end

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
end

function getImNum(hObject, eventdata, handles, moveAmt)
imNum = round(get(handles.slider1,'Value')) + moveAmt;

%Two possibilities: a.) The image is out of bounds or b.) The image is on
%the "bad image" list and thus should not be displayed. First check to see
%if the image is within the acceptable range. If not then don't allow the
%image to change

if imNum < 0
    imNum = 1;
elseif imNum > handles.maxNum
    imNum = handles.maxNum;
    %Now let's check to make sure that the image we want to look at is not
    %on the list of banned images. If it is, keep moving!
elseif numel(find(handles.badImages == imNum)) > 0
    getImNum(hObject, eventdata, handles, moveAmt + sign(moveAmt));
else
    set(handles.slider1,'Value',imNum);
    changeImage(imNum, hObject, handles);
end
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'rightarrow') == 1
    getImNum(hObject, eventdata, handles, 1)
end

if strcmp(eventdata.Key,'leftarrow') == 1
    getImNum(hObject, eventdata, handles, -1)
end

if strcmp(eventdata.Key,'uparrow') == 1
    getImNum(hObject, eventdata, handles, 10)
end

if strcmp(eventdata.Key,'downarrow') == 1
    getImNum(hObject, eventdata, handles, -10)
end


if strcmp(eventdata.Key,'1') == 1
    %Autorotating fish and processing
    im = handles.current_data(:,:,1);
res = autorotate_small(handles.current_data(:,:,1),handles.current_data(:,:,end));
try
    first_crop = handles.current_data(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4),1:end-1);
    % rotate_im = zeros(size(first_crop));
    % for i = 1:size(first_crop,3)
    % rotate_im(:,:,i) = imrotate(first_crop(:,:,i),res.phi,'crop');
    % end
    rotate_im = imrotate(first_crop,res.phi,'crop');
    
    final_crop = rotate_im(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4),:);
    imagesc(final_crop(:,:,1),'Parent',handles.axes4);colormap gray; axis image;axis off;axes(handles.axes4);
    hold on;plot(res.eye1(1),res.eye1(2),'r*');plot(res.eye2(1),res.eye2(2),'r*');plot([res.eye1(1) res.eye2(1)],[res.eye1(2) res.eye2(2)],'r-');
    plot(res.neuron(1),res.neuron(2),'go');plot([res.midpt(1) res.neuron(1)],[res.midpt(2) res.neuron(2)],'g-');hold off;
    z_proj = neuron_z_proj(res.neuron(1),res.neuron(2),final_crop);
    imagesc(z_proj,'Parent',handles.axes5);colormap gray; axis image;axis off;
    z_proj_filtered = filter_neuron(z_proj);
%     z_proj_filtered = mask_and_filter(res.neuron(1),res.neuron(2),final_crop);
    imagesc(z_proj_filtered,'Parent',handles.axes6);colormap gray; axis image;axis off;
    save_image(z_proj, handles.well_name, fullfile(handles.dir_name,'Extracted neurons'));
    save_image(z_proj_filtered, handles.well_name, fullfile(handles.dir_name,'Extracted neurons filtered'));
catch err
    msgbox('Something is wrong with this fish! See command line for error. Try manually extracting neurons');
    err
end
end

if strcmp(eventdata.Key,'2') == 1
    [fname,PathName,FilterIndex] = uiputfile('*.mat','Saving Edited Worms',...
        get(handles.edit1,'String'));
    saveTruncatedImages(hObject,handles,fname);
end

if strcmp(eventdata.Key,'3') == 1
    rect = getrect(handles.axes1);
    crop_zproject(rect, hObject, handles)
end

if strcmp(eventdata.Key,'4') == 1
    [lineX, lineY] = getline(handles.axes1);
    rotate_im_fcn(lineX, lineY, hObject, handles);
end

if strcmp(eventdata.Key,'5') == 1
    [x,y] = getpts(handles.axes1);
    z_proj = neuron_z_proj(x,y,handles.current_data(:,:,1:end-1));
    BF_im = crop_brain_area(x,y,handles.current_data(:,:,end));
    mkdir(fullfile(handles.dir_name,'BF'));
    [temp, parent] = fileparts(fullfile(handles.dir_name,'BF'));
    [temp, plate_name] = fileparts(temp);
    [temp, assay_date] = fileparts(temp);
    imwrite(uint16(BF_im(11:end-10,11:end-10)),fullfile(handles.dir_name,'BF',[assay_date '_' plate_name '_' handles.well_name '.tif']));
    imagesc(z_proj,'Parent',handles.axes5);colormap gray; axis image;axis off;
    z_proj_filtered = filter_neuron(z_proj);
    imagesc(z_proj_filtered,'Parent',handles.axes6);colormap gray; axis image;axis off;
    save_image(z_proj, handles.well_name, fullfile(handles.dir_name,'Extracted neurons'));
    save_image(z_proj_filtered, handles.well_name, fullfile(handles.dir_name,'Extracted neurons filtered'));
end
end

function centered_zproject(x,y,hObject,handles);
[z_proj, numNeurons, numPix, normVar] = showFish(handles.current_data(y-100:y+100,...
    x-85:x+85, :));

%Save all the data extracted from the cropped z projection
try
    temp = evalin('base','fish_data');
catch err
    temp = struct();
    temp.images = zeros([size(z_proj),0]);
    temp.numNeurons = [];
    temp.numPix = [];
    temp.normVar = [];
    temp.wellName = cell(0);
    assignin('base','fish_data',temp);
end
temp.images(:,:,end+1) = z_proj;
temp.numNeurons(end+1) = numNeurons;
temp.numPix(end+1) = numPix;
temp.normVar(end+1) = normVar;
temp.wellName{end+1} = handles.well_name;
assignin('base','fish_data',temp);
end

function im_filt_mask = mask_and_filter(x,y,im)
%This function will mask and bandpass filter each image in the stack passed
%to it. At the very end it will perform a max-intensity z projection.

%First set the filtering parameters
kernel_size = 18; trim = round(kernel_size/2) + 1;
h_small = fspecial('Gaussian',[5,5],0.75); %0.5pix, 3x3 box
h_large = fspecial('Gaussian',[kernel_size,kernel_size],3);

neuron_x1 = x - 105; neuron_x2 = x + 105;
neuron_y1 = y - 120; neuron_y2 = y + 120;
neuron_crop = im(neuron_y1:neuron_y2, neuron_x1:neuron_x2,:);

%Now start the filtering process
temp_filter = zeros(size(neuron_crop,1) - trim*2,size(neuron_crop,2) - trim*2,size(im,3));
for i = 1:size(im,3)
    smallBlur_Im = imfilter(neuron_crop(:,:,i),h_small,'same');
    largeBlur_Im = imfilter(neuron_crop(:,:,i),h_large,'same');
    diff_Im = smallBlur_Im - largeBlur_Im;
    diff_Im(diff_Im < 0) = 0;
    temp_filter(:,:,i) = diff_Im(1+trim:end - trim,1+trim:end - trim);
end

%Finally doing the max z-projection
im_filt_mask = max(temp_filter,[],3);
figure();imagesc(im_filt_mask);colormap gray;axis image;title('Slice-by-slice filtering');
temp = max(neuron_crop,[],3);
smallBlur_Im = imfilter(temp,h_small,'same');
largeBlur_Im = imfilter(temp,h_large,'same');
diff_Im = smallBlur_Im - largeBlur_Im;
diff_Im(diff_Im < 0) = 0;
figure();imagesc(diff_Im);colormap gray;axis image;title('Bulk filtering');
end

function saveTruncatedImages(hObject,handles,fname)
truncated_Images = handles.current_data;
badImages = unique(handles.badImages(find(handles.badImages > 0)));
numel(truncated_Images);
numel(handles.badImages);
truncated_Images(badImages) = [];
numel(truncated_Images);
save(fname,'truncated_Images');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save(handles.current_data);
[fname,PathName,FilterIndex] = uiputfile('*.mat','Saving Edited Worms',...
    get(handles.edit1,'String'));
saveTruncatedImages(hObject,handles,fname);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function setSelectionBlack(rect, hObject, handles)
x1 = round(rect(1));
x2 = x1 + round(rect(3));
y1 = round(rect(2));
y2 = y1 + round(rect(4));
%First calculate the average pixel value of the pixels surrounding the area
%to be blacked out (for a smoother transition).
rect_Inner = handles.current_data{handles.currentImIdx}(y1:y2, x1:x2);
rect_Outer = handles.current_data{handles.currentImIdx}(y1-2:y2+2, x1-2:x2+2);
ring_Area = numel(rect_Outer) - numel(rect_Inner);
ring_Sum = sum(sum(rect_Outer)) - sum(sum(rect_Inner));
ring_Avg = ring_Sum / ring_Area;
handles.current_data{handles.currentImIdx}(y1:y2, x1:x2) = ring_Avg;
guidata(hObject,handles); %REMEMBER TO UPDATE THE HANDLES STRUCTURE!!!
changeImage(handles.currentImIdx, hObject, handles);
end

function crop_zproject(rect, hObject, handles)
x1 = round(rect(1));
x2 = x1 + round(rect(3));
y1 = round(rect(2));
y2 = y1 + round(rect(4));
avg_y = round((y1 + y2)/2);
avg_x = round((x1 + x2)/2);
% showFish(handles.current_data(y1:y2, x1:x2, :));
[z_proj, numNeurons, numPix] = showFish(handles.current_data(avg_y - 120:avg_y + 120,...
    avg_x - 100:avg_x + 100, :));
end

function rotate_im_fcn(lineX, lineY, hObject, handles)
deltay = lineY(2) - lineY(1);
deltax = lineX(2) - lineX(1);
slope = deltay / deltax;
theta = abs(atand(slope));
numIminStack = size(handles.current_data,3);

if deltax > 0 && deltay > 0
    phi = 270 + theta;
elseif deltax > 0 && deltay < 0
    phi = 270 - theta;
elseif deltax < 0 && deltay > 0
    phi = 90 - theta;
else
    phi = 90 +  theta;
end

temp = imrotate(handles.current_data,phi);
handles.current_data = temp;
guidata(hObject,handles);
changeImage(handles.currentImIdx,hObject,handles)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rect = getrect(handles.axes1);
crop_zproject(rect, hObject, handles)
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end