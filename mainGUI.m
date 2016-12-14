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

% Last Modified by GUIDE v2.5 14-Dec-2016 14:29:54

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
fcnINIT( handles )
return

%%
% Temporary LOADING Script
% Data SETUP
% basefolder = '/Users/altonyeung/Google Drive/Ryerson UAV/Flights/2016-12-03';
basefolder = 'C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2016-12-10';
INFO.timezone = 0;
% Pixhawk FMT
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(1),16.33);
[ INFO ] = fcnGETINFO( INFO, FMT );
% Video
% vidPath = sprintf('%s/Videos/PICT0002.avi',basefolder);
% load(strrep(vidPath,'.avi','.mat'));
% vidObj = VideoReader(sprintf('%s/Videos/PICT0002.AVI',basefolder));
%%
handles.plotFPS = 15;
% MODE 2 - Setup by Pixhawk time
plotStartDatenum = INFO.flight.startTimeLOCAL(1)-5/86400;
% % Calculate the playback end datenum
plotEndDatenum = INFO.flight.endTimeLOCAL(1)+25/86400;
% % Create array to hold the datenum of each playback frame
handles.plotDatenumArray = (plotStartDatenum:1/handles.plotFPS/86400:plotEndDatenum)';
% % Create array to hold video time
% handles.videoTimeArray = (handles.plotDatenumArray - videoStartDatenum).* 86400;
% % interp1 FMT to match the frames
handles.SYNCFMT = fcnSYNCFMT( FMT, handles.plotDatenumArray );

 
handles.INFO = INFO;
handles.FMT = FMT;
% [handles.SYNCFMT.GPS.X, handles.SYNCFMT.GPS.Y] = mfwdtran(handles.tGPS.mstruct, handles.SYNCFMT.GPS.Lat, handles.SYNCFMT.GPS.Lng);

% Setting the Slider Min and Max
sliderMin = 1;
sliderMax = length(handles.plotDatenumArray);
set(handles.slider1,'Value',sliderMin);
set(handles.slider1,'Min',sliderMin);
set(handles.slider1,'Max',sliderMax);
set(handles.slider1,'SliderStep',[1/(sliderMax-sliderMin) 1/(sliderMax-sliderMin)]);



% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% UPDATE FCN
function updateFcn(hObject, eventdata, handles)

FMT = handles.FMT;
n = handles.CurrentIdx;
currentFrameDatenum = handles.plotDatenumArray(n);
%%% test only, print datestr format of current frame time


%% TOP
airtimeDatenum = currentFrameDatenum-handles.INFO.flight.startTimeLOCAL(1);
if airtimeDatenum > 0
    airtimeDatestr = datestr(airtimeDatenum,'MM:SS');
else
    airtimeDatestr = '00:00';
end

handles.tTOP.UTC.String = datestr(currentFrameDatenum,'HH:MM:SS');
currentFrameDatevec = datevec(currentFrameDatenum);
handles.tTOP.EST.String = sprintf('%02.f:%02.f',mod(currentFrameDatevec(4)-5,24),currentFrameDatevec(5));
handles.tTOP.AIRTIME.String = airtimeDatestr;
handles.tTOP.UASTIME.String = sprintf('%-5.1f',(currentFrameDatenum-handles.INFO.pixhawkstart)*86400);
% handles.tTOP.CAMTIME.String = sprintf('%-5.1f',(handles.videoTimeArray(handles.CurrentIdx)));


%% PFD
% Set String to ARSP
handles.tPFD2.ARSP.String = sprintf('% 3.1f',handles.SYNCFMT.ARSP.Airspeed(n));
handles.tPFD2.BARO.String = sprintf('% 3.0f',handles.SYNCFMT.BARO.Alt(n));
handles.tPFD.GS.String   = sprintf('% 3.1f',handles.SYNCFMT.GPS.Spd(n));

ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};

handles.hSPD.YLim = [handles.SYNCFMT.ARSP.Airspeed(n)-5 handles.SYNCFMT.ARSP.Airspeed(n)+5];
handles.hALT.YLim = [handles.SYNCFMT.BARO.Alt(n)-25 handles.SYNCFMT.BARO.Alt(n)+25];

