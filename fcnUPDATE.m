function [  ] = fcnUPDATE(handles,n)
%FCNUPDATE Summary of this function goes here
%   Detailed explanation goes here
FMT = handles.DATA.FMT;
SYNCFMT = handles.DATA.SYNCFMT;
INFO = handles.DATA.INFO;
DISP = handles.DISP;
currentFrameDatenum = handles.plotDatenumArray(n);
%%% test only, print datestr format of current frame time


%% TOP
airtimeDatenum = currentFrameDatenum-INFO.flight.startTimeLOCAL(1);
if airtimeDatenum > 0
    airtimeDatestr = datestr(airtimeDatenum,'MM:SS');
else
    airtimeDatestr = '00:00';
end

DISP.tTOP.UTC.String = datestr(currentFrameDatenum,'HH:MM:SS');
currentFrameDatevec = datevec(currentFrameDatenum);
DISP.tTOP.EST.String = sprintf('%02.f:%02.f',mod(currentFrameDatevec(4)-5,24),currentFrameDatevec(5));
DISP.tTOP.AIRTIME.String = airtimeDatestr;
DISP.tTOP.UASTIME.String = sprintf('%-5.1f',(currentFrameDatenum-INFO.pixhawkstart)*86400);
% DISP.tTOP.CAMTIME.String = sprintf('%-5.1f',(handles.videoTimeArray(handles.CurrentIdx)));


%% PFD
% FD - Flight Director (center: 25,-23.5)

try
    mode = SYNCFMT.MODE.ModeNum(n);
catch
    mode = 0;
end

if mode > 0
    % FD ROLL
    DesRoll = handles.DATA.SYNCFMT.ATT.DesRoll(n);
    Roll = handles.DATA.SYNCFMT.ATT.Roll(n);
    FDROLL = min(max(DesRoll - Roll,-35),35);
    % FD PITCH
    DesPitch = handles.DATA.SYNCFMT.ATT.DesPitch(n);
    Pitch = handles.DATA.SYNCFMT.ATT.Pitch(n);
    FDPITCH = min(max(DesPitch - Pitch,-35),35);
else
    FDROLL = nan;
    FDPITCH = nan;
end
FDSCALE = 5;
DISP.tPFD2.FDROLL.XData = [FDROLL FDROLL]./FDSCALE+25;
DISP.tPFD2.FDPITCH.YData = (-23.5+[FDPITCH FDPITCH]./FDSCALE);
% tPFD2.FDROLL  = plot(handle,[25 25],-[17 31],'-m','LineWidth',2);
% tPFD2.FDPITCH = plot(handle,[17 33],-[24 24],'-m','LineWidth',2);
%


% Set String to ARSP
DISP.tPFD2.ARSP.String = sprintf('% 3.1f',SYNCFMT.ARSP.Airspeed(n));
DISP.tPFD2.BARO.String = sprintf('% 3.0f',SYNCFMT.BARO.Alt(n));
DISP.tPFD.GS.String   = sprintf('% 3.1f',SYNCFMT.GPS.Spd(n));

ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
try
    DISP.hSPD.YLim = [SYNCFMT.ARSP.Airspeed(n)-5 SYNCFMT.ARSP.Airspeed(n)+5];
    DISP.hALT.YLim = [SYNCFMT.BARO.Alt(n)-25 SYNCFMT.BARO.Alt(n)+25];
end
% Target Altitude
try
    if SYNCFMT.TECS.hdem(n) > DISP.hALT.YLim(2)
        TGTALT = DISP.hALT.YLim(2);
    elseif SYNCFMT.TECS.hdem(n) < DISP.hALT.YLim(1)
        TGTALT = DISP.hALT.YLim(1);
    else
        TGTALT = SYNCFMT.TECS.hdem(n);
    end
    
    % Write String Target ALT
    if isnan(SYNCFMT.TECS.hdem(n)) ~= 1
        DISP.tPFD.TGTALTTXT.String = sprintf('% 3.0f',SYNCFMT.TECS.hdem(n));
        DISP.tPFD.TGTALTBOX.EdgeColor = 'm';
    else
        DISP.tPFD.TGTALTTXT.String = '----';
        DISP.tPFD.TGTALTBOX.EdgeColor = [0.3 0.3 0.3];
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
DISP.tVSI.GREENLINE.YData = [0 VSIsign*(abs(VSI)^pwr)];


