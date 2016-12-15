function [  ] = fcnUPDATE(handles,n)
%FCNUPDATE Summary of this function goes here
%   Detailed explanation goes here
FMT = handles.DATA.FMT;
SYNCFMT = handles.DATA.SYNCFMT;
INFO = handles.DATA.INFO;

currentFrameDatenum = handles.plotDatenumArray(n);
%%% test only, print datestr format of current frame time


%% TOP
airtimeDatenum = currentFrameDatenum-INFO.flight.startTimeLOCAL(1);
if airtimeDatenum > 0
    airtimeDatestr = datestr(airtimeDatenum,'MM:SS');
else
    airtimeDatestr = '00:00';
end

handles.DISP.tTOP.UTC.String = datestr(currentFrameDatenum,'HH:MM:SS');
currentFrameDatevec = datevec(currentFrameDatenum);
handles.DISP.tTOP.EST.String = sprintf('%02.f:%02.f',mod(currentFrameDatevec(4)-5,24),currentFrameDatevec(5));
handles.DISP.tTOP.AIRTIME.String = airtimeDatestr;
handles.DISP.tTOP.UASTIME.String = sprintf('%-5.1f',(currentFrameDatenum-INFO.pixhawkstart)*86400);
% handles.DISP.tTOP.CAMTIME.String = sprintf('%-5.1f',(handles.videoTimeArray(handles.CurrentIdx)));


%% PFD
% Set String to ARSP
handles.DISP.tPFD2.ARSP.String = sprintf('% 3.1f',SYNCFMT.ARSP.Airspeed(n));
handles.DISP.tPFD2.BARO.String = sprintf('% 3.0f',SYNCFMT.BARO.Alt(n));
handles.DISP.tPFD.GS.String   = sprintf('% 3.1f',SYNCFMT.GPS.Spd(n));

ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
try
handles.DISP.hSPD.YLim = [SYNCFMT.ARSP.Airspeed(n)-5 SYNCFMT.ARSP.Airspeed(n)+5];
handles.DISP.hALT.YLim = [SYNCFMT.BARO.Alt(n)-25 SYNCFMT.BARO.Alt(n)+25];
end
% Target Altitude
try
    if SYNCFMT.TECS.hdem(n) > handles.DISP.hALT.YLim(2)
        TGTALT = handles.DISP.hALT.YLim(2);
    elseif SYNCFMT.TECS.hdem(n) < handles.DISP.hALT.YLim(1)
        TGTALT = handles.DISP.hALT.YLim(1);
    else
        TGTALT = SYNCFMT.TECS.hdem(n);
    end
    
    % Write String Target ALT
    if isnan(SYNCFMT.TECS.hdem(n)) ~= 1
        handles.DISP.tPFD.TGTALTTXT.String = sprintf('% 3.0f',SYNCFMT.TECS.hdem(n));
        handles.DISP.tPFD.TGTALTBOX.EdgeColor = 'm';
    else
        handles.DISP.tPFD.TGTALTTXT.String = '----';
        handles.DISP.tPFD.TGTALTBOX.EdgeColor = [0.3 0.3 0.3];
        TGTALT = -999;
    end
catch
    TGTALT = nan;
end


% VSI Green Line
pwr = 1/2.2;
VSI = -SYNCFMT.GPS.VZ(n);
if VSI<0
    VSIsign = -1;
else
    VSIsign = 1;
end
handles.DISP.tVSI.GREENLINE.YData = [0 VSIsign*(abs(VSI)^pwr)];




% Plot Target Altitude on ALT TAPE
handles.DISP.tALT.TGTALTTAPE.XData = [-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
handles.DISP.tALT.TGTALTTAPE.YData = TGTALT+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0];



