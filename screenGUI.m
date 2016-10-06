function varargout = screenGUI(varargin)
% SCREENGUI MATLAB code for screenGUI.fig
%      SCREENGUI, by itself, creates a new SCREENGUI or raises the existing
%      singleton*.
%
%      H = SCREENGUI returns the handle to a new SCREENGUI or the handle to
%      the existing singleton*.
%
%      SCREENGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCREENGUI.M with the given input arguments.
%
%      SCREENGUI('Property','Value',...) creates a new SCREENGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before screenGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to screenGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help screenGUI

% Last Modified by GUIDE v2.5 23-Sep-2016 14:49:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @screenGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @screenGUI_OutputFcn, ...
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


% --- Executes just before screenGUI is made visible.
function screenGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to screenGUI (see VARARGIN)

% Choose default command line output for screenGUI
handles.output = hObject;
% handles.cellProfilerDir = 'Y:\Harrison\Data\Zebrafish - CellProfiler Output';
% handles.screeningScoreDatabase = 'Y:\Harrison\Data\Zebrafish Screening Results\Consolidated Compound Scores';
% handles.screeningScoreFname = 'CURRENT Consolidated Screen Data.xls';
% handles.hitListDir = 'Y:\Harrison\Data\Zebrafish Screening Results\Consolidated Hit List';
handles.cellProfilerDir = 'D:\Harrison\Data\Zebrafish - CellProfiler Output';
handles.screeningScoreDatabase = 'D:\Harrison\Data\Zebrafish Screening Results\Consolidated Compound Scores';
handles.screeningScoreFname = 'CURRENT Consolidated Screen Data.xls';
handles.hitListDir = 'D:\Harrison\Data\Zebrafish Screening Results\Consolidated Hit List';
handles.compoundDatabase = 'D:\Harrison\Data\Zebrafish Screening Results\Bioactive Compound Database';

setDefaultDirectories(handles); %Using the information above, we set all the defaults directories (this will vary
%by the computer used. For example on my personal computer the data is
%stored on the Y: drive, whereas on yellowstone it is stored on the D: drive

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes screenGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function setDefaultDirectories(handles)
%Here we set the default directories (can be changed through the dropdown
%menu)
set(handles.edit8,'String',handles.cellProfilerDir);
set(handles.edit9,'String',handles.screeningScoreDatabase);
set(handles.edit3,'String',fullfile(handles.screeningScoreDatabase,...
    handles.screeningScoreFname));
set(handles.edit10,'String',handles.hitListDir);
set(handles.edit11,'String',handles.compoundDatabase);


% --- Outputs from this function are returned to the command line.
function varargout = screenGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fishPlateBrowser;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    filename = get(handles.edit1,'String');
    plateQuadrant = get(handles.edit2,'String');
    outputFolder = get(handles.edit9,'String');
    addCellProfilerOutputToDatabase(filename,plateQuadrant,outputFolder)
catch err
    msgbox('Error! Make sure the plate quadrant is filled out and a file is selected!');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
screenDatabaseFname = get(handles.edit3,'String');
hitListDir = get(handles.edit10,'String');
cmpdIDdir = get(handles.edit12,'String');
hitDataBrowser(screenDatabaseFname,hitListDir,cmpdIDdir);
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

%Note: the default is for yellowstone settings (data on drive D:). This
%popupmenu can be used to toggle settings for other computers (for example
%on my computer the data is on drive Y:).
curr = get(handles.popupmenu1,'Value'); %1 means Yellowstone, 2 means my computer
if curr == 1 %Keep yellowstone defaults
    handles.cellProfilerDir = 'D:\Harrison\Data\Zebrafish - CellProfiler Output';
    handles.screeningScoreDatabase = 'D:\Harrison\Data\Zebrafish Screening Results\Consolidated Compound Scores';
    handles.hitListDir = 'D:\Harrison\Data\Zebrafish Screening Results\Consolidated Hit List';
    handles.compoundDatabase = 'D:\Harrison\Data\Zebrafish Screening Results\Bioactive Compound Database';
elseif curr == 2 %Switch to my defaults
    handles.cellProfilerDir = 'Y:\Harrison\Data\Zebrafish - CellProfiler Output';
    handles.screeningScoreDatabase = 'Y:\Harrison\Data\Zebrafish Screening Results\Consolidated Compound Scores';
    handles.hitListDir = 'Y:\Harrison\Data\Zebrafish Screening Results\Consolidated Hit List';
    handles.compoundDatabase = 'Y:\Harrison\Data\Zebrafish Screening Results\Bioactive Compound Database';
end
setDefaultDirectories(handles);
guidata(hObject,handles);


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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pathname] = uigetfile([get(handles.edit8,'String') '/*.csv']);
filename = fullfile(pathname,fname);
set(handles.edit1,'String',filename);



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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filedir = get(handles.edit9,'String');
try
    [fname,pathname] = uigetfile([filedir '/*.xls']);
    set(handles.edit3,'String',fullfile(pathname,fname));
catch err
    msgbox('Check to make sure the Default Database Directory was written correctly!');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
temp = get(handles.edit9,'String');
set(handles.edit3,'String',fullfile(temp,handles.screeningScoreFname));


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
default_dir = get(handles.edit11,'String');
[fname,pathname] = uigetfile([default_dir '/*.xlsm']);
set(handles.edit12,'String',fullfile(pathname,fname));
