function [ handles ] = fcnFLTPATH( handles )
%DRAWFLTPATH Summary of this function goes here
%   Detailed explanation goes here



handle = handles.DISP.hGPS;

handles.DISP.tGPS.FLTPATH = plot(handle,handles.DATA.SYNCFMT.GPS.X,handles.DATA.SYNCFMT.GPS.Y);
handles.DISP.tGPS.FLTPATH.Color = [1 1 1 0.2];

hold(handle,'on')


% get current limit for later
mapxlim = handle.XLim;
mapylim = handle.YLim;



handles.DISP.tGPS.POS = scatter(handle,0,0,'go','filled');
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
plot(handle,FL_x,FL_y,'k--','Color',gc);
plot(handle,RWY_x,RWY_y,'k-','Color',gc);
plot(handle,RD_x,RD_y,'k:','Color',gc);
plot(handle,TL_x,TL_y,'k-.','Color',gc);







xlim(handle,mapxlim);
ylim(handle,mapylim);
axis(handle,'equal');

handle.YTick = '';
handle.XTick = '';


hold(handle,'off')


end

