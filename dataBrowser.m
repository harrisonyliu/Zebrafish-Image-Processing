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

% Last Modified by GUIDE v2.5 30-Jul-2015 13:28:22

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
handles.countCutoff = 10;
handles.convCutoff = 0.13;
hold on;plot([0, 45], [handles.convCutoff handles.convCutoff],'m--');plot([handles.countCutoff handles.countCutoff],[0 2],'m--');
axis([0,20,0,0.2]);
handles.cell_profiler_dir = 'F:\CellProfiler Output';
handles.hit_list_dir = 'F:\CellProfiler Output';
handles.folder_names = dir(handles.cell_profiler_dir);
handles.image_folder = fullfile(handles.cell_profiler_dir,'Images');

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
well_letter = {'A';'B';'C';'D';'E';'F';'G';'H'};
well_number = {'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12'};
set(handles.popupmenu5, 'String', well_letter);
set(handles.popupmenu6, 'String', well_number);

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
    if isempty(strfind(txt{1,i},'FileName')) == 0 && isempty(strfind(txt{1,i},'BF')) == 1
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

function [fnames, neuroncount,conv, idx_positive, idx_negative] = process_xls_controls(num,txt,raw, handles, hObject)

for i = 1:size(txt,2)
    if isempty(strfind(txt{1,i},'FileName')) == 0 && isempty(strfind(txt{1,i},'BF')) == 1
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
    idx_positive = [];
    idx_negative = [];
    for i = 1:numel(fnames)
        [~,col,~,~] = parse_wellname(fnames{i});
        if col == 1
            idx_positive = [idx_positive i];
        elseif col == 12
            idx_negative = [idx_negative i];
        end
    end
catch err
    msgbox('This file is incompatible! (Likely no filename information)');
end

function [fnames, neuroncount, conv] = process_txt(filename,handles,hObject)
txt_output = readtxtfile(filename);
fnames = txt_output(:,1);
%Need to remove some of the underscores to keep the formatting the
%same
for i = 1:length(fnames)
    underscore_idx = strfind(fnames{i},'_');
    fnames{i}(underscore_idx([2,end-1,end])) = ' ';
    fnames{i} = [fnames{i} '(wv Cy3 - Cy3).tif'];
end
neuroncount  = [txt_output{:,2}]';
conv  = [txt_output{:,3}]';
plotData(neuroncount,conv,handles,hObject)

function plotData(neuroncount,conv,handles,hObject)
colors = cellstr(['''b.''';'''g.''';'''r.''']);
hold on;
plot(neuroncount,conv,eval(colors{handles.colorIdx}));xlabel('Neuron count');ylabel('Convolution result (a.u.)');
currX = get(gca,'xlim');currY = get(gca,'ylim');
newX = max(currX(2),max(neuroncount)); newY = max(currY(2),max(conv));axis([0,double(newX),0,newY]);
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
    hold on; 
    a = plot(eval(handleNameCount),eval(handleNameConv),'r*');
    img_name = eval(handlefName);
    colors = cellstr(['''b''';'''g''';'''r''']);
    dispim(handles.image_folder,img_name, colors{handleNum}, eval(handleNameCount), eval(handleNameConv));
    delete(a);hold off;
end