% Target Altitude
try
    if handles.SYNCFMT.TECS.hdem(n) > handles.hALT.YLim(2)
        TGTALT = handles.hALT.YLim(2);
    elseif handles.SYNCFMT.TECS.hdem(n) < handles.hALT.YLim(1)
        TGTALT = handles.hALT.YLim(1);
    else
        TGTALT = handles.SYNCFMT.TECS.hdem(n);
    end
    
    % Write String Target ALT
    if isnan(handles.SYNCFMT.TECS.hdem(n)) ~= 1
        handles.tPFD.TGTALTTXT.String = sprintf('% 3.0f',handles.SYNCFMT.TECS.hdem(n));
        handles.tPFD.TGTALTBOX.EdgeColor = 'm';
    else
        handles.tPFD.TGTALTTXT.String = '----';
        handles.tPFD.TGTALTBOX.EdgeColor = [0.3 0.3 0.3];
        TGTALT = -999;
    end
catch
    TGTALT = nan;
end

% Plot Target Altitude on ALT TAPE
handles.tALT.TGTALTTAPE.XData = [-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
handles.tALT.TGTALTTAPE.YData = TGTALT+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0];



% Target SPD
try
    if handles.SYNCFMT.TECS.spdem(n) > handles.hSPD.YLim(2)
        TGTSPD = handles.hSPD.YLim(2);
    elseif handles.SYNCFMT.TECS.spdem(n) < handles.hSPD.YLim(1)
        TGTSPD = handles.hSPD.YLim(1);
    else
        TGTSPD = handles.SYNCFMT.TECS.spdem(n);
    end
    % Write String Target SPD
    if isnan(handles.SYNCFMT.TECS.spdem(n)) ~= 1
        handles.tPFD.TGTSPDTXT.String = sprintf('% 3.1f',handles.SYNCFMT.TECS.spdem(n));
        handles.tPFD.TGTSPDBOX.EdgeColor = 'm';
    else
        handles.tPFD.TGTSPDTXT.String = '---';
        handles.tPFD.TGTSPDBOX.EdgeColor = [0.3 0.3 0.3];
        TGTSPD = -999;
    end
    % Plot Target Altitude on ALT TAPE
    handles.tSPD.TGTSPDTAPE.XData = -[-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
    handles.tSPD.TGTSPDTAPE.YData = TGTSPD+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0]./5;
catch
    TGTSPD = nan;
end


try
    if isnan(handles.SYNCFMT.MODE.ModeNum(n)) == 1
        handles.tPFD.MODE.String = 'MANUAL';
        handles.tPFD.MODE.FontSize = 18;
        handles.tPFD.MODE.Margin = 4;
    elseif handles.SYNCFMT.MODE.ModeNum(n) ~= 8
        handles.tPFD.MODE.String = ModeAbbr{handles.SYNCFMT.MODE.ModeNum(n)+1};
        handles.tPFD.MODE.FontSize = 18;
        handles.tPFD.MODE.Margin = 4;
    else
        if handles.SYNCFMT.ATRP.Type(n) == 0
            autotuneMode = 'ROLL';
        elseif handles.SYNCFMT.ATRP.Type(n) == 1
            autotuneMode = 'PITCH';
        else
            autotuneMode = '';
        end
        handles.tPFD.MODE.String = sprintf('AUTOTUNE\n%s',autotuneMode);
        handles.tPFD.MODE.FontSize = 12;
        handles.tPFD.MODE.Margin = 3;
    end
catch
    handles.tPFD.MODE.String = 'MANUAL';
    handles.tPFD.MODE.FontSize = 18;
    handles.tPFD.MODE.Margin = 4;
end



