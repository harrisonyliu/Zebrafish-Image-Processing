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

% Last Modified by GUIDE v2.5 20-Jul-2016 11:38:10

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
handles.pose_Array.pose = cell(8,12); %Keeps track of the folder that the correct pose was located in
handles.pose_Array.wellname = cell(8,12); %Keeps track of the wellnames
handles.pose_Array.success = nan(8,12); %Keeps track of whether the automatic brain ID was successful
handles.pose_Array.meta_pose = cell(8,12); %Keeps track if fish is dead/empty well, or if no good poses were located
handles.pose_Array.poseNum = cell(8,12); %Keeps track of which of the five poses were used
handles.FileConvention = 0;
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
temp = dir(parent_folder);
dirFlag = [temp.isdir]; %We only want to keep folders, any other files should be ignored
handles.folder_names = temp(dirFlag);
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

    function selectPose(hObject,handles)
        folder = handles.path_name;
        path_minus_pose = get(handles.edit1,'String');
        pose_names = handles.folder_names(3:end);
        wellName = get(hObject,'String');
        if handles.FileConvention == 1
            temp_idx = strfind(wellName,'-');
            numStr = wellName(temp_idx+2:end);
            if strcmp(numStr,'1(') == 1
                numStr = '1';
            end
            if str2num(numStr) < 10
                numStr = ['0' numStr];
            end
            if strcmp(numStr,'01') == 1
                numStr = [numStr '('];
            end
            wellName = [wellName(1:temp_idx + 1) numStr];
        end
                
        set(hObject,'ForegroundColor','green');
        button_name = get(hObject,'Tag');
        button_num = str2num(button_name(11:end));
        col = rem(button_num, 12);
        if col == 0
            row = floor(button_num/12);
            col = 12;
        else
            row = floor(button_num/12) + 1;
        end
        
        try
            temp = poseSelectionWindow(path_minus_pose, pose_names,wellName);
            handles.pose_Array.poseNum{row,col} = temp{1};
            handles.pose_Array.pose{row,col} = temp{2};
            handles.pose_Array.wellname{row,col} = temp{3};
            handles.pose_Array.meta_pose{row,col} = temp{4};
            guidata(hObject, handles);
            batch_results = handles.pose_Array;
            assignin('base', 'batch_results', batch_results);
        catch err
            msgbox('Error! No such fish exists in the dataset!');
            err
        end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton80.
function pushbutton80_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton83.
function pushbutton83_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton84.
function pushbutton84_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton85.
function pushbutton85_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton86.
function pushbutton86_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton87.
function pushbutton87_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton88.
function pushbutton88_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton89.
function pushbutton89_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton90.
function pushbutton90_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton91.
function pushbutton91_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton92.
function pushbutton92_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton93.
function pushbutton93_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);


% --- Executes on button press in pushbutton94.
function pushbutton94_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton95.
function pushbutton95_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

% --- Executes on button press in pushbutton96.
function pushbutton96_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectPose(hObject,handles);

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
    path_minus_pose = handles.path_name;
    mat_save_dir = fileparts(path_minus_pose);
    [temp, handles.plate_name] = fileparts(mat_save_dir);
    [temp, handles.assay_date] = fileparts(temp);
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
        
        if strcmp(temp_folder,'empty') == 0 && isempty(temp_folder) == 0
            eyeparam = str2num(get(handles.edit2,'String'));
            [success, handles.dir_neuron, handles.dir_neuron_filter, ...
                handles.dir_brain_ID, handles.dir_BF] = load_and_extract(temp_folder,temp_wellname,eyeparam);
            handles.pose_Array.success(i,j) = success;
            assignin('base', 'batch_results', handles.pose_Array);
        end
    end
end
path_minus_pose = get(handles.edit1,'String');
mat_save_dir = fileparts(path_minus_pose);
handles.pose_Array.err_matrix = brainCheck(fullfile(mat_save_dir,'Brain ID'));
%Batch results: 0 means unable to auto-ID brain, 1 means successful
%auto-ID, NaN means no appropriate pose was identified or the fish was
%missing.
save_batch(handles);
redo_matrix = handles.pose_Array.err_matrix + handles.pose_Array.success;
label_wells(handles, redo_matrix);

