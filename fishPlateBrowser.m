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

% Last Modified by GUIDE v2.5 21-Apr-2015 17:15:25

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
handles.pose_Array = struct();
handles.pose_Array.pose = cell(8,12);
handles.pose_Array.wellname = cell(8,12);
handles.pose_Array.success = nan(8,12);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,1} = temp{2};
    handles.pose_Array.wellname{1,1} = temp{3};
    guidata(hObject, handles);
catch err
    msgbox('Error! No such fish exists in the dataset!');
    err
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
    temp = poseSelectionWindow(path_minus_pose, pose_names, wellName);
    handles.pose_Array.pose{1,2} = temp{2};
    handles.pose_Array.wellname{1,2} = temp{3};
    guidata(hObject, handles);
catch err
    msgbox('Error! No such fish exists in the dataset!');
    err
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,3} = temp{2};
    handles.pose_Array.wellname{1,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,4} = temp{2};
    handles.pose_Array.wellname{1,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,5} = temp{2};
    handles.pose_Array.wellname{1,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,6} = temp{2};
    handles.pose_Array.wellname{1,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,7} = temp{2};
    handles.pose_Array.wellname{1,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,8} = temp{2};
    handles.pose_Array.wellname{1,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,9} = temp{2};
    handles.pose_Array.wellname{1,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,10} = temp{2};
    handles.pose_Array.wellname{1,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,11} = temp{2};
    handles.pose_Array.wellname{1,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{1,12} = temp{2};
    handles.pose_Array.wellname{1,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,1} = temp{2};
    handles.pose_Array.wellname{2,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,2} = temp{2};
    handles.pose_Array.wellname{2,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,3} = temp{2};
    handles.pose_Array.wellname{2,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,4} = temp{2};
    handles.pose_Array.wellname{2,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,5} = temp{2};
    handles.pose_Array.wellname{2,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,6} = temp{2};
    handles.pose_Array.wellname{2,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,7} = temp{2};
    handles.pose_Array.wellname{2,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,8} = temp{2};
    handles.pose_Array.wellname{2,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,9} = temp{2};
    handles.pose_Array.wellname{2,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,10} = temp{2};
    handles.pose_Array.wellname{2,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,11} = temp{2};
    handles.pose_Array.wellname{2,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{2,12} = temp{2};
    handles.pose_Array.wellname{2,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,1} = temp{2};
    handles.pose_Array.wellname{3,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,2} = temp{2};
    handles.pose_Array.wellname{3,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,3} = temp{2};
    handles.pose_Array.wellname{3,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,4} = temp{2};
    handles.pose_Array.wellname{3,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,5} = temp{2};
    handles.pose_Array.wellname{3,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,6} = temp{2};
    handles.pose_Array.wellname{3,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,7} = temp{2};
    handles.pose_Array.wellname{3,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,8} = temp{2};
    handles.pose_Array.wellname{3,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,9} = temp{2};
    handles.pose_Array.wellname{3,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,10} = temp{2};
    handles.pose_Array.wellname{3,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,11} = temp{2};
    handles.pose_Array.wellname{3,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{3,12} = temp{2};
    handles.pose_Array.wellname{3,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,1} = temp{2};
    handles.pose_Array.wellname{4,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,2} = temp{2};
    handles.pose_Array.wellname{4,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,3} = temp{2};
    handles.pose_Array.wellname{4,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,4} = temp{2};
    handles.pose_Array.wellname{4,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,5} = temp{2};
    handles.pose_Array.wellname{4,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,6} = temp{2};
    handles.pose_Array.wellname{4,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,7} = temp{2};
    handles.pose_Array.wellname{4,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,8} = temp{2};
    handles.pose_Array.wellname{4,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,9} = temp{2};
    handles.pose_Array.wellname{4,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,10} = temp{2};
    handles.pose_Array.wellname{4,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,11} = temp{2};
    handles.pose_Array.wellname{4,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{4,12} = temp{2};
    handles.pose_Array.wellname{4,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,1} = temp{2};
    handles.pose_Array.wellname{5,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,2} = temp{2};
    handles.pose_Array.wellname{5,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,3} = temp{2};
    handles.pose_Array.wellname{5,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,4} = temp{2};
    handles.pose_Array.wellname{5,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,5} = temp{2};
    handles.pose_Array.wellname{5,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,6} = temp{2};
    handles.pose_Array.wellname{5,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,7} = temp{2};
    handles.pose_Array.wellname{5,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,8} = temp{2};
    handles.pose_Array.wellname{5,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,9} = temp{2};
    handles.pose_Array.wellname{5,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,10} = temp{2};
    handles.pose_Array.wellname{5,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,11} = temp{2};
    handles.pose_Array.wellname{5,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{5,12} = temp{2};
    handles.pose_Array.wellname{5,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,1} = temp{2};
    handles.pose_Array.wellname{6,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,2} = temp{2};
    handles.pose_Array.wellname{6,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,3} = temp{2};
    handles.pose_Array.wellname{6,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,4} = temp{2};
    handles.pose_Array.wellname{6,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,5} = temp{2};
    handles.pose_Array.wellname{6,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,6} = temp{2};
    handles.pose_Array.wellname{6,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,7} = temp{2};
    handles.pose_Array.wellname{6,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,8} = temp{2};
    handles.pose_Array.wellname{6,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,9} = temp{2};
    handles.pose_Array.wellname{6,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,10} = temp{2};
    handles.pose_Array.wellname{6,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,11} = temp{2};
    handles.pose_Array.wellname{6,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{6,12} = temp{2};
    handles.pose_Array.wellname{6,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,1} = temp{2};
    handles.pose_Array.wellname{7,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,2} = temp{2};
    handles.pose_Array.wellname{7,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,3} = temp{2};
    handles.pose_Array.wellname{7,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,4} = temp{2};
    handles.pose_Array.wellname{7,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,5} = temp{2};
    handles.pose_Array.wellname{7,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,6} = temp{2};
    handles.pose_Array.wellname{7,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,7} = temp{2};
    handles.pose_Array.wellname{7,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,8} = temp{2};
    handles.pose_Array.wellname{7,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,9} = temp{2};
    handles.pose_Array.wellname{7,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,10} = temp{2};
    handles.pose_Array.wellname{7,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,11} = temp{2};
    handles.pose_Array.wellname{7,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{7,12} = temp{2};
    handles.pose_Array.wellname{7,12} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,1} = temp{2};
    handles.pose_Array.wellname{8,1} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,2} = temp{2};
    handles.pose_Array.wellname{8,2} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,3} = temp{2};
    handles.pose_Array.wellname{8,3} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,4} = temp{2};
    handles.pose_Array.wellname{8,4} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,5} = temp{2};
    handles.pose_Array.wellname{8,5} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,6} = temp{2};
    handles.pose_Array.wellname{8,6} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,7} = temp{2};
    handles.pose_Array.wellname{8,7} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,8} = temp{2};
    handles.pose_Array.wellname{8,8} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,9} = temp{2};
    handles.pose_Array.wellname{8,9} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,10} = temp{2};
    handles.pose_Array.wellname{8,10} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,11} = temp{2};
    handles.pose_Array.wellname{8,11} = temp{3};
    guidata(hObject, handles);
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
    temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
    handles.pose_Array.pose{8,12} = temp{2};
    handles.pose_Array.wellname{8,12} = temp{3};
    guidata(hObject, handles);
