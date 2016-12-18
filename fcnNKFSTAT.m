function [ NKFCOLOR ] = fcnNKFSTAT( NKFERR )
%FCNNKFSTAT Summary of this function goes here
%   Detailed explanation goes here

if NKFERR > 1
    NKFCOLOR = [1 0 0];
elseif NKFERR > 0.3
    NKFCOLOR = [1 1 0];
elseif NKFERR >= 0
    NKFCOLOR = [0 1 0];
else 
    NKFCOLOR = [0.5 0.5 0.5];
end


end