% Target SPD
try
    if SYNCFMT.TECS.spdem(n) > handles.DISP.hSPD.YLim(2)
        TGTSPD = handles.DISP.hSPD.YLim(2);
    elseif SYNCFMT.TECS.spdem(n) < handles.DISP.hSPD.YLim(1)
        TGTSPD = handles.DISP.hSPD.YLim(1);
    else
        TGTSPD = SYNCFMT.TECS.spdem(n);
    end
    % Write String Target SPD
    if isnan(SYNCFMT.TECS.spdem(n)) ~= 1
        handles.DISP.tPFD.TGTSPDTXT.String = sprintf('% 3.1f',SYNCFMT.TECS.spdem(n));
        handles.DISP.tPFD.TGTSPDBOX.EdgeColor = 'm';
    else
        handles.DISP.tPFD.TGTSPDTXT.String = '---';
        handles.DISP.tPFD.TGTSPDBOX.EdgeColor = [0.3 0.3 0.3];
        TGTSPD = -999;
    end
    % Plot Target Altitude on ALT TAPE
    handles.DISP.tSPD.TGTSPDTAPE.XData = -[-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
    handles.DISP.tSPD.TGTSPDTAPE.YData = TGTSPD+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0]./5;
catch
    TGTSPD = nan;
end


try
    if isnan(SYNCFMT.MODE.ModeNum(n)) == 1
        handles.DISP.tPFD.MODE.String = 'MANUAL';
        handles.DISP.tPFD.MODE.FontSize = 18;
        handles.DISP.tPFD.MODE.Margin = 4;
    elseif SYNCFMT.MODE.ModeNum(n) ~= 8
        handles.DISP.tPFD.MODE.String = ModeAbbr{SYNCFMT.MODE.ModeNum(n)+1};
        handles.DISP.tPFD.MODE.FontSize = 18;
        handles.DISP.tPFD.MODE.Margin = 4;
    else
        if SYNCFMT.ATRP.Type(n) == 0
            autotuneMode = 'ROLL';
        elseif SYNCFMT.ATRP.Type(n) == 1
            autotuneMode = 'PITCH';
        else
            autotuneMode = '';
        end
        handles.DISP.tPFD.MODE.String = sprintf('AUTOTUNE\n%s',autotuneMode);
        handles.DISP.tPFD.MODE.FontSize = 12;
        handles.DISP.tPFD.MODE.Margin = 3;
    end
catch
    handles.DISP.tPFD.MODE.String = 'MANUAL';
    handles.DISP.tPFD.MODE.FontSize = 18;
    handles.DISP.tPFD.MODE.Margin = 4;
end



%% ATT
%     PlotATT(hATT,SYNCFMT.ATT.Roll(n),SYNCFMT.ATT.Pitch(n));
pitch_scale = -1/25;%45;
x = 10;
y = 10;
x2 = 0.5;
sky_x = [-x -x x x;-x -x x x];
sky_y = [0 y y 0;0 -y -y 0];
[sky_th, sky_r] = cart2pol(sky_x,sky_y);
sky_th = sky_th + deg2rad(SYNCFMT.ATT.Roll(n));
[sky_x,sky_y] = pol2cart(sky_th,sky_r);
sky_y = sky_y + SYNCFMT.ATT.Pitch(n)*pitch_scale;
line_scale = repmat([1;0.5],19,2);
line_x = repmat([-x2 x2],37,1).*line_scale(1:end-1,:);
line_y = [-90:5:90;-90:5:90]'.*pitch_scale;
[line_th, line_r] = cart2pol(line_x,line_y);
line_th = line_th + deg2rad(SYNCFMT.ATT.Roll(n));
[line_x,line_y] = pol2cart(line_th,line_r);
line_y = line_y + SYNCFMT.ATT.Pitch(n)*pitch_scale;

