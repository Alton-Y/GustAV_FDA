function [ INOP ] = fcnINOP( FMT )
%FCNINOP Summary of this function goes here
%   Detailed explanation goes here

INOP = struct;
% Check ARSP INOP
if max(FMT.ARSP.Airspeed) < 0.001
    INOP.ARSP = true;
else
    INOP.ARSP = false;
end

end

