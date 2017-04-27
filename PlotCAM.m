function [ tCAM ] = PlotCAM( handle )
%PLOTNAV Summary of this function goes here
%   Detailed explanation goes here
hold(handle,'on');


handle.XTick = [];
handle.XMinorTick = 'off';
handle.YTick = [];



tCAM.IMG = scatter(handle,0,0);


hold(handle,'off');

end



