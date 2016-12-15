clf
clear
clc


% Data SETUP
% basefolder = '/Users/altonyeung/Google Drive/Ryerson UAV/Flights/2016-12-03';
basefolder = 'C:\Users\Alton Yeung\Google Drive\Ryerson UAV\Flights\2016-12-03';
INFO.timezone = 0;

% Pixhawk FMT
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(2),16.33);
[ INFO ] = fcnGETINFO( INFO, FMT );
% Video

vidPath = sprintf('%s/Videos/PICT0002.avi',basefolder);
load(strrep(vidPath,'.avi','.mat'));
vidObj = VideoReader(sprintf('%s/Videos/PICT0002.AVI',basefolder));
clf


%% Plot SETUP
% Set playback plot frames per second
plotFPS = 15;

% % % % % % MODE 1 - Setup by video time
% % % % % Set playback start time with video file time in seconds
% % % % plotStartVideoTimeS = 980;%329.5;
% % % % % Set playback duration
% % % % plotDurationS = 5;
% % % % % Calculate the playback start datenum
% % % % plotStartDatenum = videoStartDatenum + plotStartVideoTimeS/86400;
% % % % % Calculate the playback end datenum
% % % % plotEndDatenum = plotStartDatenum + plotDurationS/86400;

% MODE 2 - Setup by Pixhawk time
plotStartDatenum = INFO.flight.startTimeLOCAL(1)-5/86400;
% Calculate the playback end datenum
plotEndDatenum = INFO.flight.endTimeLOCAL(1)+25/86400;
%%% test only
% plotEndDatenum = plotStartDatenum + 5/86400;




% Create array to hold the datenum of each playback frame
plotDatenumArray = (plotStartDatenum:1/plotFPS/86400:plotEndDatenum)';

% Create array to hold video time
videoTimeArray = (plotDatenumArray - videoStartDatenum).* 86400;

% interp1 FMT to match the frames
SYNCFMT = fcnSYNCFMT( FMT, plotDatenumArray );

% close(V)
% V = VideoWriter('newfile.mp4','MPEG-4');
% V.FrameRate = plotFPS;
% open(V)

%%
hMAIN = figure(1);
whitebg('k')
hMAIN.Position = [1940,200,1280,720];
% hMAIN.Position = [900,1600,1280,720];
% hMAIN.Position = [300,700, 800, 450];
hMAIN.Color = [0,0,0];
hTOP   = fcnSETFIG([0.00 0.90 1.00 0.10]);
hATT  = fcnSETFIG([0.55 0.53 0.15 0.27]);
hSPD  = fcnSETFIG([0.45 0.53 0.10 0.27]);
hALT  = fcnSETFIG([0.70 0.53 0.10 0.27]);


hPFD  = fcnSETFIG([0.50 0.45 0.25 0.45]);
hPFD.Visible = 'off';

hSTAT = fcnSETFIG([0.75 0.45 0.25 0.45]);
hFCTL = fcnSETFIG([0.00 0.00 0.25 0.45]);
hNAV  = fcnSETFIG([0.50 0.00 0.25 0.45]);
hENG  = fcnSETFIG([0.25 0.30 0.25 0.15]);
hELEC = fcnSETFIG([0.25 0.00 0.25 0.30]);
hGPS  = fcnSETFIG([0.75 0.00 0.25 0.45]);
hVID  = fcnSETFIG([0.00 0.45 0.50 0.45]);

