function varargout = mainGUI(varargin)
clc
% MAINGUI MATLAB code for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 14-Dec-2016 16:51:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
    'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)
handles.output = hObject;
% whitebg('k')
hObject.Color = [0,0,0];

% fcnINIT initializes the figures and axes for data display
handles.MSG = [];                      
handles = fcnINIT( handles );
handles
% % % % % % return
% % % % % % 
% % % % % % %%
% % % % % % % Temporary LOADING Script
% % % % % % % Data SETUP
% % % % % % % basefolder = '/Users/altonyeung/Google Drive/Ryerson UAV/Flights/2016-12-03';
% % % % % % basefolder = 'C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2016-12-10';
% % % % % % INFO.timezone = 0;
% % % % % % % Pixhawk FMT
% % % % % % pixhawkpath = sprintf('%s/Pixhawk',basefolder);
% % % % % % pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
% % % % % % [INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(1),16.33);
% % % % % % [ INFO ] = fcnGETINFO( INFO, FMT );
% % % % % % % Video
% % % % % % % vidPath = sprintf('%s/Videos/PICT0002.avi',basefolder);
% % % % % % % load(strrep(vidPath,'.avi','.mat'));
% % % % % % % vidObj = VideoReader(sprintf('%s/Videos/PICT0002.AVI',basefolder));
% % % % % % %%
% % % % % % handles.plotFPS = 15;
% % % % % % % MODE 2 - Setup by Pixhawk time
% % % % % % plotStartDatenum = INFO.flight.startTimeLOCAL(1)-5/86400;
% % % % % % % % Calculate the playback end datenum
% % % % % % plotEndDatenum = INFO.flight.endTimeLOCAL(1)+25/86400;
% % % % % % % % Create array to hold the datenum of each playback frame
% % % % % % handles.plotDatenumArray = (plotStartDatenum:1/handles.plotFPS/86400:plotEndDatenum)';
% % % % % % % % Create array to hold video time
% % % % % % % handles.videoTimeArray = (handles.plotDatenumArray - videoStartDatenum).* 86400;
% % % % % % % % interp1 FMT to match the frames
% % % % % % handles.SYNCFMT = fcnSYNCFMT( FMT, handles.plotDatenumArray );
% % % % % % 
% % % % % %  
% % % % % % handles.INFO = INFO;
% % % % % % handles.FMT = FMT;
% % % % % % % [handles.SYNCFMT.GPS.X, handles.SYNCFMT.GPS.Y] = mfwdtran(handles.tGPS.mstruct, handles.SYNCFMT.GPS.Lat, handles.SYNCFMT.GPS.Lng);
% % % % % % 
% % % % % % % Setting the Slider Min and Max
% % % % % % sliderMin = 1;
% % % % % % sliderMax = length(handles.plotDatenumArray);
% % % % % % set(handles.slider1,'Value',sliderMin);
% % % % % % set(handles.slider1,'Min',sliderMin);
% % % % % % set(handles.slider1,'Max',sliderMax);
% % % % % % set(handles.slider1,'SliderStep',[1/(sliderMax-sliderMin) 1/(sliderMax-sliderMin)]);
% % % % % % 


% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.text2.String = datestr(get(hObject,'Value'),'HH:MM:SS.FFF');
handles.CurrentIdx = round(get(hObject,'Value'));
handles.CurrentDatenum = handles.plotDatenumArray(handles.CurrentIdx);
set(handles.text2,'String',datestr(handles.CurrentDatenum,'HH:MM:SS.FFF'))
% guidata(hObject, handles);
handles.CurrentIdx


updateFcn(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
while handles.CurrentIdx < get(handles.slider1,'Max')
handles.CurrentIdx = max(min(round(get(handles.slider1,'Value'))+1,get(handles.slider1,'Max')),get(handles.slider1,'Min'));
set(handles.slider1,'Value',handles.CurrentIdx);
updateFcn(hObject, eventdata, handles);
pause(1/handles.plotFPS)
end

% --- Executes on button press in pushbutton2.
function BTN_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the Ardupilot Log File');
if FileName ~= 0
    % if FileName is both non-zero
    [handles] = GuiMSG(handles,sprintf('LOAD %s',FileName));
    INFO.timezone = 0;
    [INFO, FMT] = fcnFMTLOAD(INFO,PathName,FileName,16);%16.33
    handles.DATA.INFO = INFO;
    handles.DATA.FMT = FMT;
    
    
    
    %update GUI structure
    guidata(hObject, handles);
    
end
