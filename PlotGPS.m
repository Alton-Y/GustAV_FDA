function [ tGPS ] = PlotGPS( handle )
%PLOTNAV Summary of this function goes here
%   Detailed explanation goes here

%% Prep GEO
load('field');
mstruct = defaultm('mercator');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
tGPS.mstruct = mstruct;
% [x,y] = mfwdtran(mstruct, SYNCFMT.GPS.Lat, SYNCFMT.GPS.Lng);

tGPS.FLTPATH = plot(handle,0,0);
tGPS.FLTPATH.Color = [1 1 1 0.2];

hold(handle,'on')
% START AND END POINT
% scatter(handle,x(1),y(1),'ko');
% scatter(handle,x(end),y(end),'kx');
% Current POS
tGPS.POS = scatter(handle,0,0,'go','filled');
tGPS.POS.MarkerFaceAlpha = 0.8;



hold(handle,'off');




end