function dispim(im_folder, im_name, color, neuronCount, convCount)
%Once given the folder and image name, find the filtered image and the
%color coded neuron identification image and show them to the user.
im = imread(fullfile(im_folder,im_name));
%Rescale the image to ignore top 0.1% of brightest pixels for better
%contrast
im_linear = reshape(im,1,numel(im));
cutoff = prctile(im_linear,99.9);
im(im > cutoff) = cutoff;
%Now find the image name etc
idx = strfind(im_name,'.tif') - 1;
im_id_name= [im_name(1:idx) '_neuronID.png'];
im_id = imread(fullfile(im_folder,im_id_name));
titlestr = im_name(1:idx); titlestr(strfind(titlestr,'_')) = ' ';
idx2 = strfind(im_name,'(wv') - 1;
hitstr = im_name(1:idx2);
%send the image off to be displayed
hitImageWindow(im,im_id,hitstr,titlestr,color, neuronCount, convCount);
% figure();imshowpair(im,im_id,'montage');title(titlestr,'Color',eval(color));

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
% handl                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      es    structure with handles and user data (see GUIDATA)
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
    handles.folder_selection = folder_selection;
    handles.filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    if isempty(handles.filename) == 1
        handles.filename = get_txt_fname(handles.cell_profiler_dir,folder_selection);
        [handles.fnames1, handles.neuroncount1, handles.conv1] = process_txt(handles.filename, handles, hObject);
    else
        [handles.num1,handles.txt1,handles.raw1]=xlsread(handles.filename);
        [handles.fnames1, handles.neuroncount1, handles.conv1, handles.idx_positive, handles.idx_negative] = process_xls_controls(handles.num1,handles.txt1,handles.raw1, handles, hObject);
    end
    handles.colorIdx = handles.colorIdx + 1;
    handles.numPlots = handles.numPlots + 1;
    
    %Populate the plate list in case the user wants to look at a specific
    %well
    plate_list = cell(length(handles.fnames1),1);
    date_list = cell(length(handles.fnames1),1);
    for i = 1:length(handles.fnames1)
        [~,~,date_list{i},plate_list{i}] = parse_wellname(handles.fnames1{i});
    end
    unique_dates = unique(date_list);unique_plates = unique(plate_list);
    set(handles.popupmenu4, 'String', unique_plates);
    set(handles.popupmenu7, 'String', unique_dates);
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
    handles.folder_selection = folder_selection;
    handles.filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    if isempty(handles.filename) == 1
        handles.filename = get_txt_fname(handles.cell_profiler_dir,folder_selection);
        [handles.fnames2, handles.neuroncount2, handles.conv2] = process_txt(handles.filename, handles, hObject);
    else
        [handles.num2,handles.txt2,handles.raw2]=xlsread(handles.filename);
        [handles.fnames2, handles.neuroncount2, handles.conv2] = process_xls(handles.num2,handles.txt2,handles.raw2, handles, hObject);
    end
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
    handles.folder_selection = folder_selection;
    handles.filename = get_csv_fname(handles.cell_profiler_dir,folder_selection);
    if isempty(handles.filename) == 1
        handles.filename = get_txt_fname(handles.cell_profiler_dir,folder_selection);
        [handles.fnames3, handles.neuroncount3, handles.conv3] = process_txt(handles.filename, handles, hObject);
    else
        [handles.num3,handles.txt3,handles.raw3]=xlsread(handles.filename);
        [handles.fnames3, handles.neuroncount3, handles.conv3] = process_xls(handles.num3,handles.txt3,handles.raw3, handles, hObject);
    end
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
idx = [];
for i = 1:length(fnames)
    temp = strfind(fnames(i).name,'Image.csv');
    if isempty(temp) == 0
        idx = i;
    end
end
if isempty(idx) == 1
    filename = [];
else
    filename = fullfile(file_dir,folder_name,fnames(idx).name);
end


function filename = get_txt_fname(file_dir,folder_name)
fnames = dir(fullfile(file_dir,folder_name));
idx = [];
for i = 1:length(fnames)
    temp = strfind(fnames(i).name,'.txt');
    if isempty(temp) == 0
        idx = i;
    end
end
if isempty(idx) == 1
    filename = [];
else
    filename = fullfile(file_dir,folder_name,fnames(idx).name);
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'f1') == 1
    viewimg(handles);
elseif strcmp(eventdata.Key,'f3') == 1
    save_hits(handles);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This will open up the hit list for the first set of data for viewing!
try
    if strcmp(handles.folder_selection,'Hits_master') == 1
        system(['notepad ' [handles.hit_list_dir '\master_list.txt']]);
    else
        [assay_date, assay_plate, assay_well] = parsefname(handles.fnames1(1));
        fname = fullfile(handles.hit_list_dir,[eval('assay_date') '_hits.txt']);
        system(['notepad ' fname])
    end
catch err
    err
    msgbox('No hit list found for that assay date! Try identifying hits first');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% temp = evalin('base','hitlist');
% [assay_date, assay_plate, assay_well] = parsefname(temp);
save_hits(handles);

function save_hits(handles)
%Will read in the identified hits from the workspace, save it in the hits
%and Cellprofiler results folders (duplicate copies). Will also add the
%identified hits to the master hit list as well in both folders
try
    temp = evalin('base','hitlist');
    [assay_date, assay_plate, assay_well] = parsefname(temp(1,1));
    %We wish to only save the unique hits in the plate... save to hit list
    %directory
    save_unique_hits(temp, [eval('assay_date') '_hits.txt'], handles.hit_list_dir);
    %Save again in the cellprofiler directory
    hit_dir = fullfile(handles.cell_profiler_dir, ['Hits_' assay_date]);
    mkdir(hit_dir);
    save_unique_hits(temp, [eval('assay_date') '_hits.txt'], hit_dir);
    
    %Now find the master hit lists
    master_path = fullfile(handles.hit_list_dir, 'master_list.txt');
    master_data = readtxtfile(master_path);
    new_master = [master_data;temp];
    master_path = fullfile(handles.cell_profiler_dir,'Hits_master');
    mkdir(master_path);
    %Concatenate the new hits to the master list and save it!
    save_unique_hits(new_master, 'master_list.txt', handles.hit_list_dir);
    save_unique_hits(new_master, 'master_list.txt', master_path);
    
    msgbox('Your hits are saved!');
