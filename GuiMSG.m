function [ handles ] = GuiMSG( handles, message )
%PLOTMSG Summary of this function goes here
%   Detailed explanation goes here

try 
    handles.MSG(length(handles.MSG)+1,1) = {message};
catch
    handles.MSG = {message};
end
handles.MSG
handles.text_MSG.String = handles.MSG(end:-1:1);



end

