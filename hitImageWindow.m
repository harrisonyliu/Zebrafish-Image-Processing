function varargout = hitImageWindow(varargin)
% HITIMAGEWINDOW MATLAB code for hitImageWindow.fig
%      HITIMAGEWINDOW, by itself, creates a new HITIMAGEWINDOW or raises the existing
%      singleton*.
%
%      H = HITIMAGEWINDOW returns the handle to a new HITIMAGEWINDOW or the handle to
%      the existing singleton*.
%
%      HITIMAGEWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HITIMAGEWINDOW.M with the given input arguments.
%
%      HITIMAGEWINDOW('Property','Value',...) creates a new HITIMAGEWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hitImageWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hitImageWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hitImageWindow

% Last Modified by GUIDE v2.5 23-Jun-2015 11:46:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hitImageWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @hitImageWindow_OutputFcn, ...
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


% --- Executes just before hitImageWindow is made visible.
function hitImageWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hitImageWindow (see VARARGIN)

% Choose default command line output for hitImageWindow
handles.output = hObject;
handles.imname = varargin{1};
handles.im = varargin{1};
handles.im_id = varargin{2};
handles.hitstr = varargin{3};
handles.titlestr = varargin{4};
handles.color = varargin{5};
handles.neuronCount = varargin{6};
handles.convCount = varargin{7};

imshowpair(handles.im,handles.im_id,'montage');
title(handles.titlestr,'Color',eval(handles.color));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hitImageWindow wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hitImageWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addhit(handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function addhit(handles)
if evalin('base','exist(''hitlist'')') == 0
    handles.hitstr(handles.hitstr == ' ') = '_';
    hitlist = {handles.hitstr, handles.neuronCount, handles.convCount};
    assignin('base','hitlist',hitlist);
else
    hitlist = evalin('base','hitlist');
    handles.hitstr(handles.hitstr == ' ') = '_';
    hitlist(end+1,:) = {handles.hitstr, handles.neuronCount, handles.convCount};
    assignin('base','hitlist',hitlist);
end
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'f1') == 1
    addhit(handles)
elseif strcmp(eventdata.Key,'f2') == 1
    uiresume(handles.figure1);
end

