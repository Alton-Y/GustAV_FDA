function [ INFO ] = fcnGETINFO( INFO, FMT )
%FCNGETINFO Summary of this function goes here
%   Detailed explanation goes here
flagError = 0;
if isfield(FMT,'GPS') == 0
    % No GPS DATA FOUND
    INFO.statusGPS = -1;
    fprintf('GPS: NOT FOUND\n');
elseif sum(FMT.GPS.GWk)==0 && sum(FMT.GPS.GMS)==0
    INFO.statusGPS = 0;
    fprintf('GPS: NO LOCK\n');
else
    INFO.statusGPS = 1;
    fprintf('GPS: OK\n');
end



% Detech Flights in FMT
try
idxFlightStart = find(diff(FMT.STAT.isFlying)==1);
idxFlightEnd = find(diff(FMT.STAT.isFlying)==-1);
if length(idxFlightStart) == length(idxFlightEnd)
    INFO.flight.startTimeS = FMT.STAT.TimeS(idxFlightStart);
    INFO.flight.endTimeS = FMT.STAT.TimeS(idxFlightEnd);
    INFO.flight.startTimeLOCAL = INFO.pixhawkstart+FMT.STAT.TimeS(idxFlightStart)./86400;
    INFO.flight.endTimeLOCAL = INFO.pixhawkstart+FMT.STAT.TimeS(idxFlightEnd)./86400;
    INFO.flight.durationS = FMT.STAT.TimeS(idxFlightEnd) - FMT.STAT.TimeS(idxFlightStart);
else
    warning('Flight Log Mismatch.');
    flagError = 1;
end
catch
    warning('Error in Finding Completed Flight Log.');
    flagError = 1;
end


% Detect Mode Change and Split it into Segments
% start old code
ModeChange = [FMT.MODE.TimeS,FMT.MODE.ModeNum]; %Copy mode
ModeChange(:,3) = [diff(FMT.MODE.ModeNum);NaN]; %find diff between mode change
ModeChange(:,4) = FMT.MODE.LineNo;%mode start line index
ModeChange = ModeChange(ModeChange(:,3)~=0,:);
%     ModeChange(:,5) = [ModeChange(2:end,4)-1;nan];
ModeChange(:,6) = [ModeChange(2:end,1)-1;FMT.STAT.TimeS(end)];
% Segment Mode StartTimeUS EndTimeUS isArmed isFlying
Modes = [(1:length(ModeChange(:,1)))',ModeChange(:,[2 1 6])];
% end old code
ModeStr = {'MANUAL','CIRCLE','STABILIZE','TRAINING','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','TUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
INFO.segment.mode = Modes(:,2);
INFO.segment.modeStr = ModeStr(Modes(:,2)+1)';
INFO.segment.modeAbbr = ModeAbbr(Modes(:,2)+1)';
INFO.segment.startTimeS = Modes(:,3);
INFO.segment.endTimeS = Modes(:,4);
INFO.segment.durationS = Modes(:,4)-Modes(:,3);
INFO.segment.startTimeLOCAL = INFO.pixhawkstart+Modes(:,3)./86400;
INFO.segment.endTimeLOCAL = INFO.pixhawkstart+Modes(:,4)./86400;

INFO.startTimeLOCAL = INFO.pixhawkstart+Modes(1,3)./86400;
INFO.endTimeLOCAL = INFO.pixhawkstart+Modes(end,4)./86400;

if flagError ~= 1
    fprintf('Get FMT Info\n');
    fprintf('Flt# Start LT  End LT    Duration  maxGS   maxIAS  maxAGL\n');
    for n = 1:length(INFO.flight.durationS)
        startLT = datestr(INFO.flight.startTimeLOCAL(n),'HH:MM:SS');
        endLT = datestr(INFO.flight.endTimeLOCAL(n),'HH:MM:SS');
        durationmmss = datestr(INFO.flight.durationS(n)./86400,'MM:SS');
        try
            t1 = INFO.flight.startTimeS(n);
            t2 = INFO.flight.endTimeS(n);
            idxARSP = (FMT.ARSP.TimeS >= t1 & FMT.ARSP.TimeS <= t2);
            idxBARO = (FMT.BARO.TimeS >= t1 & FMT.BARO.TimeS <= t2);
            idxGPS = (FMT.GPS.TimeS >= t1 & FMT.GPS.TimeS <= t2);
            maxIAS = max(FMT.ARSP.Airspeed(idxARSP));
            maxAGL = max(FMT.BARO.Alt(idxBARO));
            maxGS = max(FMT.GPS.Spd(idxGPS));
            
        catch
            maxGS = nan;
            maxIAS = nan;
            maxAGL = nan;
        end
        fprintf(' %02d  %s  %s  %s     %5.2f   %5.2f   %5.1f\n',n,startLT,endLT,durationmmss,maxGS,maxIAS,maxAGL);
    end
    fprintf('\n\n');
else
    fprintf('Error in fcnGETINFO\n');
end

end

