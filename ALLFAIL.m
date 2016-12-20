function [ handles ] = ALLFAIL( handles, onoff )
%ALLFAIL Summary of this function goes here
%   Detailed explanation goes here
if onoff == 1
    handles.DISP.tPFD2.FAIL.ATT(1).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ATT(2).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ATT(3).Visible = 'on';
    
    handles.DISP.tPFD2.FAIL.ARSP(1).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ARSP(2).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ARSP(3).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ARSP(4).Visible = 'on';
    
    handles.DISP.tPFD2.FAIL.ALT(1).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ALT(2).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ALT(3).Visible = 'on';
    handles.DISP.tPFD2.FAIL.ALT(4).Visible = 'on';
    
    handles.DISP.tPFD2.FAIL.HDG(1).Visible = 'on';
    handles.DISP.tPFD2.FAIL.HDG(2).Visible = 'on';
    handles.DISP.tPFD2.FAIL.HDG(3).Visible = 'on';
else
    handles.DISP.tPFD2.FAIL.ATT(1).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ATT(2).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ATT(3).Visible = 'off';
    
    handles.DISP.tPFD2.FAIL.ARSP(1).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ARSP(2).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ARSP(3).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ARSP(4).Visible = 'off';
    
    handles.DISP.tPFD2.FAIL.ALT(1).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ALT(2).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ALT(3).Visible = 'off';
    handles.DISP.tPFD2.FAIL.ALT(4).Visible = 'off';
    
    handles.DISP.tPFD2.FAIL.HDG(1).Visible = 'off';
    handles.DISP.tPFD2.FAIL.HDG(2).Visible = 'off';
    handles.DISP.tPFD2.FAIL.HDG(3).Visible = 'off';
end

end

