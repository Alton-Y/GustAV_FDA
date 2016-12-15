function [ tVSI ] = PlotVSI( handle )
%PLOTVSI Summary of this function goes here
%   Detailed explanation goes here
handle.Color = [0.2 0.2 0.2];

VSI = 0;
pwr = 1/2.2;

% VSI Scale Markers
vsiMarkersY = [1 2 4 8].^pwr;
vsiMarkersY = [vsiMarkersY;vsiMarkersY;nan(1,4)];
vsiMarkersX = [zeros(1,4)+0.2;zeros(1,4)+0.5;nan(1,4);];



hold(handle,'on')
% VSI Scale Markers
plot(handle,vsiMarkersX,vsiMarkersY,'-w');
plot(handle,vsiMarkersX,-vsiMarkersY,'-w');

% VSI Green Line
tVSI.GREENLINE = plot(handle,[3 0.25],[0 -VSI^pwr],'-g','LineWidth',2);

% Yellow Datum
plot(handle,[1 0],[0 0],'-y','LineWidth',1.25);

handle.XLim = [0 1];
handle.YLim = [-15^pwr 15^pwr];

hold(handle,'off')



end