%Find any images that were saved that belonged to wells that need to be
%re-done and delete them
fnames_temp = dir(handles.dir_BF);
fnames_temp = {fnames_temp.name}';
for i = 1:size(redo_matrix,1)
    for j = 1:size(redo_matrix,2)
        if redo_matrix(i,j) == 0 || isnan(redo_matrix(i,j)) == 1
            wellname = return_wellname(i,j);
            match = strfind(fnames_temp,wellname);
            %Search the list of files for one that matches the well we're
            %interested in!
            if isempty([match{:}]) == 0
                fname_idx = find(~cellfun(@isempty,match));
                bf_name_temp = fnames_temp{fname_idx};
                [~,bf_name,~] = fileparts(bf_name_temp);
                if j == 1
                    append_FL = 'wv Cy3 - Cy3).tif';
                else
                    append_FL = '(wv Cy3 - Cy3).tif';
                end
                neuron_name = fullfile(handles.dir_neuron,[bf_name append_FL]);
                neuron_name_filter = fullfile(handles.dir_neuron_filter,[bf_name append_FL]);
                id_name = fullfile(handles.dir_brain_ID,[bf_name '.png']);
                bf_name = fullfile(handles.dir_BF,[bf_name '.tif']);
                delete(neuron_name); delete(neuron_name_filter); delete(id_name); delete(bf_name);
            end
        end
    end
end
                
guidata(hObject, handles);

function wellname = return_wellname(row,col)
letter = 'ABCDEFGH';
if col == 1
    num = '1)';
else
    num = num2str(col);
end
wellname = [letter(row) ' - ' num];

function save_batch(handles)
path_minus_pose = get(handles.edit1,'String');
mat_save_dir = fileparts(path_minus_pose);
[temp, plate_name] = fileparts(mat_save_dir);
[temp, assay_date] = fileparts(temp);
fname = fullfile(mat_save_dir,[assay_date '_' plate_name '_batchresults.mat']);
batch_results = handles.pose_Array;
assignin('base', 'batch_results', batch_results);
save(fname, 'batch_results');

function [success, dir_neuron, dir_neuron_filter, dir_brain_ID, dir_BF] = load_and_extract(folder,well_name,eyeparam)
p = folder;
filenames = dir(fullfile(folder,['*' well_name '*']));
names_list = cell(1,numel(filenames));
%Here we sort the list of names properly so we go in the right image order,
%with the last image being the brightfield one
for i = 1:numel(filenames)
    temp_name = filenames(i).name;
    idx = strfind(temp_name,'z') + 3;
    if temp_name(idx) == ')';
        names_list{i} = [temp_name(1:idx - 2) '0' temp_name(idx-1:end)];
    else
        names_list{i} = temp_name;
    end
end
[names_list,order] = sort(names_list);

%Find the brightfield image and move it to the end of the order list
for i = 1:length(names_list)
    if isempty(strfind(names_list{i},'Brightfield')) == 0
        idx_bf = i;
    end
end
order(idx_bf) = [];
order(end+1) = idx_bf;

%Now create the image array and start filling it in
temp_name = filenames(order(1)).name;
% temp_im = imread(fullfile(folder,temp_name));
% w = size(temp_im,1);
% h = size(temp_im,2);
% im_array = zeros(w,h,numel(filenames));
temp_im = imread(fullfile(folder,temp_name));
w = 2048;
h = 2048;
im_array = zeros(w,h,numel(filenames));
im_size = size(temp_im,1);
scale_factor = 2048/im_size;
if scale_factor ~= 1
    temp_im = imresize(temp_im, scale_factor);
end
im_array(:,:,1) = temp_im;

for i = 2:numel(filenames)
    temp_name = filenames(order(i)).name;
    temp_im = imread(fullfile(folder,temp_name));
    if scale_factor ~= 1
        temp_im = imresize(temp_im, scale_factor);
    end
    im_array(:,:,i) = temp_im;
end

FL = im_array(:,:,1:end-1); BF = im_array(:,:,end);
[success, dir_neuron, dir_neuron_filter, ...
                dir_brain_ID, dir_BF] = autoextract_brain(FL, BF, 2, folder, well_name, eyeparam);


% --- Executes on button press in pushbutton100.
function pushbutton100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.mat');
if filename ~= 0
    load(fullfile(pathname,filename));
    handles.pose_Array = batch_results;
    guidata(hObject,handles);
    if isfield(batch_results,'err_matrix') == 1
        redo_matrix = batch_results.success + batch_results.err_matrix;
        label_wells(handles, redo_matrix);
    else
        load(fullfile(pathname,filename));
        label_wells_prelim(handles, batch_results);
    end
