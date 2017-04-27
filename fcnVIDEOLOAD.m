function [ VIDEO ] = fcnVIDEOLOAD(  )
%FCNVIDEOLOAD Summary of this function goes here
%   Detailed explanation goes here
VIDEO = load('C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2017-04-23\Videos\PICT0004.mat');
VIDEO.vidObj = VideoReader('C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2017-04-23\Videos\PICT0004.avi');


end






