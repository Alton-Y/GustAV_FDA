% VIDEO = VideoReader('GustAV Day 8 Flight 3.mp4');
clc
clear

% 1) Video File
vidPath = 'C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2017-04-23\Videos\PICT0004.avi';
vidObj = VideoReader(vidPath);

% 2) Select Time to Sync Clock
syncFrame = 10;

% 3) Enter Time of Sync
syncTime = datenum(2017,04,23,17,39,6.7);
videoStartDatenum = syncTime - syncFrame/86400;

% 4) Display Sync Frame
vidObj.CurrentTime = syncFrame;
image(readFrame(vidObj));
axis image
% axis off
title(sprintf('Frame: %.2f\nTime: %s',syncFrame, datestr(syncTime,'YYYY-mm-dd HH:MM:SS.FFF')));
% xlim([600 850]);
% ylim([100 300]);

%% Display any frame
anyFrame = 0;
vidObj.CurrentTime = anyFrame;
image(readFrame(vidObj));
axis image
axis off
title(sprintf('Frame: %.2f\nTime: %s',syncFrame, datestr(videoStartDatenum+anyFrame/86400,'YYYY-mm-dd HH:MM:SS.FFF')));
xlim([300 950]);
ylim([200 500]);

%% Save .mat
clear ans syncFrame syncTime anyFrame
save(strrep(vidPath,'.avi','.mat'))