%% TIME
% tTime = text(hTOP,1,0,'','FontSize',28,'FontName','Agency FB','VerticalAlignment','top');
tTOP  = PlotTOP(hTOP);
tELEC = PlotELEC(hELEC);
tFCTL = PlotFCTL(hFCTL);
tPFD  = PlotPFD(hPFD);
tGPS  = PlotGPS(hGPS,SYNCFMT);
tGPS.FLTPATH.Color = [1 1 1 0.2];
tENG  = PlotENG(hENG);
tSPD = PlotSPD(hSPD);
tALT = PlotALT(hALT);
tATT = PlotATT(hATT);
%%
% plotDatenumArray holds each frame's datenum for plotting
for n = 1:length(plotDatenumArray)
% n = 500
    % Find current frame time in datenum format
    currentFrameDatenum = plotDatenumArray(n);
    %%% test only, print datestr format of current frame time
    datestr(currentFrameDatenum,'HH:MM:SS.FFF');
    
    %% TOP
    airtimeDatenum = currentFrameDatenum-INFO.flight.startTimeLOCAL(1);
    if airtimeDatenum > 0
        airtimeDatestr = datestr(airtimeDatenum,'MM:SS');
    else
        airtimeDatestr = '00:00';
    end
    
    tTOP.UTC.String = datestr(currentFrameDatenum,'HH:MM:SS');
    currentFrameDatevec = datevec(currentFrameDatenum);
    tTOP.EST.String = sprintf('%02.f:%02.f',mod(currentFrameDatevec(4)-5,24),currentFrameDatevec(5));
    tTOP.AIRTIME.String = airtimeDatestr;
    tTOP.UASTIME.String = sprintf('%-5.1f',(currentFrameDatenum-INFO.pixhawkstart)*86400);
    tTOP.CAMTIME.String = sprintf('%-5.1f',(currentFrameDatenum-videoStartDatenum)*86400);
    
    
    %% PFD
    % Set String to ARSP
    tPFD.ARSP.String = sprintf('% 3.1f',SYNCFMT.ARSP.Airspeed(n));
    tPFD.BARO.String = sprintf('% 3.0f',SYNCFMT.BARO.Alt(n));
    tPFD.GS.String   = sprintf('% 3.1f',SYNCFMT.GPS.Spd(n));
    
    ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
    
    hSPD.YLim = [SYNCFMT.ARSP.Airspeed(n)-5 SYNCFMT.ARSP.Airspeed(n)+5];
    hALT.YLim = [SYNCFMT.BARO.Alt(n)-25 SYNCFMT.BARO.Alt(n)+25];
    
    % Target Altitude
    if SYNCFMT.TECS.hdem(n) > hALT.YLim(2)
        TGTALT = hALT.YLim(2);
    elseif SYNCFMT.TECS.hdem(n) < hALT.YLim(1)
        TGTALT = hALT.YLim(1);
    else
        TGTALT = SYNCFMT.TECS.hdem(n);
    end
    
    % Write String Target ALT
    if isnan(SYNCFMT.TECS.hdem(n)) ~= 1
        tPFD.TGTALTTXT.String = sprintf('% 3.0f',SYNCFMT.TECS.hdem(n));
        tPFD.TGTALTBOX.EdgeColor = 'm';
    else
        tPFD.TGTALTTXT.String = '----';
        tPFD.TGTALTBOX.EdgeColor = [0.3 0.3 0.3];
        TGTALT = -999;
    end
    
    % Plot Target Altitude on ALT TAPE
    tALT.TGTALTTAPE.XData = [-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
    tALT.TGTALTTAPE.YData = TGTALT+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0];
    
    
    
    % Target SPD
    if SYNCFMT.TECS.spdem(n) > hSPD.YLim(2)
        TGTSPD = hSPD.YLim(2);
    elseif SYNCFMT.TECS.spdem(n) < hSPD.YLim(1)
        TGTSPD = hSPD.YLim(1);
    else
        TGTSPD = SYNCFMT.TECS.spdem(n);
    end
    % Write String Target SPD
    if isnan(SYNCFMT.TECS.spdem(n)) ~= 1
        tPFD.TGTSPDTXT.String = sprintf('% 3.1f',SYNCFMT.TECS.spdem(n));
        tPFD.TGTSPDBOX.EdgeColor = 'm';
    else
        tPFD.TGTSPDTXT.String = '---';
        tPFD.TGTSPDBOX.EdgeColor = [0.3 0.3 0.3];
        TGTSPD = -999;
    end
    % Plot Target Altitude on ALT TAPE
    tSPD.TGTSPDTAPE.XData = -[-0.42 -0.35 -0.35 -0.45 -0.45 -0.35 -0.35 -0.42 1];
    tSPD.TGTSPDTAPE.YData = TGTSPD+[0    -2    -3.5  -3.5   3.5  3.5 2 0 0]./5;
    
    
    
    if isnan(SYNCFMT.MODE.ModeNum(n)) == 1
        tPFD.MODE.String = 'MANUAL';
        tPFD.MODE.FontSize = 18;
        tPFD.MODE.Margin = 4;
    elseif SYNCFMT.MODE.ModeNum(n) ~= 8
        tPFD.MODE.String = ModeAbbr{SYNCFMT.MODE.ModeNum(n)+1};
        tPFD.MODE.FontSize = 18;
        tPFD.MODE.Margin = 4;
    else
        tPFD.MODE.String = sprintf('AUTOTUNE\nMODE');
        tPFD.MODE.FontSize = 12;
        tPFD.MODE.Margin = 3;
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
    
    tATT.SKY.XData = sky_x(1,:);
    tATT.SKY.YData = sky_y(1,:);
    tATT.GND.XData = sky_x(2,:);
    tATT.GND.YData = sky_y(2,:);
    tATT.LINE.XData = reshape([line_x,nan(length(line_x(:,1)),1)]',[],1);
    tATT.LINE.YData = reshape([line_y,nan(length(line_y(:,1)),1)]',[],1);
    
    tATT.t_roll.String = sprintf('%.1f',SYNCFMT.ATT.Roll(n));
    tATT.t_pitch.String = sprintf('%.1f',SYNCFMT.ATT.Pitch(n));
    %% GPS
    [tGPS.POS.XData,tGPS.POS.YData] = mfwdtran(tGPS.mstruct, SYNCFMT.GPS.Lat(n), SYNCFMT.GPS.Lng(n));
    %     PlotNAV(hNAV,SYNCFMT.GPS.Lat,SYNCFMT.GPS.Lng(n))
    
    %% FCTL
    
    fcnTITLE( hFCTL, 'FCTL' )
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
    tFCTL.ELEVDEF.String = sprintf('% 3.1f^{o} %s',abs(defELEV),signELEV);
    tFCTL.LAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defLAIL),signLAIL);
    tFCTL.RAILDEF.String = sprintf('% 3.1f^{o} %s',abs(defRAIL),signRAIL);
    
    
    
    % Set String to RC IN RAW
    tFCTL.AILRAW.String = sprintf('%i',SYNCFMT.RCIN.C1(n));
    tFCTL.ELERAW.String = sprintf('%i',SYNCFMT.RCIN.C2(n));
    tFCTL.THRRAW.String = sprintf('%i',SYNCFMT.RCIN.C3(n));
    tFCTL.RUDRAW.String = sprintf('%i',SYNCFMT.RCIN.C4(n));
    
    % Set String to RC IN PERC
    AILPERC = (SYNCFMT.RCIN.C1(n)-1500)/-4;
    ELEPERC = (SYNCFMT.RCIN.C2(n)-1500)/4;
    THRPERC = (SYNCFMT.RCIN.C3(n)-1100)/8;
    RUDPERC = (SYNCFMT.RCIN.C4(n)-1500)/4;
    tFCTL.AILPERC.String = sprintf('% 4.0f%%',AILPERC);
    tFCTL.ELEPERC.String = sprintf('% 4.0f%%',ELEPERC);
    tFCTL.THRPERC.String = sprintf('% 4.0f%%',THRPERC);
    tFCTL.RUDPERC.String = sprintf('% 4.0f%%',RUDPERC);
    
    % Servo Position
    
    % Left Aileron Servo Position  [-7 -15]
    %     tFCTL.LAILPOS.YData = [defLAIL defLAIL];
    %     tFCTL.RAILPOS = plot(handle,[43 45],-[11 11],'-g','LineWidth',4);
    % Normalize RAIL SERVO DEFLECTION
    if SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM > 0
        NORMRAIL = (SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MAX-FMT.PARM.RC5_TRIM);
    else
        NORMRAIL = -(SYNCFMT.RCOU.C5(n)-FMT.PARM.RC5_TRIM)/(FMT.PARM.RC5_MIN-FMT.PARM.RC5_TRIM);
    end
    if abs(NORMRAIL) > 0.9
        tFCTL.RAILPOS.Color = 'r';
    elseif abs(NORMRAIL) < 0.1
        tFCTL.RAILPOS.Color = [0 0.75 0];
    else
        tFCTL.RAILPOS.Color = 'g';
    end
    tFCTL.RAILPOS.YData = -[NORMRAIL NORMRAIL].*8/2-11;
    
    % Normalize LAIL SERVO DEFLECTION
    if SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM > 0
        NORMLAIL = (SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MAX-FMT.PARM.RC7_TRIM);
    else
        NORMLAIL = -(SYNCFMT.RCOU.C7(n)-FMT.PARM.RC7_TRIM)/(FMT.PARM.RC7_MIN-FMT.PARM.RC7_TRIM);
    end
    if abs(NORMLAIL) > 0.9
        tFCTL.LAILPOS.Color = 'r';
    elseif abs(NORMLAIL) < 0.1
        tFCTL.LAILPOS.Color = [0 0.75 0];
    else
        tFCTL.LAILPOS.Color = 'g';
    end
    tFCTL.LAILPOS.YData = [NORMLAIL NORMLAIL].*8/2-11;
    
    % Normalize ELEV SERVO DEFLECTION
    if SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM > 0
        NORMELEV = -(SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MAX-FMT.PARM.RC2_TRIM);
    else
        NORMELEV = (SYNCFMT.RCOU.C2(n)-FMT.PARM.RC2_TRIM)/(FMT.PARM.RC2_MIN-FMT.PARM.RC2_TRIM);
    end
    if abs(NORMELEV) > 0.9
        tFCTL.ELEVPOS.Color = 'r';
    elseif abs(NORMELEV) < 0.1
        tFCTL.ELEVPOS.Color = [0 0.75 0];
    else
        tFCTL.ELEVPOS.Color = 'g';
    end
    tFCTL.ELEVPOS.YData = [NORMELEV NORMELEV].*(21-13)./2-17;
    
    % Normalize RUDR SERVO DEFLECTION
    %     if SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM > 0
    %         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MAX-FMT.PARM.RC4_TRIM);
    %     else
    %         NORMRUDR = (SYNCFMT.RCOU.C4(n)-FMT.PARM.RC4_TRIM)/(FMT.PARM.RC4_MIN-FMT.PARM.RC4_TRIM);
    %     end
    NORMRUDR = RUDPERC./100;
    if abs(NORMRUDR) > 0.9
        tFCTL.RUDRPOS.Color = 'r';
    elseif abs(NORMRUDR) < 0.1
        tFCTL.RUDRPOS.Color = [0 0.75 0];
    else
        tFCTL.RUDRPOS.Color = 'g';
    end
    tFCTL.RUDRPOS.XData = [NORMRUDR NORMRUDR].*6+25;
    
    
    
    % Set RAW STICK POS
    % Left Stick  X: 15.*[0 1]+8   Y: -14.*[0 1 1 0 0]-26
    % Left Stick X (RUDDER)
    tFCTL.LSCROSS.XData = 15.*(max(min(RUDPERC,100),-100)/200+0.5)+8;
    tFCTL.LSCROSS.YData = -14.*(-max(min(THRPERC,100),0)/100+1)-26;
    % Right Stick X: 15.*[0 1]+27  Y: -14.*[0 1 1 0 0]-26
    tFCTL.RSCROSS.XData = 15.*(max(min(AILPERC,100),-100)/200+0.5)+27;
    tFCTL.RSCROSS.YData = -14.*(max(min(-ELEPERC,100),-100)/200+0.5)-26;
    
    if isnan(SYNCFMT.MODE.ModeNum(n)) == 1 || SYNCFMT.MODE.ModeNum(n) == 0
        tFCTL.LSCROSS.CData = [0 1 0];
        tFCTL.RSCROSS.CData = [0 1 0];
    else
        tFCTL.LSCROSS.CData = [1 1 0];
        tFCTL.RSCROSS.CData = [1 1 0];
    end
    
    
    
    %% ENG
    fcnTITLE( hENG, 'ENG' )
    % Calculate THR %
    THROUTPERC = max((SYNCFMT.RCOU.C3(n)-1100)/8,0);

    tENG.THRPERC.String = sprintf('% 5.1f',THROUTPERC);
    
    tENG.BATUSED.String = sprintf('% 5.0f',SYNCFMT.CURR.CurrTot(n));

    scale = 6;
    a = scale*1.0;
    b = scale*0.9;
    c = scale*1.01;
    s = 1.25;
    f = 20;
    OX = 15;
    OY = -8.5;
    
    angRing = s.*pi.*[1:-2/f:(1-THROUTPERC/100),(1-THROUTPERC/100)];

    % Ring Background
    tENG.THRRING.XData = [0 a*cos(angRing);]+OX;
    tENG.THRRING.YData = [0 a*sin(angRing);]+OY;
    % Green Line
    tENG.THRLINE.XData = OX+[0 a*cos(s*pi*(1-THROUTPERC/100))];
    tENG.THRLINE.YData = OY+[0 a*sin(s*pi*(1-THROUTPERC/100))];
    % Blue Dot
    tENG.BLUEDOT.XData = OX+(a+0.5)*cos(s*pi*(1-max(min(THRPERC,100.5),-3)/100));
    tENG.BLUEDOT.YData = OY+(a+0.5)*sin(s*pi*(1-max(min(THRPERC,100.5),-3)/100));
    
    
    
    
    
    %% ELEC
    fcnTITLE( hELEC, 'ELEC' )
    tELEC.BAT1V.String = sprintf('% 3.1f  V',SYNCFMT.CURR.Volt(n));
    tELEC.BAT1A.String = sprintf('% 3.1f  A',SYNCFMT.CURR.Curr(n));
    tELEC.BAT2V.String = sprintf('% 3.1f  V',SYNCFMT.CUR2.Volt(n));
    tELEC.BAT2A.String = sprintf('% 3.1f  A',SYNCFMT.CUR2.Curr(n));
    if SYNCFMT.STAT.Armed(n) == 1
        % Motor is ON
        set(tELEC.BAT1ARW,'Color','g');
        set(tELEC.MOTOR,'Color','g');
        set(tELEC.MOTOROFF,'Visible','on');
        set(tELEC.MOTORON,'Visible','on');
        set(tELEC.MOTOROFF,'Visible','off');
    elseif SYNCFMT.STAT.Armed(n) == 0
        % Motor is OFF
        set(tELEC.BAT1ARW,'Color','r');
        set(tELEC.MOTOR,'Color','r');
        set(tELEC.MOTORON,'Visible','off');
        set(tELEC.MOTOROFF,'Visible','on');
    else
        % Unknown
        set(tELEC.BAT1ARW,'Color',[0.5 0.5 0.5]);
        set(tELEC.MOTOR,'Color',[0.5 0.5 0.5]);
        set(tELEC.MOTORON,'Visible','off');
        set(tELEC.MOTOROFF,'Visible','on','Color',[0.5 0.5 0.5]);
    end
    
    if SYNCFMT.STAT.Safety(n) > 0
        % Motor is ON
        set(tELEC.BAT2ARW,'Color','g');
        set(tELEC.SERVO,'Color','g');
        set(tELEC.SERVOOFF,'Visible','on');
        set(tELEC.SERVOON,'Visible','on');
        set(tELEC.SERVOOFF,'Visible','off');
    else
        % Unknown
        set(tELEC.BAT2ARW,'Color',[0.5 0.5 0.5]);
        set(tELEC.SERVO,'Color',[0.5 0.5 0.5]);
        set(tELEC.SERVOON,'Visible','off');
        set(tELEC.SERVOOFF,'Visible','on','Color',[0.5 0.5 0.5]);
    end
    
    %% VIDEO
    % Set the video time for playback by subtracting offset from current frame datenum
    vidObj.CurrentTime = videoTimeArray(n);
    %
    %
    %
    % Temporary storing the frame image data for cropping
    videoFrame = readFrame(vidObj);
    % Crop and plot video frame image data
    image(hVID,videoFrame(1:640,:,:));
    % Remove ticks from image plot
    set(hVID,'XTick',[],'YTick',[])
    
    
    %% test only, pause plotting
    %         pause(0.01)
    %         drawnow
    % %     frame = getframe(hMAIN);
    % writeVideo(V,getframe(hMAIN));
    % pause(0.000000001)
end
% 
% close(V)
