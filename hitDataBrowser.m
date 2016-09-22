function varargout = hitDataBrowser(varargin)
% HITDATABROWSER MATLAB code for hitDataBrowser.fig
%      HITDATABROWSER, by itself, creates a new HITDATABROWSER or raises the existing
%      singleton*.
%
%      H = HITDATABROWSER returns the handle to a new HITDATABROWSER or the handle to
%      the existing singleton*.
%
%      HITDATABROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HITDATABROWSER.M with the given input arguments.
%
%      HITDATABROWSER('Property','Value',...) creates a new HITDATABROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hitDataBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hitDataBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hitDataBrowser

% Last Modified by GUIDE v2.5 20-Sep-2016 14:11:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hitDataBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @hitDataBrowser_OutputFcn, ...
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


% --- Executes just before hitDataBrowser is made visible.
function hitDataBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hitDataBrowser (see VARARGIN)

%The first argument is the filename that contains all the screening data.
%the second argument is where the saved hit list should be output (the
%folder name)
handles.databaseFname = varargin{1};
handles.hitListFolder = varargin{2};

% Choose default command line output for hitDataBrowser
handles.output = hObject;
handles.hitlist_header = {'Cmpd_ID', 'SSMD', 'Brain Health Score', 'NumObs'};
handles.hitlist = [];
handles.g = [];
handles.pind_unique = [];

set(handles.edit1,'String',handles.databaseFname);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hitDataBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hitDataBrowser_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = get(handles.edit1,'String');
[num,txt,~] = xlsread(fname);
datablock = cell(size(txt));
datablock(1,:) = txt(1,:);
datablock(2:end,1) = txt(2:end,1); %This is the plate quadrant
datablock(2:end,2) = txt(2:end,2); %This is the Tag
datablock(2:end,3) = txt(2:end,3); %This is the Cmpd_ID
datablock(2:end,4) = txt(2:end,4); %This is the Date
datablock(2:end,5) = num2cell(num(:,1)); %This is the SSMD
datablock(2:end,6) = num2cell(num(:,2)); %This is the BHS
datablock(2:end,7) = num2cell(num(:,3)); %This is the NumObs
handles.datablock = datablock;
ssmd = cell2mat(datablock(2:end,5)); bhs = cell2mat(datablock(2:end,6));
[handles.xax, handles.yax] = plotScreenData(hObject,handles,ssmd,bhs);
handles.ssmd = ssmd; handles.bhs = bhs;
guidata(hObject, handles);

function [xax,yax] = plotScreenData(hObject, handles, ssmd, bhs)
%Note: SSMD is column 5 and BHS is column 6 
xlimits = [min(ssmd),max(ssmd)]; ylimits = [min(bhs),max(bhs)];
axes(handles.axes1);plot(bhs,ssmd,'r*','MarkerSize',2);
xlabel('Brain Health Score');
ylabel('SSMD'); hold on;
xax = plot([0,0],xlimits,'k-'); yax = plot(ylimits,[0,0],'k-');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pind,xs,ys] = selectdata('selectionmode','brush','BrushSize',0.02,...
    'Verify','on','Ignore', handles.g, 'Ignore', handles.xax,'Ignore', handles.yax);
%Note: pind will return the index of the x, y point within datablock!
%However, this will be off by ONE due to the exclusion of the header (e.g.
%plate, date, etc. This means that a pind of 45 represents row 46 in
%handles.datablock!
pind
handles.pind = pind{1}%find(~cellfun(@isempty,pind))}; %To start off let's find the data points that were just selected
handles.pind_unique = [handles.pind_unique; handles.pind]; %Let's add these data points to an ever growing list
handles.pind_unique = unique(handles.pind_unique); %Let's remove any duplicates
g_data_bhs = handles.bhs(handles.pind_unique); g_data_ssmd = handles.ssmd(handles.pind_unique); %Let's grab the data from the selected data points so we can plot which ones we've selected so far
cla(handles.axes1);
[handles.xax, handles.yax] = plotScreenData(hObject, handles, handles.ssmd, handles.bhs);hold on; %Now we overlay the selected data over the old data
handles.g = plot(g_data_bhs, g_data_ssmd, 'go');
temp_hitlist = handles.datablock(handles.pind_unique+1,[3,5,6,7]); %Save the cmpd_id, its ssmd, its BHS, and number of observations
%Now let's remove any duplicates and sort the results!
[~,ia] = sort(temp_hitlist(:,1));
handles.hitlist = temp_hitlist(ia,:); %We have now compiled a list of hits that should be sorted and unique, next step is to plot it!
hitlist_output = formatHitlist(handles.hitlist); %Now let's output the formatted string to the listbox;
set(handles.listbox1,'String',hitlist_output);
set(handles.text3,'String',['# of hits: ' num2str(size(hitlist_output,1))]);
guidata(hObject, handles);

function [output] = formatHitlist(hitlist);
%This function will take a cell array and concatenate the rows together
output = cell(size(hitlist,1),1);
for i = 1:size(hitlist,1)
    temp = hitlist(i,:);
    output{i} = horzcat(temp{1},' ',num2str(temp{2}),' ',num2str(temp{3}),' ',num2str(temp{4}));
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = ['Selected Hits - ' date];
fullname = fullfile(handles.hitListFolder,fname);
xlswrite(fullname,[handles.hitlist_header;handles.hitlist]);
msgbox(['File has been saved! Find it at: ' fullname]);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
handles.hitlist = [];
handles.g = [];
handles.pind_unique = [];
cla(handles.axes1);
[handles.xax, handles.yax] = plotScreenData(hObject, handles, handles.ssmd, handles.bhs);hold on; %Now we overlay the selected data over the old data
set(handles.listbox1,'String',''); set(handles.text3,'String','# of hits: 0');
guidata(hObject,handles);

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
