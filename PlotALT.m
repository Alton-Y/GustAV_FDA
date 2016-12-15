function [ tALT ] = PlotALT( handle )
%PLOTSPD Summary of this function goes here
%   Detailed explanation goes here


tALT.TGTALTTAPE = plot(handle,[-0.45 1],[nan nan],'-m',...
    'LineWidth',2);

handle.YTick = [0:10:300];


handle.TickLength=[0.05 0];
handle.YMinorTick = 'on';
handle.Color = [0.2 0.2 0.2];
handle.XTickLabel = '';
handle.YTickLabel = '';
handle.XTick = [];


handle.XLim = [-0.45 1];
for j = 0:10:300
    text(handle,0,j,sprintf('%i',j),'Clipping','on',...
        'FontSize',12,...
        'FontName','Agency FB',...
        'VerticalAlignment','middle','HorizontalAlignment','right');
end



end

