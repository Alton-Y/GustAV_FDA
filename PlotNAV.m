function [ tNAV ] = PlotNAV( handle )
%PLOTNAV Summary of this function goes here
%   Detailed explanation goes here


MAG = 0;
tNAV.X0 = 25;
tNAV.Y0 = -37;

tNAV.Xscale = 0.35;
tNAV.Yscale = 0.315;

tNAV.outerRad = 100;
tNAV.innerRad = 96;
tNAV.textRad = 97;

spacing = 100;
textBearing = [0:10:350]+(MAG);
ang = [2*pi:-2*pi/spacing:0]';
angMark = [2*pi:-2*pi/72:0]'-deg2rad(MAG);

% X Y for Markers
markX = tNAV.X0+(repmat([tNAV.outerRad tNAV.innerRad nan],73,1).*repmat(tNAV.Xscale.*sin(angMark),1,3))';
markY = tNAV.Y0+(repmat([tNAV.outerRad tNAV.innerRad nan],73,1).*repmat(tNAV.Yscale.*cos(angMark),1,3))';

% X Y for Heading Text
textX = tNAV.X0+tNAV.textRad*tNAV.Xscale*sin(angMark);
textY = tNAV.Y0+tNAV.textRad*tNAV.Yscale*cos(angMark);

hdgText = [36:-1:1];


hold(handle,'on')
% Aircraft Center Point (Static)
tNAV.ORIGIN = scatter(handle,tNAV.X0,tNAV.Y0,'wo');
% Outer Ring (Static)
tNAV.OUTER = plot(handle,tNAV.X0+[tNAV.Xscale*tNAV.outerRad*cos(ang)],tNAV.Y0+[tNAV.Yscale*tNAV.outerRad*sin(ang)],'-w',...
    'LineWidth',1);
% Inner Ring (Static)
tNAV.INNER= plot(handle,tNAV.X0+[tNAV.Xscale*tNAV.outerRad./2*cos(ang)],tNAV.Y0+[tNAV.Yscale*tNAV.outerRad./2*sin(ang)],'-w',...
    'LineWidth',1);
% Heading Markers
tNAV.MARKER = plot(handle,markX(:),markY(:),'-w',...
    'LineWidth',1);
for n = 1:36
    tNAV.HDGTEXT(n) = text(handle,textX(n*2-1),textY(n*2-1),sprintf('%02.f',hdgText(n)),...
        'Rotation',textBearing(n),...
        'Clipping','on',...
        'FontSize',13,...
        'FontName','Agency FB',...
        'HorizontalAlignment','center',...
        'VerticalAlignment','top',...
        'Color','w');
end
hold(handle,'off')


end