handles.DISP.tATT.SKY.XData = sky_x(1,:);
handles.DISP.tATT.SKY.YData = sky_y(1,:);
handles.DISP.tATT.GND.XData = sky_x(2,:);
handles.DISP.tATT.GND.YData = sky_y(2,:);
handles.DISP.tATT.LINE.XData = reshape([line_x,nan(length(line_x(:,1)),1)]',[],1);
handles.DISP.tATT.LINE.YData = reshape([line_y,nan(length(line_y(:,1)),1)]',[],1);

handles.DISP.tATT.t_roll.String = sprintf('%.1f',SYNCFMT.ATT.Roll(n));
handles.DISP.tATT.t_pitch.String = sprintf('%.1f',SYNCFMT.ATT.Pitch(n));
%% GPS
handles.DISP.tGPS.POS.XData = SYNCFMT.GPS.X(n);
handles.DISP.tGPS.POS.YData = SYNCFMT.GPS.Y(n);
% PlotNAV(hNAV,SYNCFMT.GPS.Lat,SYNCFMT.GPS.Lng(n))

%% FCTL


% Down is positive
% If defection is +ve, display DN, else display UP
defELEV = (SYNCFMT.RCOU.C2(n)-1600)/18.242;
if defELEV > 0
    signELEV = 'DN';
else
    signELEV = 'UP';
end
% If defection is +ve, display DN, else display UP
defLAIL = (SYNCFMT.RCOU.C5(n)-1360)/-13.299;
if defLAIL > 0
    signLAIL = 'DN';
else
    signLAIL = 'UP';
end
% If defection is +ve, display DN, else display UP
defRAIL = (SYNCFMT.RCOU.C7(n)-1540)/16.436;
if defRAIL > 0
    signRAIL = 'DN';
else
    signRAIL = 'UP';
end

% Set String to deflection deg UP/DN
handles.DISP.tFCTL.ELEVDEF.String = sprintf('% 3.1f^{o} %s',abs(defELEV),signELEV);
handles.DISP.tFCTL.LAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defLAIL),signLAIL);
handles.DISP.tFCTL.RAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defRAIL),signRAIL);



% Set String to RC IN RAW
handles.DISP.tFCTL.AILRAW.String = sprintf('%i',SYNCFMT.RCIN.C1(n));
handles.DISP.tFCTL.ELERAW.String = sprintf('%i',SYNCFMT.RCIN.C2(n));
handles.DISP.tFCTL.THRRAW.String = sprintf('%i',SYNCFMT.RCIN.C3(n));
handles.DISP.tFCTL.RUDRAW.String = sprintf('%i',SYNCFMT.RCIN.C4(n));

% Set String to RC IN PERC
AILPERC = (SYNCFMT.RCIN.C1(n)-1500)/-4;
ELEPERC = (SYNCFMT.RCIN.C2(n)-1500)/4;
THRPERC = (SYNCFMT.RCIN.C3(n)-1100)/8;
RUDPERC = (SYNCFMT.RCIN.C4(n)-1500)/4;
handles.DISP.tFCTL.AILPERC.String = sprintf('% 4.0f%%',AILPERC);
handles.DISP.tFCTL.ELEPERC.String = sprintf('% 4.0f%%',ELEPERC);
handles.DISP.tFCTL.THRPERC.String = sprintf('% 4.0f%%',THRPERC);
handles.DISP.tFCTL.RUDPERC.String = sprintf('% 4.0f%%',RUDPERC);

% Servo Position

% Left Aileron Servo Position  [-7 -15]
%     handles.DISP.tFCTL.LAILPOS.YData = [defLAIL defLAIL];
%     handles.DISP.tFCTL.RAILPOS = plot(handle,[43 45],-[11 11],'-g','LineWidth',4);
% Normalize RAIL SERVO DEFLECTION
if SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM > 0
    NORMRAIL = (SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MAX-FMT.PARM.RC5_TRIM);
else
    NORMRAIL = -(SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MIN-FMT.PARM.RC5_TRIM);
end
if abs(NORMRAIL) > 0.9
    handles.DISP.tFCTL.RAILPOS.Color = 'r';
elseif abs(NORMRAIL) < 0.1
    handles.DISP.tFCTL.RAILPOS.Color = [0 0.75 0];
