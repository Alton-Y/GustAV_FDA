function [ handles ] = fcnVIDEOLOAD( handles )
%FCNVIDEOLOAD Summary of this function goes here
%   Detailed explanation goes here
% VIDEO = load('C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2017-04-23\Videos\PICT0004.mat');
VIDEO.vidObj = VideoReader('C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2017-04-23\Videos\GustAV Day 8 Flight 3.mp4');
VIDEO.offsetS = 592.3;
VIDEO.videoStartDatenum = handles.DATA.INFO.pixhawkstart + VIDEO.offsetS/86400;

handles.VIDEO = VIDEO;
end