% HSI Heading Indicator
MAG = SYNCFMT.ATT.Yaw(n);
TRK = SYNCFMT.GPS.GCrs(n);
% Avoid TRK flickering, if GS < 1m/s, TRK = MAG
if SYNCFMT.GPS.Spd(n) < 1
    TRK = MAG;
end
% MAG Heading
DISP.hHSI.XLim = [MAG-24 MAG+24];
% TRK Heading
DISP.tHSI.TRK.XData = [-360 0 360]+TRK;


% Plot Target Altitude on ALT TAPE
DISP.tALT.TGTALTTAPE.XData = [-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
DISP.tALT.TGTALTTAPE.YData = TGTALT+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0];

% SPD Protection
ARSPD_FBW_MAX = handles.DATA.SYNCFMT.PARM.ARSPD_FBW_MAX;
ARSPD_FBW_MIN = handles.DATA.SYNCFMT.PARM.ARSPD_FBW_MIN;
DISP.tSPD.SPDPROT.YData = [-999 ARSPD_FBW_MIN ARSPD_FBW_MIN nan ARSPD_FBW_MAX ARSPD_FBW_MAX 999];
DISP.tSPD.SPDPROT.Color = [1 0 0];
% Target SPD
try
    if SYNCFMT.TECS.spdem(n) > DISP.hSPD.YLim(2)
        TGTSPD = DISP.hSPD.YLim(2);
    elseif SYNCFMT.TECS.spdem(n) < DISP.hSPD.YLim(1)
        TGTSPD = DISP.hSPD.YLim(1);
    else
        TGTSPD = SYNCFMT.TECS.spdem(n);
    end
    % Write String Target SPD
    if isnan(SYNCFMT.TECS.spdem(n)) ~= 1
        DISP.tPFD.TGTSPDTXT.String = sprintf('% 3.1f',SYNCFMT.TECS.spdem(n));
        DISP.tPFD.TGTSPDBOX.EdgeColor = 'm';
    else
        DISP.tPFD.TGTSPDTXT.String = '---';
        DISP.tPFD.TGTSPDBOX.EdgeColor = [0.3 0.3 0.3];
        TGTSPD = -999;
    end
    % Plot Target Altitude on ALT TAPE
    DISP.tSPD.TGTSPDTAPE.XData = -[-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
    DISP.tSPD.TGTSPDTAPE.YData = TGTSPD+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0]./5;
catch
    TGTSPD = nan;
end


try
    if isnan(SYNCFMT.MODE.ModeNum(n)) == 1
        DISP.tPFD.MODE.String = 'MANUAL';
        DISP.tPFD.MODE.FontSize = 18;
        DISP.tPFD.MODE.Margin = 4;
    elseif SYNCFMT.MODE.ModeNum(n) ~= 8
        DISP.tPFD.MODE.String = ModeAbbr{SYNCFMT.MODE.ModeNum(n)+1};
        DISP.tPFD.MODE.FontSize = 18;
        DISP.tPFD.MODE.Margin = 4;
    else
        if SYNCFMT.ATRP.Type(n) == 0
            autotuneMode = 'ROLL';
        elseif SYNCFMT.ATRP.Type(n) == 1
            autotuneMode = 'PITCH';
        else
            autotuneMode = '';
        end
        DISP.tPFD.MODE.String = sprintf('AUTOTUNE\n%s',autotuneMode);
        DISP.tPFD.MODE.FontSize = 12;
        DISP.tPFD.MODE.Margin = 3;
    end
