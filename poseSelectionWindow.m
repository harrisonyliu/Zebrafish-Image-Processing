function varargout = poseSelectionWindow(varargin)
% POSESELECTIONWINDOW MATLAB code for poseSelectionWindow.fig
%      POSESELECTIONWINDOW, by itself, creates a new POSESELECTIONWINDOW or raises the existing
%      singleton*.
%
%      H = POSESELECTIONWINDOW returns the handle to a new POSESELECTIONWINDOW or the handle to
%      the existing singleton*.
%
%      POSESELECTIONWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSESELECTIONWINDOW.M with the given input arguments.
%
%      POSESELECTIONWINDOW('Property','Value',...) creates a new POSESELECTIONWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before poseSelectionWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to poseSelectionWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help poseSelectionWindow

% Last Modified by GUIDE v2.5 28-Apr-2015 13:29:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @poseSelectionWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @poseSelectionWindow_OutputFcn, ...
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


% --- Executes just before poseSelectionWindow is made visible.
function poseSelectionWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to poseSelectionWindow (see VARARGIN)

% Choose default command line output for poseSelectionWindow
handles.pathname = varargin{1};
handles.posename = varargin{2};
handles.wellname = varargin{3};
handles.im_cell = cell(0);
handles.im_cell_bf = cell(0);
handles.output = [];

for i = 1:numel(handles.posename)
    fname = fullfile(handles.pathname, handles.posename(i).name);
    imfname = dir(fullfile(fname,['*' handles.wellname '*']));
    current_axes = ['handles.axes' num2str(i)];
    finalfname = fullfile(fname,imfname(1).name);
    finalfname_bf = fullfile(fname,imfname(end).name);
    temp_im = imread(finalfname);
    temp_im_bf = imread(finalfname_bf);
    handles.im_cell{i} = temp_im;
    handles.im_cell_bf{i} = temp_im_bf;
    axes(eval(current_axes));imagesc(temp_im);colormap gray;axis off;axis image;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes poseSelectionWindow wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = poseSelectionWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = fullfile(handles.pathname, handles.posename(1).name);
h = gcf;
% output_image(hObject, eventdata, handles, 1);
readInCell(fname,handles.wellname);
handles.output = {[1], fullfile(handles.pathname, handles.posename(1).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = fullfile(handles.pathname, handles.posename(2).name);
h = gcf;
% output_image(hObject, eventdata, handles, 1);
readInCell(fname,handles.wellname);
handles.output = {[2], fullfile(handles.pathname, handles.posename(2).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = fullfile(handles.pathname, handles.posename(3).name);
h = gcf;
% output_image(hObject, eventdata, handles, 3);
readInCell(fname,handles.wellname);
handles.output = {[3], fullfile(handles.pathname, handles.posename(3).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = fullfile(handles.pathname, handles.posename(4).name);
h = gcf;
% output_image(hObject, eventdata, handles, 4);
readInCell(fname,handles.wellname);
handles.output = {[4], fullfile(handles.pathname, handles.posename(4).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = fullfile(handles.pathname, handles.posename(5).name);
h = gcf;
% output_image(hObject, eventdata, handles, 5);
readInCell(fname,handles.wellname);
handles.output = {[5], fullfile(handles.pathname, handles.posename(5).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);

function output_image(hObject, eventdata, handles, button_number)
try 
    temp = evalin('base','fish_stack');
catch err
    temp = struct();
    temp.images = zeros([size(handles.im_cell{1}),0]);
    temp.images_bf = zeros([size(handles.im_cell_bf{1}),0]);
    assignin('base','fish_stack',temp);
end
temp.images(:,:,end+1) = handles.im_cell{button_number};
temp.images_bf(:,:,end+1) = handles.im_cell_bf{button_number};
assignin('base','fish_stack',temp);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
handles.output = {[1], fullfile(handles.pathname, handles.posename(1).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
handles.output = {[2], fullfile(handles.pathname, handles.posename(2).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
handles.output = {[3], fullfile(handles.pathname, handles.posename(3).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
handles.output = {[4], fullfile(handles.pathname, handles.posename(4).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
h = gcf;
handles.output = {[5], fullfile(handles.pathname, handles.posename(5).name), handles.wellname, 'good'};
guidata(hObject, handles);
uiresume(handles.figure1);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when user attempts to close figure1.
function varargout = figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isempty(handles.output) == 1
    handles.output = {[0] 'empty' handles.wellname, 'missing'};
    guidata(hObject,handles);
end
uiresume(handles.figure1);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.output) == 1
    handles.output = {[0] 'empty' handles.wellname, 'missing'};
    guidata(hObject,handles);
end
uiresume(handles.figure1);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.output) == 1
    handles.output = {[0] 'empty' handles.wellname, 'bad'};
    guidata(hObject,handles);
end
uiresume(handles.figure1);