catch err
    err
    msgbox('Nothing to save! View images and mark hits first');
end

function save_unique_hits(hit_data, fname, fpath)
%Will take a list of hit data, the date of the assay, and the path to save
%the file in. Will screen through the list of hits for unique ones, then
%save the file as a .txt file
    [C, ia, ic] = unique(hit_data(:,1));
    temp_unique = hit_data(ia,:);
    fileID = fopen(fullfile(fpath,fname),'w');
    formatSpec = '%s %d %e\r\n';
    for i = 1:size(temp_unique,1)
        fprintf(fileID,formatSpec,temp_unique{i,:});
    end
    fclose(fileID);


function [assay_date, assay_plate, assay_well] = parsefname(name)
breaks = strfind(name{1},'_');
assay_date = name{1}(1:breaks(1)-1);
assay_plate = name{1}(breaks(1)+1:breaks(2)-1);
assay_well = name{1}(breaks(2)+1:end);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
evalin('base',['clear ','hitlist']) 
delete(hObject);

function autoID(handles, handleNum)
idx = [];
for i = 1:length(eval(['handles.neuroncount' num2str(handleNum)]))
    handleNameCount = ['handles.neuroncount' num2str(handleNum) '(' num2str(i) ')'];
    handleNameConv = ['handles.conv' num2str(handleNum) '(' num2str(i) ')'];
    if eval(handleNameCount) > handles.countCutoff && eval(handleNameConv) > handles.convCutoff
        idx = [idx i];
    end
end
if isempty(idx) == 0
    mark_and_display(handles, idx, handleNum)
else
    msgbox('No hits meet he automated criteria! Please manually select data to view');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoID(handles, 1);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoID(handles, 2);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoID(handles, 3);

function output = readtxtfile(fname)
formatSpec = '%s %d %f64\r\n';
fileID = fopen(fname,'r');
C = textscan(fileID,formatSpec);
fclose(fileID);

output = [];
for i = 1:length(C{1})
    %column 1 is the wellname, column 2 is neuron count, column 3 is
    %convolutional measure
    output = [output;{C{1}{i}, C{2}(i), C{3}(i)}];
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.temp_overlay);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.filename) == 0
    visualPlateData(handles.filename);
else
    msgbox('No appropriate plate data found! Make sure you are not choosing a Hits_ file');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
date_list = get(handles.popupmenu7,'String');
plate_list = get(handles.popupmenu4,'String');
well_letter_list = get(handles.popupmenu5,'String');
well_num_list = get(handles.popupmenu6,'String');

date_sel = get(handles.popupmenu7,'Value');
plate_sel = get(handles.popupmenu4,'Value');
well_letter_sel = get(handles.popupmenu5,'Value');
well_num_sel = get(handles.popupmenu6,'Value');

date_str = date_list{date_sel};
plate_num = plate_list{plate_sel};
well_letter = well_letter_list{well_letter_sel};
well_num = well_num_list{well_num_sel};

FL_suffix = '(wv Cy3 - Cy3).tif';
ID_suffix = '(wv Cy3 - Cy3)_neuronID.png';
FL_name = [date_str '_' plate_num '_' well_letter ' - ' well_num FL_suffix];
ID_name = [date_str '_' plate_num '_' well_letter ' - ' well_num ID_suffix];
FL_full = fullfile(handles.image_folder,FL_name);
ID_full = fullfile(handles.image_folder,ID_name);
FL_im = imread(FL_full);
ID_im = imread(ID_full);
figure();imshowpair(FL_im, ID_im,'montage');
title([date_str ' ' plate_num ' ' well_letter ' - ' well_num]);


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispControls(hObject, handles);

function dispControls(hObject, handles)
hold on;
handles.positive = plot(handles.neuroncount1(handles.idx_positive), handles.conv1(handles.idx_positive),'go','LineWidth',2);
handles.negative = plot(handles.neuroncount1(handles.idx_negative), handles.conv1(handles.idx_negative),'ro','LineWidth',2);
guidata(hObject, handles);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    delete(handles.positive);
    delete(handles.negative);
catch err
    msgbox('Plot some control data first!');
end