catch
    DISP.tPFD.MODE.String = 'MANUAL';
    DISP.tPFD.MODE.FontSize = 18;
    DISP.tPFD.MODE.Margin = 4;
end



%% ATT

    
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
    
    DISP.tATT.SKY.XData = sky_x(1,:);
    DISP.tATT.SKY.YData = sky_y(1,:);
    DISP.tATT.GND.XData = sky_x(2,:);
    DISP.tATT.GND.YData = sky_y(2,:);
    DISP.tATT.LINE.XData = reshape([line_x,nan(length(line_x(:,1)),1)]',[],1);
    DISP.tATT.LINE.YData = reshape([line_y,nan(length(line_y(:,1)),1)]',[],1);
    
    DISP.tATT.t_roll.String = sprintf('%.1f',SYNCFMT.ATT.Roll(n));
    DISP.tATT.t_pitch.String = sprintf('%.1f',SYNCFMT.ATT.Pitch(n));




%%% GPS
try
    DISP.tGPS.POS.XData = SYNCFMT.GPS.X(n);
    DISP.tGPS.POS.YData = SYNCFMT.GPS.Y(n);
end




%% NAV
% % tNAV = DISP.tNAV;
% % MAG = SYNCFMT.ATT.Yaw(n);
% % textBearing = [0:10:350]+(MAG);
% % angMark = [2*pi:-2*pi/72:0]'-deg2rad(MAG);
% %
% % % X Y for Markers
% % markX = tNAV.X0+(repmat([tNAV.outerRad tNAV.innerRad nan],73,1).*repmat(tNAV.Xscale.*sin(angMark),1,3))';
% % markY = tNAV.Y0+(repmat([tNAV.outerRad tNAV.innerRad nan],73,1).*repmat(tNAV.Yscale.*cos(angMark),1,3))';
% %
% % tNAV.MARKER.XData = markX(:);
% % tNAV.MARKER.YData = markY(:);
% %
% %
% % % X Y for Heading Text
% % textX = tNAV.X0+tNAV.textRad*tNAV.Xscale*sin(angMark);
% % textY = tNAV.Y0+tNAV.textRad*tNAV.Yscale*cos(angMark);
% % for n = 1:36
% %     tNAV.HDGTEXT(n).Position(1) = textX(n*2-1);
% %     tNAV.HDGTEXT(n).Position(2) = textY(n*2-1);
% %     tNAV.HDGTEXT(n).Rotation = textBearing(n);
% % end




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
DISP.tFCTL.ELEVDEF.String = sprintf('% 3.1f^{o} %s',abs(defELEV),signELEV);
DISP.tFCTL.LAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defLAIL),signLAIL);
DISP.tFCTL.RAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defRAIL),signRAIL);



% Set String to RC IN RAW
DISP.tFCTL.AILRAW.String = sprintf('%i',SYNCFMT.RCIN.C1(n));
DISP.tFCTL.ELERAW.String = sprintf('%i',SYNCFMT.RCIN.C2(n));
DISP.tFCTL.THRRAW.String = sprintf('%i',SYNCFMT.RCIN.C3(n));
DISP.tFCTL.RUDRAW.String = sprintf('%i',SYNCFMT.RCIN.C4(n));

% Set String to RC IN PERC
AILPERC = (SYNCFMT.RCIN.C1(n)-1500)/-4;
ELEPERC = (SYNCFMT.RCIN.C2(n)-1500)/4;
THRPERC = (SYNCFMT.RCIN.C3(n)-1100)/8;
RUDPERC = (SYNCFMT.RCIN.C4(n)-1500)/4;
DISP.tFCTL.AILPERC.String = sprintf('% 4.0f%%',AILPERC);
DISP.tFCTL.ELEPERC.String = sprintf('% 4.0f%%',ELEPERC);
DISP.tFCTL.THRPERC.String = sprintf('% 4.0f%%',THRPERC);
DISP.tFCTL.RUDPERC.String = sprintf('% 4.0f%%',RUDPERC);

