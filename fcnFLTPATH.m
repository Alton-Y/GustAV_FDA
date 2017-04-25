function [ handles ] = fcnFLTPATH( handles )
%DRAWFLTPATH Summary of this function goes here
%   Detailed explanation goes here


cla(handles.DISP.hGPS);

handles.DISP.tGPS.FLTPATH = plot(handles.DISP.hGPS,handles.DATA.SYNCFMT.GPS.X,handles.DATA.SYNCFMT.GPS.Y);
handles.DISP.tGPS.FLTPATH.Color = [1 1 1 0.2];

hold(handles.DISP.hGPS,'on')


% get current limit for later
axis(handles.DISP.hGPS,'equal');
mapxlim = handles.DISP.hGPS.XLim;
mapylim = handles.DISP.hGPS.YLim;

handles.DISP.tGPS.FWD = scatter(handles.DISP.hGPS,0,0,[],1,'wo','filled');
handles.DISP.tGPS.FWD.MarkerFaceAlpha = 0.5;

handles.DISP.tGPS.POS = scatter(handles.DISP.hGPS,0,0,'go','filled');
handles.DISP.tGPS.POS.MarkerFaceAlpha = 0.8;



%
% gray color
gc = 0.7.*[1,1,1];

load('field');
mstruct = defaultm('mercator');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[FL_x,FL_y] = mfwdtran(mstruct, Field.Flightline(:,2),Field.Flightline(:,1));
[RWY_x,RWY_y] = mfwdtran(mstruct, Field.Runway(:,2),Field.Runway(:,1));
[RD_x,RD_y] = mfwdtran(mstruct, Field.Roads(:,2),Field.Roads(:,1));
[TL_x,TL_y] = mfwdtran(mstruct, Field.Treeline(:,2),Field.Treeline(:,1));




handles.DISP.tGPS.FL = plot(handles.DISP.hGPS,FL_x,FL_y,'k--','Color',gc);
handles.DISP.tGPS.RWY = plot(handles.DISP.hGPS,RWY_x,RWY_y,'k-','Color',gc);
handles.DISP.tGPS.RD = plot(handles.DISP.hGPS,RD_x,RD_y,'k:','Color',gc);
handles.DISP.tGPS.TL = plot(handles.DISP.hGPS,TL_x,TL_y,'k-.','Color',gc);



xlim(handles.DISP.hGPS,mapxlim);
ylim(handles.DISP.hGPS,mapylim);

% 
handles.DISP.hGPS.YTick = '';
handles.DISP.hGPS.XTick = '';


hold(handles.DISP.hGPS,'off');


end