%% ATT
%     PlotATT(hATT,handles.SYNCFMT.ATT.Roll(n),handles.SYNCFMT.ATT.Pitch(n));
pitch_scale = -1/25;%45;
x = 10;
y = 10;
x2 = 0.5;
sky_x = [-x -x x x;-x -x x x];
sky_y = [0 y y 0;0 -y -y 0];
[sky_th, sky_r] = cart2pol(sky_x,sky_y);
sky_th = sky_th + deg2rad(handles.SYNCFMT.ATT.Roll(n));
[sky_x,sky_y] = pol2cart(sky_th,sky_r);
sky_y = sky_y + handles.SYNCFMT.ATT.Pitch(n)*pitch_scale;
line_scale = repmat([1;0.5],19,2);
line_x = repmat([-x2 x2],37,1).*line_scale(1:end-1,:);
line_y = [-90:5:90;-90:5:90]'.*pitch_scale;
[line_th, line_r] = cart2pol(line_x,line_y);
line_th = line_th + deg2rad(handles.SYNCFMT.ATT.Roll(n));
[line_x,line_y] = pol2cart(line_th,line_r);
line_y = line_y + handles.SYNCFMT.ATT.Pitch(n)*pitch_scale;

handles.tATT.SKY.XData = sky_x(1,:);
handles.tATT.SKY.YData = sky_y(1,:);
handles.tATT.GND.XData = sky_x(2,:);
handles.tATT.GND.YData = sky_y(2,:);
handles.tATT.LINE.XData = reshape([line_x,nan(length(line_x(:,1)),1)]',[],1);
handles.tATT.LINE.YData = reshape([line_y,nan(length(line_y(:,1)),1)]',[],1);

handles.tATT.t_roll.String = sprintf('%.1f',handles.SYNCFMT.ATT.Roll(n));
handles.tATT.t_pitch.String = sprintf('%.1f',handles.SYNCFMT.ATT.Pitch(n));
%% GPS
% handles.tGPS.POS.XData = handles.SYNCFMT.GPS.X(n);
% handles.tGPS.POS.YData = handles.SYNCFMT.GPS.Y(n);
%     PlotNAV(hNAV,handles.SYNCFMT.GPS.Lat,handles.SYNCFMT.GPS.Lng(n))

%% FCTL


% Down is positive
% If defection is +ve, display DN, else display UP
defELEV = (handles.SYNCFMT.RCOU.C2(n)-1600)/18.242;
if defELEV > 0
    signELEV = 'DN';
else
    signELEV = 'UP';
end
% If defection is +ve, display DN, else display UP
defLAIL = (handles.SYNCFMT.RCOU.C5(n)-1360)/-13.299;
if defLAIL > 0
    signLAIL = 'DN';
else
    signLAIL = 'UP';
end
% If defection is +ve, display DN, else display UP
defRAIL = (handles.SYNCFMT.RCOU.C7(n)-1540)/16.436;
if defRAIL > 0
    signRAIL = 'DN';
else
    signRAIL = 'UP';
end

% Set String to deflection deg UP/DN
handles.tFCTL.ELEVDEF.String = sprintf('% 3.1f^{o} %s',abs(defELEV),signELEV);
handles.tFCTL.LAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defLAIL),signLAIL);
handles.tFCTL.RAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defRAIL),signRAIL);



% Set String to RC IN RAW
handles.tFCTL.AILRAW.String = sprintf('%i',handles.SYNCFMT.RCIN.C1(n));
handles.tFCTL.ELERAW.String = sprintf('%i',handles.SYNCFMT.RCIN.C2(n));
handles.tFCTL.THRRAW.String = sprintf('%i',handles.SYNCFMT.RCIN.C3(n));
handles.tFCTL.RUDRAW.String = sprintf('%i',handles.SYNCFMT.RCIN.C4(n));

% Set String to RC IN PERC
AILPERC = (handles.SYNCFMT.RCIN.C1(n)-1500)/-4;
ELEPERC = (handles.SYNCFMT.RCIN.C2(n)-1500)/4;
THRPERC = (handles.SYNCFMT.RCIN.C3(n)-1100)/8;
RUDPERC = (handles.SYNCFMT.RCIN.C4(n)-1500)/4;
handles.tFCTL.AILPERC.String = sprintf('% 4.0f%%',AILPERC);
handles.tFCTL.ELEPERC.String = sprintf('% 4.0f%%',ELEPERC);
handles.tFCTL.THRPERC.String = sprintf('% 4.0f%%',THRPERC);
handles.tFCTL.RUDPERC.String = sprintf('% 4.0f%%',RUDPERC);

% Servo Position