% Servo Position

% Left Aileron Servo Position  [-7 -15]
%     DISP.tFCTL.LAILPOS.YData = [defLAIL defLAIL];
%     DISP.tFCTL.RAILPOS = plot(handle,[43 45],-[11 11],'-g','LineWidth',4);
% Normalize RAIL SERVO DEFLECTION
if SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM > 0
    NORMRAIL = (SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MAX-FMT.PARM.RC5_TRIM);
else
    NORMRAIL = -(SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MIN-FMT.PARM.RC5_TRIM);
end
if abs(NORMRAIL) > 0.9
    DISP.tFCTL.RAILPOS.Color = 'r';
elseif abs(NORMRAIL) < 0.1
    DISP.tFCTL.RAILPOS.Color = [0 0.75 0];
else
    DISP.tFCTL.RAILPOS.Color = 'g';
end
DISP.tFCTL.RAILPOS.YData = -[NORMRAIL NORMRAIL].*8/2-11;

% Normalize LAIL SERVO DEFLECTION
if SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM > 0
    NORMLAIL = (SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MAX-FMT.PARM.RC7_TRIM);
else
    NORMLAIL = -(SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MIN-FMT.PARM.RC7_TRIM);
end
if abs(NORMLAIL) > 0.9
    DISP.tFCTL.LAILPOS.Color = 'r';
elseif abs(NORMLAIL) < 0.1
    DISP.tFCTL.LAILPOS.Color = [0 0.75 0];
else
    DISP.tFCTL.LAILPOS.Color = 'g';
end
DISP.tFCTL.LAILPOS.YData = [NORMLAIL NORMLAIL].*8/2-11;

% Normalize ELEV SERVO DEFLECTION
if SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM > 0
    NORMELEV = -(SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MAX-FMT.PARM.RC2_TRIM);
else
    NORMELEV = (SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MIN-FMT.PARM.RC2_TRIM);
end
if abs(NORMELEV) > 0.9
    DISP.tFCTL.ELEVPOS.Color = 'r';
elseif abs(NORMELEV) < 0.1
    DISP.tFCTL.ELEVPOS.Color = [0 0.75 0];
else
    DISP.tFCTL.ELEVPOS.Color = 'g';
end
DISP.tFCTL.ELEVPOS.YData = [NORMELEV NORMELEV].*(21-13)./2-17;

% Normalize RUDR SERVO DEFLECTION
%     if SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM > 0
%         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MAX-FMT.PARM.RC4_TRIM);
%     else
%         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MIN-FMT.PARM.RC4_TRIM);
%     end
NORMRUDR = RUDPERC./100;
if abs(NORMRUDR) > 0.9
    DISP.tFCTL.RUDRPOS.Color = 'r';
elseif abs(NORMRUDR) < 0.1
    DISP.tFCTL.RUDRPOS.Color = [0 0.75 0];
else
    DISP.tFCTL.RUDRPOS.Color = 'g';
end
DISP.tFCTL.RUDRPOS.XData = [NORMRUDR NORMRUDR].*6+25;



% Set RAW STICK POS
% Left Stick  X: 15.*[0 1]+8   Y: -14.*[0 1 1 0 0]-26
% Left Stick X (RUDDER)
DISP.tFCTL.LSCROSS.XData = 15.*(max(min(RUDPERC,100),-100)/200+0.5)+8;
DISP.tFCTL.LSCROSS.YData = -14.*(-max(min(THRPERC,100),0)/100+1)-26;
% Right Stick X: 15.*[0 1]+27  Y: -14.*[0 1 1 0 0]-26
DISP.tFCTL.RSCROSS.XData = 15.*(max(min(AILPERC,100),-100)/200+0.5)+27;
DISP.tFCTL.RSCROSS.YData = -14.*(max(min(-ELEPERC,100),-100)/200+0.5)-26;

