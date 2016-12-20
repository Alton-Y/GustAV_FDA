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

% Last Modified by GUIDE v2.5 19-Dec-2016 19:18:08

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
whitebg(hObject,'k');
hObject.Color = [0,0,0];

% fcnINIT initializes the figures and axes for data display
handles.MSG = [];                      
handles = fcnINIT( handles );



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
handles.CurrentIdx = round(get(hObject,'Value'));
handles.CurrentDatenum = handles.plotDatenumArray(handles.CurrentIdx);
% guidata(hObject, handles);
handles.CurrentIdx
set(handles.TXT_Frame,'String',sprintf('%i/%i',handles.CurrentIdx,length(handles.plotDatenumArray)));
fcnUPDATE(handles,handles.CurrentIdx);
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

function sliderUpdate(handles)
% Setting the Slider Min and Max
sliderMin = 1;
sliderMax = length(handles.plotDatenumArray);
set(handles.slider1,'Value',sliderMin);
set(handles.slider1,'Min',sliderMin);
set(handles.slider1,'Max',sliderMax);
set(handles.slider1,'SliderStep',[1/(sliderMax-sliderMin) 1/(sliderMax-sliderMin)]);
set(handles.TXT_Frame,'String',sprintf('1/%i',sliderMax));
fcnUPDATE(handles,1);



% --- Executes on button press in pushbutton2.
function BTN_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the Ardupilot Log File');
if FileName ~= 0
    % if FileName is both non-zero
    [handles] = GuiMSG(handles,sprintf('LOADING %s ...',FileName));
    INFO.timezone = 0;
    handles.fps = 15;
    try
        [INFO, FMT] = fcnFMTLOAD(INFO,PathName,FileName,16);%16.33
        [INFO] = fcnGETINFO(INFO, FMT);
        
        %Assign FMT to the main workspace.
        assignin('base','FMT',FMT);
        
        handles.DATA.INFO = INFO;
        %Assign INFO to the main workspace.
        assignin('base','INFO',INFO);
        
        handles.DATA.FMT = FMT;
        handles.plotDatenumArray = fcnGETFRAMES(handles.DATA.INFO.startTimeLOCAL,handles.DATA.INFO.endTimeLOCAL,handles.fps);
        handles.DATA.SYNCFMT = fcnSYNCFMT( handles.DATA.FMT, handles.plotDatenumArray );
        handles = fcnFLTPATH(handles);
        
        %Assign INFO to the main workspace.
        assignin('base','SYNCFMT',handles.DATA.SYNCFMT);
        
        handles.TXT_startTime.String = datestr(handles.plotDatenumArray(1),'yy-mm-dd HH:MM:SS');
        handles.TXT_endTime.String = datestr(handles.plotDatenumArray(end),'yy-mm-dd HH:MM:SS');
        
        try
            [handles] = GuiMSG(handles,'');
            [handles] = GuiMSG(handles,sprintf('LOAD COMPLETE: %s',FileName));
            [handles] = GuiMSG(handles,sprintf('FRAME COUNT at %.0f fps: %i',handles.fps,length(handles.plotDatenumArray)));
            [handles] = GuiMSG(handles,'');
            handles.popupmenu1.Enable = 'on';
            handles.slider1.Enable = 'on';
        end
    catch
        [handles] = GuiMSG(handles,sprintf('LOAD ERROR: %s',FileName));
        handles.popupmenu1.Enable = 'off';
        handles.slider1.Enable = 'off';
    end
    
    sliderUpdate(handles);
    fcnUPDATE(handles,1)
    %update GUI structure
    guidata(hObject, handles);
    %Assign FMT to the main workspace.
    assignin('base','handles',handles);
    
    
    % Update popupmenu1
    fullLogDuration = datestr(INFO.endTimeLOCAL-INFO.startTimeLOCAL,'MM:SS');
    % [isSeg, startDatenum, endDatenum]
    segSelect(1,:) = [0 INFO.endTimeLOCAL,INFO.startTimeLOCAL];
    popupmenuStr = {sprintf('Full (%s)',fullLogDuration)};
    for flt = 1:length(INFO.flight.durationS)
        popupmenuStr{flt+1} = sprintf('#%02.f (%s)',flt,...
            datestr(INFO.flight.durationS(flt)./86400,'MM:SS'));
        segSelect(flt+1,:) = [0 INFO.flight.startTimeLOCAL(flt),INFO.flight.endTimeLOCAL(flt)];
    end
    len = length(popupmenuStr)+1;
    for seg = 1:length(INFO.segment.durationS)
        if INFO.segment.durationS(seg) > 0
        popupmenuStr{len} = sprintf('%s (%s)',INFO.segment.modeAbbr{seg},...
            datestr(INFO.segment.durationS(seg)./86400,'MM:SS'));
        INFO.segment.durationS(seg);
        segSelect(len,:) = [1 INFO.segment.startTimeLOCAL(seg),INFO.segment.endTimeLOCAL(seg)];
        len = len + 1;
        end
    end
    set(handles.popupmenu1,'Value',1);
    set(handles.popupmenu1,'String',popupmenuStr);
    
    handles.segSelect = segSelect;
    %update GUI structure
    guidata(hObject, handles);
end





% --- Executes on button press in BTN_reset.
function BTN_reset_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.MSG = [];
[handles] = GuiMSG(handles,'RESET');
handles.DATA = [];
handles.DISP = [];
handles = fcnINIT( handles );
handles.popupmenu1.Enable = 'off';
handles.slider1.Enable = 'off';
%update GUI structure
guidata(hObject, handles);
    



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject.Value == 1
    startTime = handles.DATA.INFO.startTimeLOCAL;
    endTime = handles.DATA.INFO.endTimeLOCAL;
else
    startTime = handles.segSelect(hObject.Value,2)
    endTime = handles.segSelect(hObject.Value,3)
    handles = updateRange(handles,startTime,endTime);
    guidata(hObject, handles);
end
handles = updateRange(handles,startTime,endTime);
guidata(hObject, handles);


% % % % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
% % % %        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, ~, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [handles] = updateRange(handles,startTime,endTime)
handles.plotDatenumArray = fcnGETFRAMES(startTime,endTime,handles.fps);
handles.TXT_startTime.String = datestr(handles.plotDatenumArray(1),'yy-mm-dd HH:MM:SS');
handles.TXT_endTime.String = datestr(handles.plotDatenumArray(end),'yy-mm-dd HH:MM:SS');
handles.DATA.SYNCFMT = fcnSYNCFMT( handles.DATA.FMT, handles.plotDatenumArray );
%Assign INFO to the main workspace.
assignin('base','SYNCFMT',handles.DATA.SYNCFMT);
handles = fcnFLTPATH(handles);
sliderUpdate(handles);