% Left Aileron Servo Position  [-7 -15]
%     handles.tFCTL.LAILPOS.YData = [defLAIL defLAIL];
%     handles.tFCTL.RAILPOS = plot(handle,[43 45],-[11 11],'-g','LineWidth',4);
% Normalize RAIL SERVO DEFLECTION
if handles.SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM > 0
    NORMRAIL = (handles.SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MAX-FMT.PARM.RC5_TRIM);
else
    NORMRAIL = -(handles.SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MIN-FMT.PARM.RC5_TRIM);
end
if abs(NORMRAIL) > 0.9
    handles.tFCTL.RAILPOS.Color = 'r';
elseif abs(NORMRAIL) < 0.1
    handles.tFCTL.RAILPOS.Color = [0 0.75 0];
else
    handles.tFCTL.RAILPOS.Color = 'g';
end
handles.tFCTL.RAILPOS.YData = -[NORMRAIL NORMRAIL].*8/2-11;

% Normalize LAIL SERVO DEFLECTION
if handles.SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM > 0
    NORMLAIL = (handles.SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MAX-FMT.PARM.RC7_TRIM);
else
    NORMLAIL = -(handles.SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MIN-FMT.PARM.RC7_TRIM);
end
if abs(NORMLAIL) > 0.9
    handles.tFCTL.LAILPOS.Color = 'r';
elseif abs(NORMLAIL) < 0.1
    handles.tFCTL.LAILPOS.Color = [0 0.75 0];
else
    handles.tFCTL.LAILPOS.Color = 'g';
end
handles.tFCTL.LAILPOS.YData = [NORMLAIL NORMLAIL].*8/2-11;

% Normalize ELEV SERVO DEFLECTION
if handles.SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM > 0
    NORMELEV = -(handles.SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MAX-FMT.PARM.RC2_TRIM);
else
    NORMELEV = (handles.SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MIN-FMT.PARM.RC2_TRIM);
end
if abs(NORMELEV) > 0.9
    handles.tFCTL.ELEVPOS.Color = 'r';
elseif abs(NORMELEV) < 0.1
    handles.tFCTL.ELEVPOS.Color = [0 0.75 0];
else
    handles.tFCTL.ELEVPOS.Color = 'g';
end
handles.tFCTL.ELEVPOS.YData = [NORMELEV NORMELEV].*(21-13)./2-17;

% Normalize RUDR SERVO DEFLECTION
%     if handles.SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM > 0
%         NORMRUDR = (handles.SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MAX-FMT.PARM.RC4_TRIM);
%     else
%         NORMRUDR = (handles.SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MIN-FMT.PARM.RC4_TRIM);
%     end
NORMRUDR = RUDPERC./100;
if abs(NORMRUDR) > 0.9
    handles.tFCTL.RUDRPOS.Color = 'r';
elseif abs(NORMRUDR) < 0.1
    handles.tFCTL.RUDRPOS.Color = [0 0.75 0];
else
    handles.tFCTL.RUDRPOS.Color = 'g';
end
handles.tFCTL.RUDRPOS.XData = [NORMRUDR NORMRUDR].*6+25;



% Set RAW STICK POS
% Left Stick  X: 15.*[0 1]+8   Y: -14.*[0 1 1 0 0]-26
% Left Stick X (RUDDER)
handles.tFCTL.LSCROSS.XData = 15.*(max(min(RUDPERC,100),-100)/200+0.5)+8;
handles.tFCTL.LSCROSS.YData = -14.*(-max(min(THRPERC,100),0)/100+1)-26;
% Right Stick X: 15.*[0 1]+27  Y: -14.*[0 1 1 0 0]-26
handles.tFCTL.RSCROSS.XData = 15.*(max(min(AILPERC,100),-100)/200+0.5)+27;
handles.tFCTL.RSCROSS.YData = -14.*(max(min(-ELEPERC,100),-100)/200+0.5)-26;

try
    currentMode = handles.SYNCFMT.MODE.ModeNum(n);
catch
    currentMode = 0;
end

if isnan(currentMode) == 1 || currentMode == 0
    handles.tFCTL.LSCROSS.CData = [0 1 0];
    handles.tFCTL.RSCROSS.CData = [0 1 0];
else
    handles.tFCTL.LSCROSS.CData = [1 1 0];
    handles.tFCTL.RSCROSS.CData = [1 1 0];
end

%% ENG

