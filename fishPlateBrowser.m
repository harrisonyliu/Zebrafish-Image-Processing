function varargout = fishPlateBrowser(varargin)
% FISHPLATEBROWSER MATLAB code for fishPlateBrowser.fig
%      FISHPLATEBROWSER, by itself, creates a new FISHPLATEBROWSER or raises the existing
%      singleton*.
%
%      H = FISHPLATEBROWSER returns the handle to a new FISHPLATEBROWSER or the handle to
%      the existing singleton*.
%
%      FISHPLATEBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FISHPLATEBROWSER.M with the given input arguments.
%
%      FISHPLATEBROWSER('Property','Value',...) creates a new FISHPLATEBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fishPlateBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fishPlateBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fishPlateBrowser

% Last Modified by GUIDE v2.5 05-Jan-2015 16:15:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fishPlateBrowser_OpeningFcn, ...
    'gui_OutputFcn',  @fishPlateBrowser_OutputFcn, ...
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


% --- Executes just before fishPlateBrowser is made visible.
function fishPlateBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fishPlateBrowser (see VARARGIN)

% Choose default command line output for fishPlateBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fishPlateBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fishPlateBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
assignin('base','x',handles.output);
c = evalin('base','x');
assignin('base','y',c);
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
parent_folder = get(handles.edit1,'String');
if iscell(parent_folder) == 1
    parent_folder = parent_folder{1};
end

handles.folder_names = dir(parent_folder);
handles.num_folders = numel(handles.folder_names) - 2;
popup_String = cell(1,handles.num_folders);
for i = 1:handles.num_folders
    popup_String{i} = ['Pose ' num2str(i)];
end
set(handles.popupmenu1,'String',popup_String);
set(handles.text2,'String',popup_String{1});
guidata(hObject, handles);


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
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton80.
function pushbutton80_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end

% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton83.
function pushbutton83_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton84.
function pushbutton84_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton85.
function pushbutton85_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton86.
function pushbutton86_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton87.
function pushbutton87_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton88.
function pushbutton88_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton89.
function pushbutton89_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton90.
function pushbutton90_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton91.
function pushbutton91_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton92.
function pushbutton92_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton93.
function pushbutton93_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton94.
function pushbutton94_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton95.
function pushbutton95_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on button press in pushbutton96.
function pushbutton96_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = handles.path_name;
path_minus_pose = get(handles.edit1,'String');
pose_names = handles.folder_names(3:end);
wellName = get(hObject,'String');
set(hObject,'ForegroundColor','green');
try
    poseSelectionWindow(path_minus_pose, pose_names,wellName);
catch err
    msgbox('Error! No such fish exists in the dataset!');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(handles.popupmenu1,'Value');
handles.pose_folder = handles.folder_names(val+2).name;
str = ['Pose subfolder: ' handles.pose_folder];
set(handles.text2,'String',str);
handles.path_name = fullfile(get(handles.edit1,'String'),handles.pose_folder);
guidata(hObject, handles);
well_Letter = {'A','B','C','D','E','F','G','H'};
well_Number = [1,2,3,4,5,6,7,8,9,10,11,12];

for i = 1:numel(well_Letter)
    for j = 1:numel(well_Number)
        folder = handles.path_name;
        if iscell(folder) == 1
            folder = folder{1};
        end
        wellName = [well_Letter{i} ' - ' num2str(well_Number(j))];
        files_found = dir(fullfile(folder,['*' wellName '*']));
        pushbutton_num = (i-1)*12 + j;
        pushbutton_string = ['handles.pushbutton' num2str(pushbutton_num)];
        set(eval(pushbutton_string),'ForegroundColor','black');
        if numel(files_found) == 0
            set(eval(pushbutton_string),'BackgroundColor',[1 0.6 0.78]);
        end
    end
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


% --- Executes on button press in pushbutton98.
function pushbutton98_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path_name = uigetdir();
if path_name ~= 0
    set(handles.edit1,'String',path_name);
    handles.path_name = path_name;
    guidata(hObject, handles);
    edit1_Callback(hObject, eventdata, handles)
end