end

function label_wells(handles, redo_matrix)
%This function will color code the wells in fishPlateBrowser, green means
%successful ID, red means unsuccessful, black means the well was either
%empty or no good poses were identified
for i = 1:8
    for j = 1:12
        button_num = (i - 1)*12 + j;
        button_name = ['handles.pushbutton' num2str(button_num)];
        if redo_matrix(i,j) <= 0
            set(eval(button_name),'ForegroundColor','red');
        elseif redo_matrix(i,j) == 1;
            set(eval(button_name),'ForegroundColor','green');
        else
            set(eval(button_name),'ForegroundColor','black');
        end
    end
end

function label_wells_prelim(handles, batch_results)
%This function will color code the wells in fishPlateBrowser, green means
%successful ID, red means unsuccessful, black means the well was either
%empty or no good poses were identified
for i = 1:8
    for j = 1:12
        button_num = (i - 1)*12 + j;
        button_name = ['handles.pushbutton' num2str(button_num)];
        if isempty(batch_results.pose{i,j}) == 0
            set(eval(button_name),'ForegroundColor','green');
        else
            set(eval(button_name),'ForegroundColor','black');
        end
    end
end


% --- Executes on button press in pushbutton101.
function pushbutton101_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_batch(handles);

    function imageable = tally_pose_success(handles)
        batch_results = handles.pose_Array;
        good = 0;
        bad = 0;
        missing = 0;
        for i = 1:8
            for j = 1:12
                res = batch_results.meta_pose{i,j};
                if strcmp(res, 'good') == 1
                    good = good + 1;
                elseif strcmp(res,'bad') == 1
                    bad = bad + 1;
                else
                    missing = missing + 1;
                end
            end
        end
        p_good = round(good/96 * 1000)/1000 * 100;
        p_bad = round(bad/96 * 1000)/1000 * 100;
        p_missing = round(missing/96 * 1000)/1000 * 100;
        imageable = good + bad;
        p_imageable = round((good / imageable) * 1000)/1000 * 100;
        f = figure(); h = pie([good,bad,missing],[1,1,1],{['Successful (' num2str(good), ', ' num2str(p_good) '%)']...
            ['Unsuccessful (' num2str(bad), ', ' num2str(p_bad) '%)']...
            ['Fish missing/dead (' num2str(missing), ', ' num2str(p_missing) '%)']});
        hp = findobj(h, 'Type', 'patch');
        set(hp(1), 'FaceColor', 'g');
        set(hp(2), 'FaceColor', 'r');
        set(hp(3), 'FaceColor', 'y');
        title(['Imaging Success for ' handles.assay_date ' ' handles.plate_name...
            ', ' num2str(p_imageable) '% of Image-able Fish Imaged']);
        save_dir = fileparts(handles.path_name);
        print(f,fullfile(save_dir,[handles.assay_date '_' handles.plate_name '_posepiechart']),'-dpng')
        
        function cum_pose_hist(handles, imageable)
            numOccur = zeros(1,5);
            for i = 1:8
                for j = 1:12
                    poseNum = handles.pose_Array.poseNum{i,j};
                    if poseNum == 1
                        numOccur(1) = numOccur(1) + 1;
                    elseif poseNum == 2
                        numOccur(2) = numOccur(2) + 1;
                    elseif poseNum == 3
                        numOccur(3) = numOccur(3) + 1;
                    elseif poseNum == 4
                        numOccur(4) = numOccur(4) + 1;
                    elseif poseNum == 5
                        numOccur(5) = numOccur(5) + 1;
                    end
                end
            end
            p_Occur = numOccur ./ imageable * 100;
            b = figure(); bar(cumsum(p_Occur));
            xlabel('Pose Number');ylabel('Cumulative success (%)');
            axis([0.5 5.5 0 100]); grid on;
            title(['% of fish successfully imaged as number of poses increases for ' handles.assay_date ' ' handles.plate_name]);
            save_dir = fileparts(handles.path_name);
            print(b,fullfile(save_dir,[handles.assay_date '_' handles.plate_name '_posegraph']),'-dpng')
        

% --- Executes on button press in pushbutton102.
function pushbutton102_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageable = tally_pose_success(handles);
cum_pose_hist(handles, imageable);



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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    handles.FileConvention = 1;
else
    handles.FileConvention = 0 ;
end
% Hint: get(hObject,'Value') returns toggle state of checkbox1
guidata(hObject, handles);
