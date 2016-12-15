function [ tATT ] = PlotATT( handle )
%PLOTARTIFICIALHORIZON Summary of this function goes here
%   Detailed explanation goes here

% Plot Artificial Horizon

% pitch = 5;
% roll = 10;

%%
%plot settings
tATT.SKY = fill(handle,[-10 -10 10 10],[0 10 10 0],[53 72 247]./255);
hold(handle,'on')
tATT.GND = fill(handle,[-10 -10 10 10],[0 -10 -10 0],[174 86 124]./255);


% Pitch lines
tATT.LINE = plot(handle,nan,nan,'k-');

% White Crosshair
plot(handle,[-0.1 0.1],[0 0],'w-','LineWidth',2);
plot(handle,[0 0],[0 0.1],'w-','LineWidth',2);



% Show Text
% Text Box
tATT.t_pitch = text(handle,0.9,0,'-.-');
tATT.t_pitch.FontName = 'Agency FB';
tATT.t_pitch.Color = 'w';
tATT.t_pitch.BackgroundColor = 'k';
tATT.t_pitch.FontSize = 20;
tATT.t_pitch.HorizontalAlignment = 'right';

tATT.t_roll = text(handle,0.1,0.85,'-.-');
tATT.t_roll.FontName = 'Agency FB';
tATT.t_roll.Color = 'w';
tATT.t_roll.BackgroundColor = 'k';
tATT.t_roll.FontSize = 20;
tATT.t_roll.HorizontalAlignment = 'right';



hold(handle,'off');
% % % 
axis(handle,'equal');
ylim(handle,[-1 1]);
xlim(handle,[-1 1]);
axis(handle,'off');
% % % % set(gca,'visible','off');


end

