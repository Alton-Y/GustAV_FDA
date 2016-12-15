function [ tSPD ] = PlotSPD( handle )
%PLOTSPD Summary of this function goes here
%   Detailed explanation goes here

tSPD.TGTSPDTAPE = plot(handle,[-1 0.45],[nan nan],'-m',...
    'LineWidth',2);

handle.XLim = [-1 0.45];
handle.YTick = [0:2:50];
handle.TickLength=[0.05 0];
handle.YMinorTick = 'on';
handle.XTick = [];
handle.Color = [0.2 0.2 0.2];


for j = 0:2:30
    text(handle,0.1,j,sprintf('%i',j),'Clipping','on',...
        'FontSize',12,...
        'FontName','Agency FB',...
        'VerticalAlignment','middle','HorizontalAlignment','right');
end

end

