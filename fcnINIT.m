function [ handles ] = fcnINIT( handles )
%Initialize the figure setup
%   Detailed explanation goes here

handles.text2.String = 'READY';
handles.CurrentIdx = 1;

handles.DISP.hTOP  = fcnSETFIG([0.00 0.90 1.00 0.10]);
handles.DISP.hPFD  = fcnSETFIG([0.50 0.45 0.25 0.45]);
handles.DISP.hATT  = fcnSETFIG([0.55 0.53 0.15 0.27]);
handles.DISP.hSPD  = fcnSETFIG([0.45 0.53 0.10 0.27]);
handles.DISP.hALT  = fcnSETFIG([0.70 0.53 0.10 0.27]);
handles.DISP.hVSI  = fcnSETFIG([0.735 0.53 0.015 0.27]);
handles.DISP.hPFD2  = fcnSETFIG([0.50 0.45 0.25 0.45]);
handles.DISP.hPFD2.Visible = 'off';
handles.DISP.hSTAT = fcnSETFIG([0.75 0.45 0.25 0.45]);
handles.DISP.hFCTL = fcnSETFIG([0.00 0.00 0.25 0.45]);
handles.DISP.hNAV  = fcnSETFIG([0.50 0.00 0.25 0.45]);
handles.DISP.hENG  = fcnSETFIG([0.25 0.30 0.25 0.15]);
handles.DISP.hELEC = fcnSETFIG([0.25 0.00 0.25 0.30]);
handles.DISP.hGPS  = fcnSETFIG([0.75 0.00 0.25 0.45]);
handles.DISP.hVID  = fcnSETFIG([0.00 0.45 0.50 0.45]);

% handles.tGPS  = PlotGPS(handles.hGPS,handles.SYNCFMT);
% handles.tGPS.FLTPATH.Color = [1 1 1 0.2];

handles.DISP.tTOP  = PlotTOP(handles.DISP.hTOP);
handles.DISP.tELEC = PlotELEC(handles.DISP.hELEC);
handles.DISP.tFCTL = PlotFCTL(handles.DISP.hFCTL);
handles.DISP.tPFD  = PlotPFD(handles.DISP.hPFD);
handles.DISP.tPFD2 = PlotPFD2(handles.DISP.hPFD2);

handles.DISP.tENG = PlotENG(handles.DISP.hENG);
handles.DISP.tSPD = PlotSPD(handles.DISP.hSPD);
handles.DISP.tALT = PlotALT(handles.DISP.hALT);
handles.DISP.tATT = PlotATT(handles.DISP.hATT);
handles.DISP.tVSI = PlotVSI(handles.DISP.hVSI);

fcnTITLE( handles.DISP.hFCTL, 'FCTL' )
fcnTITLE( handles.DISP.hENG, 'ENG' )
fcnTITLE( handles.DISP.hELEC, 'ELEC' )

[handles] = GuiMSG(handles,'READY');

    
end