try
    currentMode = SYNCFMT.MODE.ModeNum(n);
catch
    currentMode = 0;
end

if isnan(currentMode) == 1 || currentMode == 0
    DISP.tFCTL.LSCROSS.CData = [0 1 0];
    DISP.tFCTL.RSCROSS.CData = [0 1 0];
else
    DISP.tFCTL.LSCROSS.CData = [1 1 0];
    DISP.tFCTL.RSCROSS.CData = [1 1 0];
end

%% ENG

% Calculate THR %
THROUTPERC = max((SYNCFMT.RCOU.C3(n)-1100)/8,0);

DISP.tENG.THRPERC.String = sprintf('% 5.1f',THROUTPERC);

DISP.tENG.BATUSED.String = sprintf('% 5.0f',SYNCFMT.CURR.CurrTot(n));

scale = 6;
a = scale*1.0;
s = 1.25;
f = 20;
OX = 15;
OY = -8.5;

angRing = s.*pi.*[1:-2/f:(1-THROUTPERC/100),(1-THROUTPERC/100)];

% Ring Background
DISP.tENG.THRRING.XData = [0 a*cos(angRing);]+OX;
DISP.tENG.THRRING.YData = [0 a*sin(angRing);]+OY;
% Green Line
DISP.tENG.THRLINE.XData = OX+[0 a*cos(s*pi*(1-THROUTPERC/100))];
DISP.tENG.THRLINE.YData = OY+[0 a*sin(s*pi*(1-THROUTPERC/100))];
DISP.tENG.THRLINE.Color = [0 1 0];
% Blue Dot
DISP.tENG.BLUEDOT.XData = OX+(a+0.5)*cos(s*pi*(1-max(min(THRPERC,100.5),-3)/100));
DISP.tENG.BLUEDOT.YData = OY+(a+0.5)*sin(s*pi*(1-max(min(THRPERC,100.5),-3)/100));

%% ELEC

DISP.tELEC.BAT1V.String = sprintf('% 3.1f  V',SYNCFMT.CURR.Volt(n));
DISP.tELEC.BAT1A.String = sprintf('% 3.1f  A',SYNCFMT.CURR.Curr(n));
DISP.tELEC.BAT2V.String = sprintf('% 3.1f  V',SYNCFMT.CUR2.Volt(n));
DISP.tELEC.BAT2A.String = sprintf('% 3.1f  A',SYNCFMT.CUR2.Curr(n));
if SYNCFMT.STAT.Armed(n) == 1
    % Motor is ON
    set(DISP.tELEC.BAT1ARW,'Color','g');
    set(DISP.tELEC.MOTOR,'Color','g');
    set(DISP.tELEC.MOTOROFF,'Visible','on');
    set(DISP.tELEC.MOTORON,'Visible','on');
    set(DISP.tELEC.MOTOROFF,'Visible','off');
elseif SYNCFMT.STAT.Armed(n) == 0
    % Motor is OFF
    set(DISP.tELEC.BAT1ARW,'Color','r');
    set(DISP.tELEC.MOTOR,'Color','r');
    set(DISP.tELEC.MOTORON,'Visible','off');
    set(DISP.tELEC.MOTOROFF,'Visible','on');
else
    % Unknown
    set(DISP.tELEC.BAT1ARW,'Color',[0.5 0.5 0.5]);
    set(DISP.tELEC.MOTOR,'Color',[0.5 0.5 0.5]);
    set(DISP.tELEC.MOTORON,'Visible','off');
    set(DISP.tELEC.MOTOROFF,'Visible','on','Color',[0.5 0.5 0.5]);
end

if SYNCFMT.STAT.Safety(n) > 0
    % Motor is ON
    set(DISP.tELEC.BAT2ARW,'Color','g');
    set(DISP.tELEC.SERVO,'Color','g');
    set(DISP.tELEC.SERVOOFF,'Visible','on');
    set(DISP.tELEC.SERVOON,'Visible','on');
    set(DISP.tELEC.SERVOOFF,'Visible','off');
