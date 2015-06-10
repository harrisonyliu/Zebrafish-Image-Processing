function varargout = dataBrowser(varargin)
% DATABROWSER MATLAB code for dataBrowser.fig
%      DATABROWSER, by itself, creates a new DATABROWSER or raises the existing
%      singleton*.
%
%      H = DATABROWSER returns the handle to a new DATABROWSER or the handle to
%      the existing singleton*.
%
%      DATABROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATABROWSER.M with the given input arguments.
%
%      DATABROWSER('Property','Value',...) creates a new DATABROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataBrowser

% Last Modified by GUIDE v2.5 09-Jun-2015 16:06:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @dataBrowser_OutputFcn, ...
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


% --- Executes just before dataBrowser is made visible.
function dataBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataBrowser (see VARARGIN)

% Choose default command line output for dataBrowser
handles.output = hObject;
handles.selectidx = 2;
handles.colorIdx = 1;
handles.numPlots = 2;
hold on;plot([0, 45], [0.13 0.13],'m--');plot([10 10],[0 2],'m--');
axis([0,20,0,0.2]);
handles.cell_profiler_dir = 'Z:\Harrison\Zebrafish Screening Data\CellProfiler_Results';
handles.folder_names = dir(handles.cell_profiler_dir);

for i = 1:length(handles.folder_names)
    if strcmp(handles.folder_names(i).name,'.') == 1
        remove1 = i;
    elseif strcmp(handles.folder_names(i).name,'..') == 1
        remove2 = i;
    elseif strcmp(handles.folder_names(i).name,'Images') == 1
        remove3 = i;
    end
end

handles.folder_names([remove1 remove2 remove3]) = [];
handles.folder_string = {'Select data' handles.folder_names.name};
set(handles.popupmenu1, 'String', handles.folder_string);
set(handles.popupmenu2, 'String', handles.folder_string);
set(handles.popupmenu3, 'String', handles.folder_string);
set(handles.edit2,'String',fullfile(handles.cell_profiler_dir,'Images'));

%%%% BEGIN TEST CODE %%%%
% fname1 = 'C:\Users\harri_000\Google Drive\Lab Stuff\Zebrafish Project\CellProfiler Results\2015.06.08 Clear hit with BFImage.csv';
% fname2 = 'C:\Users\harri_000\Google Drive\Lab Stuff\Zebrafish Project\CellProfiler Results\2015.06.08 Putative hit with BFImage.csv';
% fname3 = 'C:\Users\harri_000\Google Drive\Lab Stuff\Zebrafish Project\CellProfiler Results\2015.06.08 Non hit with BFImage.csv';
% handles.image_folder = 'C:\Users\harri_000\Downloads\Training Re-do\Consolidated_images';
% set(handles.edit2,'String',handles.image_folder);
% 
% set(handles.edit1,'String',fname1);
% [handles.num1,handles.txt1,handles.raw1]=xlsread(fname1);
% [handles.fnames1, handles.neuroncount1, handles.conv1] = process_xls(handles.num1,handles.txt1,handles.raw1, handles, hObject);
% handles.colorIdx = handles.colorIdx + 1;
% handles.numPlots = handles.numPlots + 1;
% 
% set(handles.edit3,'String',fname2);
% [handles.num2,handles.txt2,handles.raw2]=xlsread(fname2);
% [handles.fnames2, handles.neuroncount2, handles.conv2] = process_xls(handles.num2,handles.txt2,handles.raw2, handles, hObject);
% handles.colorIdx = handles.colorIdx + 1;
% handles.numPlots = handles.numPlots + 1;
% 
% set(handles.edit4,'String',fname3);
% [handles.num3,handles.txt3,handles.raw3]=xlsread(fname3);
% [handles.fnames3, handles.neuroncount3, handles.conv3] = process_xls(handles.num3,handles.txt3,handles.raw3, handles, hObject);
% handles.colorIdx = handles.colorIdx + 1;
% handles.numPlots = handles.numPlots + 1;
%%%% END TEST CODE %%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.csv');
fname = fullfile(pathname,filename);
set(handles.edit1,'String',fname);
[handles.num1,handles.txt1,handles.raw1]=xlsread(fname);
[handles.fnames1, handles.neuroncount1, handles.conv1] = process_xls(handles.num1,handles.txt1,handles.raw1, handles, hObject);
handles.colorIdx = handles.colorIdx + 1;
handles.numPlots = handles.numPlots + 1;
guidata(hObject,handles);

function [fnames, neuroncount,conv] = process_xls(num,txt,raw, handles, hObject)

for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0
        col_fname = i;
    elseif isempty(strfind(txt{1,i},'Count_Neurons_inner')) == 0
        col_neuroncount = i;
    elseif isempty(strfind(txt{1,i},'ghettoconv')) == 0
        col_conv = i;
    end
end

try
    fnames = txt(2:end,col_fname);
    neuroncount = num(:,col_neuroncount);
    conv = num(:,col_conv);
    plotData(neuroncount,conv,handles, hObject)
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end

