function varargout = brainCheck(varargin)
% BRAINCHECK MATLAB code for brainCheck.fig
%      BRAINCHECK, by itself, creates a new BRAINCHECK or raises the existing
%      singleton*.
%
%      H = BRAINCHECK returns the handle to a new BRAINCHECK or the handle to
%      the existing singleton*.
%
%      BRAINCHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINCHECK.M with the given input arguments.
%
%      BRAINCHECK('Property','Value',...) creates a new BRAINCHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brainCheck_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brainCheck_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brainCheck

% Last Modified by GUIDE v2.5 22-Apr-2015 09:26:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brainCheck_OpeningFcn, ...
                   'gui_OutputFcn',  @brainCheck_OutputFcn, ...
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


% --- Executes just before brainCheck is made visible.
function brainCheck_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brainCheck (see VARARGIN)

% Choose default command line output for brainCheck
handles.output = hObject;
handles.pathname = varargin{1};
handles.file_dir = dir(handles.pathname);
handles.curr_im = 3;
handles.err_matrix = zeros(8,12);
handles.curr_fname = fullfile(handles.pathname, handles.file_dir(3).name);
temp_im = imread(handles.curr_fname);
imagesc(temp_im,'Parent',handles.axes1);colormap gray;axis image;axis off;
[wellname, ~, ~] = extract_wellname(handles.curr_fname);
title(wellname);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brainCheck wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brainCheck_OutputFcn(hObject, eventdata, handles) 
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
next_image(hObject, eventdata, handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, well_row, well_column] = extract_wellname(handles.curr_fname);
handles.err_matrix(well_row, well_column) = -1;
guidata(hObject, handles);
next_image(hObject, eventdata, handles)


function [wellname, well_row, well_column] = extract_wellname(im_name)
letter_array = 'ABCDEFGH';
[temp, im_fname] = fileparts(im_name);
underscores = strfind(im_fname,'_');
wellname = im_fname(underscores(2)+1:end);
well_letter = wellname(1);
well_row = strfind(letter_array,well_letter);

if length(wellname) == 5 && isempty(strfind(wellname,'(')) == 1
    well_column = str2num(wellname(end));
elseif isempty(strfind(wellname,'(')) == 0
    well_column = str2num(wellname(end-1));
else
    well_column = str2num(wellname(end-1:end));
end


function next_image(hObject, eventdata, handles)
if handles.curr_im <= numel(handles.file_dir)-1
    handles.curr_im = handles.curr_im + 1;
    handles.curr_fname = fullfile(handles.pathname, handles.file_dir(handles.curr_im).name);
    if isempty(strfind(handles.curr_fname, 'Thumbs.db')) == 1
        temp_im = imread(handles.curr_fname);
        imagesc(temp_im,'Parent',handles.axes1);colormap gray;axis image;axis off;
        [wellname, ~, ~] = extract_wellname(handles.curr_fname);
        title(wellname);
        guidata(hObject, handles);
    else
        msgbox('You have finished the data set!');
        handles.output = handles.err_matrix;
        guidata(hObject,handles);
        uiresume(handles.figure1);
    end
else
    msgbox('You have finished the data set!');
    handles.output = handles.err_matrix;
    guidata(hObject,handles);
    uiresume(handles.figure1);
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key,'1') == 1
    pushbutton1_Callback(hObject, eventdata, handles);
end

if strcmp(eventdata.Key,'2') == 1
    pushbutton2_Callback(hObject, eventdata, handles);
end
