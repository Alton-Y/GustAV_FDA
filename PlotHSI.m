function [ tHSI ] = PlotHSI( handle )
%PLOTHSI Summary of this function goes here
%   Detailed explanation goes here

hold(handle,'on');

handle.YLim = [0 1];
handle.XTick = (-90:10:360+90);
handle.TickLength=[0.05 0];
handle.XMinorTick = 'off';
handle.YTick = [];
handle.Color = [0.2 0.2 0.2];


% XLIM and Heading Scale Text
HDG = 0;
handle.XLim = [HDG-25 HDG+25];
j1 = [1:36,1:36,1:36];
for j = 1:36*3
    if rem(j,3) == 0
        fontsize = 13;
    else
        fontsize = 10.5;
    end
    text(handle,j*10-360,0.8,sprintf('%i',j1(j)),'Clipping','on',...
        'FontSize',fontsize,...
        'FontName','Agency FB',...
        'VerticalAlignment','top','HorizontalAlignment','center');
end



% TRK Heading Green Diamond
tHSI.TRK = scatter(handle,[-360 0 360]+0,[0 0 0]+0.9,'g',...
    'Marker','diamond',...
    'SizeData',40,'LineWidth',1.5);

% TARGET Heading Magenta Cross
tHSI.TGT = scatter(handle,[-360 0 360]+0,[0 0 0]+0.9,'m',...
    'Marker','+',...
    'SizeData',60,'LineWidth',1.5);

hold(handle,'off');

end

