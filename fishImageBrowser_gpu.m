function varargout = fishImageBrowser(varargin)
% fishImageBrowser MATLAB code for fishImageBrowser.fig
%      fishImageBrowser, by itself, creates a new fishImageBrowser or raises the existing
%      singleton*.
%
%      H = fishImageBrowser returns the handle to a new fishImageBrowser or the handle to
%      the existing singleton*.
%
%      fishImageBrowser('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in fishImageBrowser.M with the given input arguments.
%
%      fishImageBrowser('Property','Value',...) creates a new fishImageBrowser or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fishImageBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fishImageBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fishImageBrowser

% Last Modified by GUIDE v2.5 30-Dec-2014 14:37:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fishImageBrowser_OpeningFcn, ...
    'gui_OutputFcn',  @fishImageBrowser_OutputFcn, ...
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

% --- Executes just before fishImageBrowser is made visible.
function fishImageBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fishImageBrowser (see VARARGIN)
handles.current_data = varargin{1};
handles.well_name = varargin{2};

handles.maxNum = size(handles.current_data,3) - 1;
imagesc(handles.current_data(:,:,1),'Parent',handles.axes1);colormap gray;axis image;axis off;
axes(handles.axes1);title(['Fish Z-stack 1 of ' num2str(handles.maxNum)]);
imagesc(handles.current_data(:,:,end),'Parent',handles.axes2);colormap gray;axis image;axis off;
axes(handles.axes2);title(handles.well_name);axes(handles.axes1);
handles.color_bound = get(handles.axes1,'CLim');

%Autorotating fish and processing
im = handles.current_data(:,:,1);
res = autorotate_small(handles.current_data(:,:,1),handles.current_data(:,:,end));
try
    first_crop = handles.current_data(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4),1:end-1);
catch err
    msgbox('Something is wrong with this fish! See command line for error');
end
% rotate_im = zeros(size(first_crop));
% for i = 1:size(first_crop,3)
% rotate_im(:,:,i) = imrotate(first_crop(:,:,i),res.phi,'crop');
% end
% rotate_im = imrotate(first_crop,res.phi,'crop');
first_crop_gpu = gpuArray(uint16(first_crop));
rotate_im = imrotate(first_crop_gpu,res.phi,'crop');

final_crop = rotate_im(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4),:);
imagesc(final_crop(:,:,1),'Parent',handles.axes4);colormap gray; axis image;axis off;axes(handles.axes4);
hold on;plot(res.eye1(1),res.eye1(2),'r*');plot(res.eye2(1),res.eye2(2),'r*');plot([res.eye1(1) res.eye2(1)],[res.eye1(2) res.eye2(2)],'r-');
plot(res.neuron(1),res.neuron(2),'go');plot([res.midpt(1) res.neuron(1)],[res.midpt(2) res.neuron(2)],'g-');hold off;
neuron_x1 = res.neuron(1) - 95; neuron_x2 = res.neuron(1) + 95;
neuron_y1 = res.neuron(2) - 110; neuron_y2 = res.neuron(2) + 110;
neuron_crop = final_crop(neuron_y1:neuron_y2, neuron_x1:neuron_x2,:);

%Doing max z-projection
z_proj = max(neuron_crop,[],3);
imagesc(z_proj,'Parent',handles.axes5);colormap gray; axis image;axis off;

%Saving the z-projected images
mkdir(fullfile('Z:\Harrison\Zebrafish Screening Data\Extracted neurons', date));
well = strfind(handles.well_name,'(');
if isempty(well) == 0
    newname = [handles.well_name 'wv Cy3 - Cy3).tif'];
else
    newname = [handles.well_name '(wv Cy3 - Cy3).tif'];
end
fname_neuron = fullfile('Z:\Harrison\Zebrafish Screening Data\Extracted neurons', date, newname);
z_proj = gather(z_proj); imwrite(z_proj,fname_neuron);

set(handles.slider1,'Max',handles.maxNum);
set(handles.slider1,'Min',1);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/handles.maxNum , 3/handles.maxNum]);

set(handles.slider1,'Max',handles.maxNum);
set(handles.slider1,'Min',1);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/handles.maxNum , 3/handles.maxNum]);

% Choose default command line output for fishImageBrowser
handles.output = hObject;

%This array keeps track of all the bad images we do not wish to keep in our
%final, curated image set
handles.badImages = [];
handles.currentImIdx = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fishImageBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function changeImage(imNum,hObject,handles)
if imNum > 0 && imNum < handles.maxNum
    axes(handles.axes1);
    imagesc(handles.current_data(:,:,imNum),handles.color_bound);colormap gray;axis image;axis off;
    title(['Fish Z-slice ' num2str(imNum) ' of ' num2str(handles.maxNum)]);
    handles.currentImIdx = imNum;
    guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = fishImageBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.slider1,'Value');
if val > 0 && val < handles.maxNum
    imNum = round(get(handles.slider1,'Value'));
    changeImage(imNum, hObject, handles);
end

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
    imNum = round(get(handles.slider1,'Value'));
    handles.badImages = [handles.badImages imNum];
    getImNum(hObject, eventdata, handles, 1)
    guidata(hObject,handles); %REMEMBER TO UPDATE THE HANDLES STRUCTURE!!!
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

function saveTruncatedImages(hObject,handles,fname)
truncated_Images = handles.current_data;
badImages = unique(handles.badImages(find(handles.badImages > 0)));
numel(truncated_Images);
numel(handles.badImages);
truncated_Images(badImages) = [];
numel(truncated_Images);
save(fname,'truncated_Images');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save(handles.current_data);
[fname,PathName,FilterIndex] = uiputfile('*.mat','Saving Edited Worms',...
    get(handles.edit1,'String'));
saveTruncatedImages(hObject,handles,fname);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


function crop_zproject(rect, hObject, handles)
x1 = round(rect(1));
x2 = x1 + round(rect(3));
y1 = round(rect(2));
y2 = y1 + round(rect(4));
showFish(handles.current_data(y1:y2, x1:x2, :));

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rect = getrect(handles.axes1);
crop_zproject(rect, hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
imNum = get(handles.slider1,'Value');

if eventdata.VerticalScrollCount > 0 && imNum < handles.maxNum
    set(handles.slider1,'Value',imNum + 1);
    slider1_Callback(hObject, eventdata, handles)
elseif imNum > 1
    set(handles.slider1,'Value',imNum - 1);
    slider1_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[lineX, lineY] = getline(handles.axes1);
rotate_im(lineX, lineY, hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = getpts(handles.axes1);
centered_zproject(x,y,hObject,handles);

function centered_zproject(x,y,hObject,handles);
showFish(handles.current_data(y - 85:y + 85, x - 85:x + 85, :));
