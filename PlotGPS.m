function [ tGPS ] = PlotGPS( handle )
%PLOTNAV Summary of this function goes here
%   Detailed explanation goes here
tGPS = struct;
%% Prep GEO
% load('field');
% mstruct = defaultm('mercator');
% mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
% mstruct.geoid = referenceEllipsoid('wgs84','meters');
% mstruct = defaultm(mstruct);
% tGPS.mstruct = mstruct;
% 
% 
% hold(handle,'on')
% % START AND END POINT
% % scatter(handle,x(1),y(1),'ko');
% % scatter(handle,x(end),y(end),'kx');
% % Current POS
% tGPS.POS = scatter(handle,0,0,'go','filled');
% tGPS.POS.MarkerFaceAlpha = 0.8;
% 
% gc = 0.7.*[1,1,1];
% tGPS.FL = plot(handle,0,0,'k--','Color',gc);
% tGPS.RWY = plot(handle,0,0,'k-','Color',gc);
% tGPS.RD = plot(handle,0,0,'k:','Color',gc);
% tGPS.TL = plot(handle,0,0,'k-.','Color',gc);
% 
% hold(handle,'off');




end

