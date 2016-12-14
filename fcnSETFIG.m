function [ h ] = fcnSETFIG( Position )
%HSETUP Summary of this function goes here
%   Detailed explanation goes here
h = axes('Position',Position,...
    'Units','normalized',...
    'Box','on',...
    'XTickLabel','','YTickLabel','',...
    'XTick',[],'YTick',[]);
%     'XTickLabel','','YTickLabel','',...
xlim(h,[0 Position(3)*100*2])
ylim(h,[-Position(4)*100 0])

plot(h,[],[],'-k')
% h.Visible = 'off';
% grid(h,'on');
% h.XTick = [0:1:Position(3)*100*2];
% h.YTick = [-Position(4)*100:1:0];



end