else
    handles.DISP.tFCTL.RAILPOS.Color = 'g';
end
handles.DISP.tFCTL.RAILPOS.YData = -[NORMRAIL NORMRAIL].*8/2-11;

% Normalize LAIL SERVO DEFLECTION
if SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM > 0
    NORMLAIL = (SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MAX-FMT.PARM.RC7_TRIM);
else
    NORMLAIL = -(SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MIN-FMT.PARM.RC7_TRIM);
end
if abs(NORMLAIL) > 0.9
    handles.DISP.tFCTL.LAILPOS.Color = 'r';
elseif abs(NORMLAIL) < 0.1
    handles.DISP.tFCTL.LAILPOS.Color = [0 0.75 0];
else
    handles.DISP.tFCTL.LAILPOS.Color = 'g';
end
handles.DISP.tFCTL.LAILPOS.YData = [NORMLAIL NORMLAIL].*8/2-11;

% Normalize ELEV SERVO DEFLECTION
if SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM > 0
    NORMELEV = -(SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MAX-FMT.PARM.RC2_TRIM);
else
    NORMELEV = (SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MIN-FMT.PARM.RC2_TRIM);
end
if abs(NORMELEV) > 0.9
    handles.DISP.tFCTL.ELEVPOS.Color = 'r';
elseif abs(NORMELEV) < 0.1
    handles.DISP.tFCTL.ELEVPOS.Color = [0 0.75 0];
else
    handles.DISP.tFCTL.ELEVPOS.Color = 'g';
end
handles.DISP.tFCTL.ELEVPOS.YData = [NORMELEV NORMELEV].*(21-13)./2-17;

% Normalize RUDR SERVO DEFLECTION
%     if SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM > 0
%         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MAX-FMT.PARM.RC4_TRIM);
%     else
%         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MIN-FMT.PARM.RC4_TRIM);
%     end
NORMRUDR = RUDPERC./100;
if abs(NORMRUDR) > 0.9
    handles.DISP.tFCTL.RUDRPOS.Color = 'r';
elseif abs(NORMRUDR) < 0.1
    handles.DISP.tFCTL.RUDRPOS.Color = [0 0.75 0];
else
    handles.DISP.tFCTL.RUDRPOS.Color = 'g';
end
handles.DISP.tFCTL.RUDRPOS.XData = [NORMRUDR NORMRUDR].*6+25;



% Set RAW STICK POS
% Left Stick  X: 15.*[0 1]+8   Y: -14.*[0 1 1 0 0]-26
% Left Stick X (RUDDER)
handles.DISP.tFCTL.LSCROSS.XData = 15.*(max(min(RUDPERC,100),-100)/200+0.5)+8;
handles.DISP.tFCTL.LSCROSS.YData = -14.*(-max(min(THRPERC,100),0)/100+1)-26;
% Right Stick X: 15.*[0 1]+27  Y: -14.*[0 1 1 0 0]-26
handles.DISP.tFCTL.RSCROSS.XData = 15.*(max(min(AILPERC,100),-100)/200+0.5)+27;
handles.DISP.tFCTL.RSCROSS.YData = -14.*(max(min(-ELEPERC,100),-100)/200+0.5)-26;

try
    currentMode = SYNCFMT.MODE.ModeNum(n);
catch
    currentMode = 0;
end

if isnan(currentMode) == 1 || currentMode == 0
    handles.DISP.tFCTL.LSCROSS.CData = [0 1 0];
    handles.DISP.tFCTL.RSCROSS.CData = [0 1 0];
else
    handles.DISP.tFCTL.LSCROSS.CData = [1 1 0];
    handles.DISP.tFCTL.RSCROSS.CData = [1 1 0];
end

%% ENG

% Calculate THR %
THROUTPERC = max((SYNCFMT.RCOU.C3(n)-1100)/8,0);

handles.DISP.tENG.THRPERC.String = sprintf('% 5.1f',THROUTPERC);

