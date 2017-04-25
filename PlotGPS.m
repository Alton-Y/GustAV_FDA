function [ tGPS ] = PlotGPS( handle )
%PLOTNAV Summary of this function goes here
%   Detailed explanation goes here
tGPS = struct;

tGPS.FLTPATH = plot(handle,nan,nan);
tGPS.FLTPATH.Color = [1 1 1 0.2];

hold(handle,'on')

tGPS.FWD = scatter(handle,0,0,[],1,'wo','filled');
tGPS.FWD.MarkerFaceAlpha = 0.5;

tGPS.POS = scatter(handle,0,0,'go','filled');
tGPS.POS.MarkerFaceAlpha = 0.8;






handle.YTick = '';
handle.XTick = '';
hold(handle,'off')

end