% Calculate THR %
THROUTPERC = max((handles.SYNCFMT.RCOU.C3(n)-1100)/8,0);

handles.tENG.THRPERC.String = sprintf('% 5.1f',THROUTPERC);

handles.tENG.BATUSED.String = sprintf('% 5.0f',handles.SYNCFMT.CURR.CurrTot(n));

scale = 6;
a = scale*1.0;
s = 1.25;
f = 20;
OX = 15;
OY = -8.5;

angRing = s.*pi.*[1:-2/f:(1-THROUTPERC/100),(1-THROUTPERC/100)];

% Ring Background
handles.tENG.THRRING.XData = [0 a*cos(angRing);]+OX;
handles.tENG.THRRING.YData = [0 a*sin(angRing);]+OY;
% Green Line
handles.tENG.THRLINE.XData = OX+[0 a*cos(s*pi*(1-THROUTPERC/100))];
handles.tENG.THRLINE.YData = OY+[0 a*sin(s*pi*(1-THROUTPERC/100))];
handles.tENG.THRLINE.Color = [0 1 0];
% Blue Dot
handles.tENG.BLUEDOT.XData = OX+(a+0.5)*cos(s*pi*(1-max(min(THRPERC,100.5),-3)/100));
handles.tENG.BLUEDOT.YData = OY+(a+0.5)*sin(s*pi*(1-max(min(THRPERC,100.5),-3)/100));

%% ELEC

handles.tELEC.BAT1V.String = sprintf('% 3.1f  V',handles.SYNCFMT.CURR.Volt(n));
handles.tELEC.BAT1A.String = sprintf('% 3.1f  A',handles.SYNCFMT.CURR.Curr(n));
handles.tELEC.BAT2V.String = sprintf('% 3.1f  V',handles.SYNCFMT.CUR2.Volt(n));
handles.tELEC.BAT2A.String = sprintf('% 3.1f  A',handles.SYNCFMT.CUR2.Curr(n));
if handles.SYNCFMT.STAT.Armed(n) == 1
    % Motor is ON
    set(handles.tELEC.BAT1ARW,'Color','g');
    set(handles.tELEC.MOTOR,'Color','g');
    set(handles.tELEC.MOTOROFF,'Visible','on');
    set(handles.tELEC.MOTORON,'Visible','on');
    set(handles.tELEC.MOTOROFF,'Visible','off');
elseif handles.SYNCFMT.STAT.Armed(n) == 0
    % Motor is OFF
    set(handles.tELEC.BAT1ARW,'Color','r');
    set(handles.tELEC.MOTOR,'Color','r');
    set(handles.tELEC.MOTORON,'Visible','off');
    set(handles.tELEC.MOTOROFF,'Visible','on');
else
    % Unknown
    set(handles.tELEC.BAT1ARW,'Color',[0.5 0.5 0.5]);
    set(handles.tELEC.MOTOR,'Color',[0.5 0.5 0.5]);
    set(handles.tELEC.MOTORON,'Visible','off');
    set(handles.tELEC.MOTOROFF,'Visible','on','Color',[0.5 0.5 0.5]);
end

if handles.SYNCFMT.STAT.Safety(n) > 0
    % Motor is ON
    set(handles.tELEC.BAT2ARW,'Color','g');
    set(handles.tELEC.SERVO,'Color','g');
    set(handles.tELEC.SERVOOFF,'Visible','on');
    set(handles.tELEC.SERVOON,'Visible','on');
    set(handles.tELEC.SERVOOFF,'Visible','off');
else
    % Unknown
    set(handles.tELEC.BAT2ARW,'Color',[0.5 0.5 0.5]);
    set(handles.tELEC.SERVO,'Color',[0.5 0.5 0.5]);
    set(handles.tELEC.SERVOON,'Visible','off');
    set(handles.tELEC.SERVOOFF,'Visible','on','Color',[0.5 0.5 0.5]);
end






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


updateFcn(hObject, eventdata, handles)
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
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CurrentIdx = max(min(round(get(handles.slider1,'Value'))+1,get(handles.slider1,'Max')),get(handles.slider1,'Min'));
set(handles.slider1,'Value',handles.CurrentIdx);
updateFcn(hObject, eventdata, handles);