handles.DISP.tENG.BATUSED.String = sprintf('% 5.0f',SYNCFMT.CURR.CurrTot(n));

scale = 6;
a = scale*1.0;
s = 1.25;
f = 20;
OX = 15;
OY = -8.5;

angRing = s.*pi.*[1:-2/f:(1-THROUTPERC/100),(1-THROUTPERC/100)];

% Ring Background
handles.DISP.tENG.THRRING.XData = [0 a*cos(angRing);]+OX;
handles.DISP.tENG.THRRING.YData = [0 a*sin(angRing);]+OY;
% Green Line
handles.DISP.tENG.THRLINE.XData = OX+[0 a*cos(s*pi*(1-THROUTPERC/100))];
handles.DISP.tENG.THRLINE.YData = OY+[0 a*sin(s*pi*(1-THROUTPERC/100))];
handles.DISP.tENG.THRLINE.Color = [0 1 0];
% Blue Dot
handles.DISP.tENG.BLUEDOT.XData = OX+(a+0.5)*cos(s*pi*(1-max(min(THRPERC,100.5),-3)/100));
handles.DISP.tENG.BLUEDOT.YData = OY+(a+0.5)*sin(s*pi*(1-max(min(THRPERC,100.5),-3)/100));

%% ELEC

handles.DISP.tELEC.BAT1V.String = sprintf('% 3.1f  V',SYNCFMT.CURR.Volt(n));
handles.DISP.tELEC.BAT1A.String = sprintf('% 3.1f  A',SYNCFMT.CURR.Curr(n));
handles.DISP.tELEC.BAT2V.String = sprintf('% 3.1f  V',SYNCFMT.CUR2.Volt(n));
handles.DISP.tELEC.BAT2A.String = sprintf('% 3.1f  A',SYNCFMT.CUR2.Curr(n));
if SYNCFMT.STAT.Armed(n) == 1
    % Motor is ON
    set(handles.DISP.tELEC.BAT1ARW,'Color','g');
    set(handles.DISP.tELEC.MOTOR,'Color','g');
    set(handles.DISP.tELEC.MOTOROFF,'Visible','on');
    set(handles.DISP.tELEC.MOTORON,'Visible','on');
    set(handles.DISP.tELEC.MOTOROFF,'Visible','off');
elseif SYNCFMT.STAT.Armed(n) == 0
    % Motor is OFF
    set(handles.DISP.tELEC.BAT1ARW,'Color','r');
    set(handles.DISP.tELEC.MOTOR,'Color','r');
    set(handles.DISP.tELEC.MOTORON,'Visible','off');
    set(handles.DISP.tELEC.MOTOROFF,'Visible','on');
else
    % Unknown
    set(handles.DISP.tELEC.BAT1ARW,'Color',[0.5 0.5 0.5]);
    set(handles.DISP.tELEC.MOTOR,'Color',[0.5 0.5 0.5]);
    set(handles.DISP.tELEC.MOTORON,'Visible','off');
    set(handles.DISP.tELEC.MOTOROFF,'Visible','on','Color',[0.5 0.5 0.5]);
end

if SYNCFMT.STAT.Safety(n) > 0
    % Motor is ON
    set(handles.DISP.tELEC.BAT2ARW,'Color','g');
    set(handles.DISP.tELEC.SERVO,'Color','g');
    set(handles.DISP.tELEC.SERVOOFF,'Visible','on');
    set(handles.DISP.tELEC.SERVOON,'Visible','on');
    set(handles.DISP.tELEC.SERVOOFF,'Visible','off');
else
    % Unknown
    set(handles.DISP.tELEC.BAT2ARW,'Color',[0.5 0.5 0.5]);
    set(handles.DISP.tELEC.SERVO,'Color',[0.5 0.5 0.5]);
    set(handles.DISP.tELEC.SERVOON,'Visible','off');
    set(handles.DISP.tELEC.SERVOOFF,'Visible','on','Color',[0.5 0.5 0.5]);
end

end