catch err
    msgbox('Error! No such fish exists in the dataset!');
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


% --- Executes on button press in pushbutton99.
function pushbutton99_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:8
    for j = 1:12
        temp_folder = handles.pose_Array.pose{i,j};
        temp_wellname = handles.pose_Array.wellname{i,j};
        
        if isempty(temp_folder) == 0
            success = load_and_extract(temp_folder,temp_wellname);
            handles.pose_Array.success(i,j) = success;
            assignin('base', 'batch_results', handles.pose_Array);
        end
    end
end
guidata(hObject, handles);
path_minus_pose = get(handles.edit1,'String');
mat_save_dir = fileparts(path_minus_pose);
[temp, plate_name] = fileparts(mat_save_dir);
[temp, assay_date] = fileparts(temp);
fname = fullfile(mat_save_dir,[assay_date '_' plate_name '_batchresults.mat']);
handles.pose_Array.err_matrix = brainCheck(fullfile(mat_save_dir,'Brain ID'));
batch_results = handles.pose_Array;
%Batch results: 0 means unable to auto-ID brain, 1 means successful
%auto-ID, NaN means no appropriate pose was identified or the fish was
%missing.
assignin('base', 'batch_results', handles.pose_Array);
save(fname, 'batch_results');
redo_matrix = batch_results.err_matrix + batch_results.success;

for i = 1:8
    for j = 1:12
        if redo_matrix(i,j) <= 0
            button_num = (i - 1)*12 + j;
            button_name = ['handles.pushbutton' num2str(button_num)];
            set(eval(button_name),'ForegroundColor','red');
        end
    end
end

function success = load_and_extract(folder,well_name)
p = folder;
filenames = dir(fullfile(folder,['*' well_name '*']));
names_list = cell(1,numel(filenames));
%Here we sort the list of names properly so we go in the right image order
for i = 1:numel(filenames)
    temp_name = filenames(i).name;
    idx = strfind(temp_name,'z') + 3;
    if temp_name(idx) == ')';
        names_list{i} = [temp_name(1:idx - 2) '0' temp_name(idx-1:end)];
    else
        names_list{i} = temp_name;
    end
end
[names_list,order] = sort(names_list');

%Now create the image array and start filling it in
temp_name = filenames(1).name;
temp_im = imread(fullfile(folder,temp_name));
w = size(temp_im,1);
h = size(temp_im,2);
im_array = zeros(w,h,numel(filenames));
im_array(:,:,order(1)) = temp_im;

for i = 2:numel(filenames)
    temp_name = filenames(order(i)).name;
    im_array(:,:,i) = imread(fullfile(folder,temp_name));
end

FL = im_array(:,:,1:end-1); BF = im_array(:,:,end);
success = autoextract_brain(FL, BF, 2, folder, well_name);


% --- Executes on button press in pushbutton100.
function pushbutton100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [filename, pathname, filterindex] = uigetfile('*.mat');
if filename ~= 0
    load(fullfile(pathname,filename));
    redo_matrix = batch_results.success + batch_results.err_matrix;
    for i = 1:8
        for j = 1:12
            button_num = (i - 1)*12 + j;
            button_name = ['handles.pushbutton' num2str(button_num)];
            if redo_matrix(i,j) <= 0
                set(eval(button_name),'ForegroundColor','red');
            elseif redo_matrix(i,j) == 1;
                set(eval(button_name),'ForegroundColor','green');
            end
        end
    end
end