else
    % Unknown
    set(DISP.tELEC.BAT2ARW,'Color',[0.5 0.5 0.5]);
    set(DISP.tELEC.SERVO,'Color',[0.5 0.5 0.5]);
    set(DISP.tELEC.SERVOON,'Visible','off');
    set(DISP.tELEC.SERVOOFF,'Visible','on','Color',[0.5 0.5 0.5]);
end


%% STAT
if SYNCFMT.NKF4.PI(n) == 0
    DISP.tSTAT.IMU1.Color = 'g';
    DISP.tSTAT.IMU1.LineWidth = 1;
    DISP.tSTAT.IMU2.Color = [0.5 0.5 0.5];
    DISP.tSTAT.IMU2.LineWidth = 0.5;
elseif SYNCFMT.NKF4.PI(n) == 1
    DISP.tSTAT.IMU1.Color = [0.5 0.5 0.5];
    DISP.tSTAT.IMU1.LineWidth = 0.5;
    DISP.tSTAT.IMU2.Color = 'g';
    DISP.tSTAT.IMU2.LineWidth = 1;
else
    DISP.tSTAT.IMU1.Color = [0.5 0.5 0.5];
    DISP.tSTAT.IMU2.Color = [0.5 0.5 0.5];
    DISP.tSTAT.IMU1.LineWidth = 0.5;
    DISP.tSTAT.IMU2.LineWidth = 0.5;
end

% NKF4 IMU1 HEALTH
DISP.tSTAT.SV1.String = sprintf('%.2f',SYNCFMT.NKF4.SV(n));
DISP.tSTAT.SV1.Color = fcnNKFSTAT(SYNCFMT.NKF4.SV(n));
DISP.tSTAT.SP1.String = sprintf('%.2f',SYNCFMT.NKF4.SP(n));
DISP.tSTAT.SP1.Color = fcnNKFSTAT(SYNCFMT.NKF4.SP(n));
DISP.tSTAT.SH1.String = sprintf('%.2f',SYNCFMT.NKF4.SH(n));
DISP.tSTAT.SH1.Color = fcnNKFSTAT(SYNCFMT.NKF4.SH(n));
DISP.tSTAT.SM1.String = sprintf('%.2f',SYNCFMT.NKF4.SM(n));
DISP.tSTAT.SM1.Color = fcnNKFSTAT(SYNCFMT.NKF4.SM(n));
DISP.tSTAT.SVT1.String = sprintf('%.2f',SYNCFMT.NKF4.SVT(n));
DISP.tSTAT.SVT1.Color = fcnNKFSTAT(SYNCFMT.NKF4.SVT(n));

% NKF9 IMU2 HEALTH
DISP.tSTAT.SV2.String = sprintf('%.2f',SYNCFMT.NKF9.SV(n));
DISP.tSTAT.SV2.Color = fcnNKFSTAT(SYNCFMT.NKF9.SV(n));
DISP.tSTAT.SP2.String = sprintf('%.2f',SYNCFMT.NKF9.SP(n));
DISP.tSTAT.SP2.Color = fcnNKFSTAT(SYNCFMT.NKF9.SP(n));
DISP.tSTAT.SH2.String = sprintf('%.2f',SYNCFMT.NKF9.SH(n));
DISP.tSTAT.SH2.Color = fcnNKFSTAT(SYNCFMT.NKF9.SH(n));
DISP.tSTAT.SM2.String = sprintf('%.2f',SYNCFMT.NKF9.SM(n));
DISP.tSTAT.SM2.Color = fcnNKFSTAT(SYNCFMT.NKF9.SM(n));
DISP.tSTAT.SVT2.String = sprintf('%.2f',SYNCFMT.NKF9.SVT(n));
DISP.tSTAT.SVT2.Color = fcnNKFSTAT(SYNCFMT.NKF9.SVT(n));

end









