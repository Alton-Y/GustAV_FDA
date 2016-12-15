function [ plotDatenumArray ] = fcnGETFRAMES( startDatenum, endDatenum, fps )
%FCNGETFRAMES Summary of this function goes here
%   Detailed explanation goes here

plotDatenumArray = (startDatenum:1/fps/86400:endDatenum)';




end