function plotData(neuroncount,conv,handles, hObject)
colors = cellstr(['''b.''';'''g.''';'''r.''']);
hold on;
plot(neuroncount,conv,eval(colors{handles.colorIdx}));xlabel('Neuron count');ylabel('Convolution result (a.u.)');
currX = get(gca,'xlim');currY = get(gca,'ylim');
newX = max(currX(2),max(neuroncount)); newY = max(currY(2),max(conv));axis([0,newX,0,newY]);
title('Neuron and convolutional results');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
viewimg(handles);

function viewimg(handles)
[pind,xs,ys] = selectdata('selectionmode','brush','BrushSize',0.01);

if iscell(pind) == 0
    mark_and_display(handles,pind,1);
else
    for i = 1:handles.numPlots
        if isempty(pind{i}) == 0
            handleNum = abs(i - (handles.numPlots - 1));
            mark_and_display(handles,pind{i},handleNum);
        end
    end
end

function mark_and_display(handles, idx, handleNum)
for i = 1:length(idx)
    handleNameCount = ['handles.neuroncount' num2str(handleNum) '(' num2str(idx(i)) ')'];
    handleNameConv = ['handles.conv' num2str(handleNum) '(' num2str(idx(i)) ')'];
    handlefName = ['handles.fnames' num2str(handleNum) '{' num2str(idx(i)) '}'];
%     hold on; plot(eval(handleNameCount),eval(handleNameConv),'r*');hold off;
    img_name = eval(handlefName);
    colors = cellstr(['''b''';'''g''';'''r''']);
    dispim(handles.image_folder,img_name, colors{handleNum});
end

function dispim(im_folder, im_name, color)
%Once given the folder and image name, find the filtered image and the
%color coded neuron identification image and show them to the user.
im = imread(fullfile(im_folder,im_name));
idx = strfind(im_name,'.tif') - 1;
im_id_name= [im_name(1:idx) '_neuronID.png'];
im_id = imread(fullfile(im_folder,im_id_name));
titlestr = im_name(1:idx); titlestr(strfind(titlestr,'_')) = ' ';
figure();imshowpair(im,im_id,'montage');title(titlestr,'Color',eval(color));

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image_folder = uigetdir();
set(handles.edit2,'String',handles.image_folder);
guidata(hObject,handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.csv');
fname = fullfile(pathname,filename);
set(handles.edit3,'String',fname);
[handles.num2,handles.txt2,handles.raw2]=xlsread(fname);
[handles.fnames2, handles.neuroncount2, handles.conv2] = process_xls(handles.num2,handles.txt2,handles.raw2, handles, hObject);
handles.colorIdx = handles.colorIdx + 1;
handles.numPlots = handles.numPlots + 1;
guidata(hObject,handles);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.csv');
fname = fullfile(pathname,filename);
set(handles.edit4,'String',fname);
[handles.num3,handles.txt3,handles.raw3]=xlsread(fname);
[handles.fnames3, handles.neuroncount3, handles.conv3] = process_xls(handles.num3,handles.txt3,handles.raw3, handles, hObject);
handles.colorIdx = handles.colorIdx + 1;
handles.numPlots = handles.numPlots + 1;
guidata(hObject,handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
menu_num = get(handles.popupmenu1,'Value');

if menu_num ~= 1
    folder_selection = handles.folder_string{menu_num};
    filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    [handles.num1,handles.txt1,handles.raw1]=xlsread(filename);
    [handles.fnames1, handles.neuroncount1, handles.conv1] = process_xls(handles.num1,handles.txt1,handles.raw1, handles, hObject);
    handles.colorIdx = handles.colorIdx + 1;
    handles.numPlots = handles.numPlots + 1;
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
menu_num = get(handles.popupmenu2,'Value');

if menu_num ~= 1
    folder_selection = handles.folder_string{menu_num};
    filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    [handles.num2,handles.txt2,handles.raw2]=xlsread(filename);
    [handles.fnames2, handles.neuroncount2, handles.conv2] = process_xls(handles.num2,handles.txt2,handles.raw2, handles, hObject);
    handles.colorIdx = handles.colorIdx + 1;
    handles.numPlots = handles.numPlots + 1;
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
menu_num = get(handles.popupmenu3,'Value');

if menu_num ~= 1
    folder_selection = handles.folder_string{menu_num};
    filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    [handles.num3,handles.txt3,handles.raw3]=xlsread(filename);
    [handles.fnames3, handles.neuroncount3, handles.conv3] = process_xls(handles.num3,handles.txt3,handles.raw3, handles, hObject);
    handles.colorIdx = handles.colorIdx + 1;
    handles.numPlots = handles.numPlots + 1;
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filename = get_csv_fname(file_dir,folder_name)
fnames = dir(fullfile(file_dir,folder_name));
for i = 1:length(fnames)
    temp = strfind(fnames(i).name,'Image.csv');
    if isempty(temp) == 0
        idx = i;
    end
end
filename = fullfile(file_dir,folder_name,fnames(idx).name);
